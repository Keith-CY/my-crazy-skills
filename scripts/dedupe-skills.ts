import { existsSync, lstatSync, mkdirSync, readdirSync, rmSync, symlinkSync, writeFileSync } from "node:fs";
import path from "node:path";

type Submodule = {
  name: string;
  relPath: string;
  url: string;
  urlNormalized: string;
  gitlinkSha: string | null;
};

function usage(): never {
  // eslint-disable-next-line no-console
  console.error(
    [
      "Usage:",
      "  bun scripts/dedupe-skills.ts [--root <repoRoot>] [--out <skillsSubdir>] [--dry-run]",
      "",
      "Defaults:",
      "  --root = current working directory",
      "  --out  = skills/.deduped",
    ].join("\n"),
  );
  process.exit(2);
}

function parseArgs(argv: string[]) {
  const args = {
    root: process.cwd(),
    out: "skills/.deduped",
    dryRun: false,
  };

  for (let index = 0; index < argv.length; index++) {
    const value = argv[index];
    if (value === "--root") {
      const next = argv[index + 1];
      if (!next) usage();
      args.root = next;
      index++;
      continue;
    }
    if (value === "--out") {
      const next = argv[index + 1];
      if (!next) usage();
      args.out = next;
      index++;
      continue;
    }
    if (value === "--dry-run") {
      args.dryRun = true;
      continue;
    }
    if (value === "-h" || value === "--help") usage();
    usage();
  }

  return args;
}

function normalizeGitUrl(url: string): string {
  const trimmed = url.trim();
  if (!trimmed) return trimmed;
  return trimmed.replace(/\.git$/i, "");
}

function runGit(repoRoot: string, args: string[]) {
  const proc = Bun.spawnSync(["git", ...args], {
    cwd: repoRoot,
    stdout: "pipe",
    stderr: "pipe",
  });
  const stdout = proc.stdout ? new TextDecoder().decode(proc.stdout).trim() : "";
  const stderr = proc.stderr ? new TextDecoder().decode(proc.stderr).trim() : "";
  return { exitCode: proc.exitCode, stdout, stderr };
}

function readSubmodules(repoRoot: string): Submodule[] {
  const gitmodulesPath = path.join(repoRoot, ".gitmodules");
  if (!existsSync(gitmodulesPath)) return [];

  const { exitCode, stdout, stderr } = runGit(repoRoot, [
    "config",
    "-f",
    ".gitmodules",
    "--get-regexp",
    "^submodule\\..*\\.(path|url)$",
  ]);
  if (exitCode !== 0) {
    throw new Error(`Failed to read .gitmodules via git config: ${stderr}`);
  }

  const raw: Record<string, Partial<Submodule>> = {};
  for (const line of stdout.split("\n").filter(Boolean)) {
    const [key, ...rest] = line.split(" ");
    const value = rest.join(" ").trim();
    const match = key.match(/^submodule\.(.+)\.(path|url)$/);
    if (!match) continue;
    const name = match[1];
    const field = match[2];
    raw[name] ??= { name };
    if (field === "path") raw[name].relPath = value;
    if (field === "url") raw[name].url = value;
  }

  const submodules: Submodule[] = [];
  for (const [name, info] of Object.entries(raw)) {
    if (!info.relPath || !info.url) continue;
    const relPath = info.relPath;
    const url = info.url;
    const urlNormalized = normalizeGitUrl(url);

    // Prefer reading from git tree so this works even if submodules aren't checked out.
    const tree = runGit(repoRoot, ["ls-tree", "HEAD", "--", relPath]);
    const gitlinkSha = tree.exitCode === 0 && tree.stdout ? tree.stdout.split(/\s+/)[2] ?? null : null;

    submodules.push({
      name,
      relPath,
      url,
      urlNormalized,
      gitlinkSha,
    });
  }
  return submodules;
}

function pickCanonical(paths: string[]): string {
  const priorityPrefixes = [
    "skills/platforms/",
    "skills/tooling/",
    "skills/workflows/",
    "skills/publishing/",
    "skills/research/",
    "skills/frontend/",
    "skills/devops/",
    "skills/coding/",
    "skills/learning/",
    "skills/creative/",
    "skills/general/",
    "skills/popular/",
  ];

  for (const prefix of priorityPrefixes) {
    const candidates = paths.filter((p) => p.startsWith(prefix));
    if (candidates.length > 0) return candidates.slice().sort()[0];
  }

  return paths.slice().sort()[0];
}

function isDirectory(p: string): boolean {
  try {
    return lstatSync(p).isDirectory();
  } catch {
    return false;
  }
}

function safeRelSymlinkTarget(fromAbs: string, toAbs: string): string {
  const rel = path.relative(path.dirname(fromAbs), toAbs);
  return rel || ".";
}

function main() {
  const { root, out, dryRun } = parseArgs(process.argv.slice(2));
  const repoRoot = path.resolve(root);
  const skillsRoot = path.join(repoRoot, "skills");
  const outAbs = path.resolve(repoRoot, out);

  if (!existsSync(skillsRoot) || !isDirectory(skillsRoot)) {
    throw new Error(`skills/ directory not found at: ${skillsRoot}`);
  }

  const submodules = readSubmodules(repoRoot);

  // Build duplicate groups by normalized URL + gitlink SHA (only dedupe when *both* match).
  const groups = new Map<string, string[]>();
  const pathToKey = new Map<string, string>();
  for (const sm of submodules) {
    if (!sm.gitlinkSha) continue;
    const key = `${sm.urlNormalized}@${sm.gitlinkSha}`;
    groups.set(key, [...(groups.get(key) ?? []), sm.relPath]);
    pathToKey.set(sm.relPath, key);
  }

  const duplicates: Array<{ key: string; canonical: string; duplicates: string[] }> = [];
  const exclude = new Set<string>();

  for (const [key, paths] of groups.entries()) {
    if (paths.length <= 1) continue;
    const canonical = pickCanonical(paths);
    const dupes = paths.filter((p) => p !== canonical);
    duplicates.push({ key, canonical, duplicates: dupes });
    for (const dupe of dupes) exclude.add(dupe);
  }

  const manifest = {
    generatedAt: new Date().toISOString(),
    repoRoot,
    out: path.relative(repoRoot, outAbs),
    excludedSubmodulePaths: Array.from(exclude).sort(),
    duplicateGroups: duplicates
      .slice()
      .sort((a, b) => a.key.localeCompare(b.key))
      .map((g) => ({
        key: g.key,
        canonical: g.canonical,
        duplicates: g.duplicates.slice().sort(),
      })),
  };

  if (dryRun) {
    // eslint-disable-next-line no-console
    console.log(JSON.stringify(manifest, null, 2));
    return;
  }

  rmSync(outAbs, { recursive: true, force: true });
  mkdirSync(outAbs, { recursive: true });

  // Symlink everything under skills/, excluding duplicates and the output folder itself.
  // This avoids changing repo structure while ensuring the *installed* tree is unique.
  const entries = readdirSync(skillsRoot, { withFileTypes: true });
  for (const entry of entries) {
    if (!entry.isDirectory()) continue;
    if (entry.name === path.basename(outAbs)) continue;

    const categoryAbs = path.join(skillsRoot, entry.name);
    const categoryRel = path.relative(repoRoot, categoryAbs);
    const outCategoryAbs = path.join(outAbs, entry.name);
    mkdirSync(outCategoryAbs, { recursive: true });

    const children = readdirSync(categoryAbs, { withFileTypes: true });
    for (const child of children) {
      if (!child.isDirectory()) continue;
      const childAbs = path.join(categoryAbs, child.name);
      const childRel = path.relative(repoRoot, childAbs);
      if (exclude.has(childRel)) continue;

      const outChildAbs = path.join(outCategoryAbs, child.name);
      const linkTarget = safeRelSymlinkTarget(outChildAbs, childAbs);
      symlinkSync(linkTarget, outChildAbs, process.platform === "win32" ? "junction" : "dir");
    }
  }

  writeFileSync(path.join(outAbs, "MANIFEST.json"), JSON.stringify(manifest, null, 2) + "\n");

  // eslint-disable-next-line no-console
  console.log(
    `Generated ${path.relative(repoRoot, outAbs)} (excluded ${manifest.excludedSubmodulePaths.length} duplicate submodules)`,
  );
}

main();
