# my-crazy-skills

[![OpenCode Security Scan](https://github.com/Keith-CY/my-crazy-skills/actions/workflows/opencode-security-scan.yml/badge.svg?branch=main)](https://github.com/Keith-CY/my-crazy-skills/actions/workflows/opencode-security-scan.yml)

Collection of AI "skills" tracked as git submodules. Categories live under `skills/` and reflect the current organization.

This repo is meant to be *linked* into an agent's skills directory (global or per-project) via `INSTALL.sh`.

## Install

### Quick install (curl)

If you use `curl | sh`, consider inspecting `INSTALL.sh` first.

```bash
curl -fsSL https://raw.githubusercontent.com/Keith-CY/my-crazy-skills/main/INSTALL.sh | sh
```

By default this links skills globally for Codex (`~/.codex/skills`).

### Install from a local clone (recommended)

```bash
git clone --recurse-submodules https://github.com/Keith-CY/my-crazy-skills
cd my-crazy-skills
./INSTALL.sh --help
./INSTALL.sh
```

### Notes and examples

- If no local `skills/` directory is found, the installer auto-clones to `~/.cache/my-crazy-skills`.
- Existing non-symlink destinations are backed up with a `.bak.<timestamp>` suffix.
- If `bun` is available, the installer can generate a de-duplicated tree at `skills/.deduped` (same upstream repo + same commit only) to avoid double-listed skills.
  - `skills/.deduped` is a hidden directory (note the leading `.`). Use `ls -la skills` (or Finder `Cmd+Shift+.`) to view it.
  - The generated `skills/.deduped/MANIFEST.json` is just metadata about what was de-duplicated.
  - Force-generate only: `./INSTALL.sh --dedupe-only`
  - Force raw skills (no dedupe): `./INSTALL.sh --no-dedupe`
  - Force regenerate: `./INSTALL.sh --dedupe --dedupe-force`
  - If `bun` is installed but not on `PATH`, use `BUN_BIN=/path/to/bun` (common: `BUN_BIN=$HOME/.bun/bin/bun`).
- Target other agents:
  - Claude: `curl -fsSL https://raw.githubusercontent.com/Keith-CY/my-crazy-skills/main/INSTALL.sh | sh -s -- --claude`
  - Gemini: `curl -fsSL https://raw.githubusercontent.com/Keith-CY/my-crazy-skills/main/INSTALL.sh | sh -s -- --gemini`
  - OpenCode: `curl -fsSL https://raw.githubusercontent.com/Keith-CY/my-crazy-skills/main/INSTALL.sh | sh -s -- --opencode`
- Per-project link (Codex example): `curl -fsSL https://raw.githubusercontent.com/Keith-CY/my-crazy-skills/main/INSTALL.sh | sh -s -- --project /path/to/project`
- Per-project + target (Claude example): `curl -fsSL https://raw.githubusercontent.com/Keith-CY/my-crazy-skills/main/INSTALL.sh | sh -s -- --claude --project /path/to/project`

## Updating

- Local clone: `git pull --recurse-submodules` (or `git submodule update --init --recursive`).
- `curl | sh` installs: re-run the installer (it reuses `~/.cache/my-crazy-skills` if present).
- GitHub Actions: `Sync Popular Skills from skills.sh` (`.github/workflows/update-skills-from-skills-sh.yml`) can add/update popular skill sources as submodules under `skills/popular/`.

## Development

- If you use `git worktree`, keep worktrees under `.worktree/` (gitignored) and remove the worktree + branch after merging.
- If you need Node.js tooling locally, prefer `bun` over `npm`/`pnpm`/`yarn`.

## Layout

Auto-generated from the `skills/` directory.

<!-- SKILLS-LIST:START -->
- [`skills/creative/`](skills/creative/)
  - [`skill-prompt-generator`](https://github.com/huangserva/skill-prompt-generator)
- [`skills/frontend/`](skills/frontend/)
  - [`ui-skills`](https://github.com/ibelick/ui-skills)
  - [`ui-ux-pro-max-skill`](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)
- [`skills/general/`](skills/general/)
  - [`claude-skills`](https://github.com/alirezarezvani/claude-skills)
  - [`clawdhub`](https://github.com/clawdbot/clawdhub)
  - [`ipsw-skill`](https://github.com/blacktop/ipsw-skill)
  - [`mcp-progressive-agentskill`](https://github.com/cablate/mcp-progressive-agentskill)
- [`skills/learning/`](skills/learning/)
  - [`33-js-concepts`](https://github.com/leonardomso/33-js-concepts)
- [`skills/platforms/`](skills/platforms/)
  - [`clawdhub`](https://github.com/clawdbot/clawdhub)
  - [`marketplace`](https://github.com/aiskillstore/marketplace)
- [`skills/popular/`](skills/popular/)
  - [`antfu--skills`](https://github.com/antfu/skills.git)
  - [`anthropics--claude-code`](https://github.com/anthropics/claude-code.git)
  - [`anthropics--skills`](https://github.com/anthropics/skills.git)
  - [`atxp-dev--cli`](https://github.com/atxp-dev/cli.git)
  - [`avdlee--swiftui-agent-skill`](https://github.com/avdlee/swiftui-agent-skill.git)
  - [`benjitaylor--agentation`](https://github.com/benjitaylor/agentation.git)
  - [`better-auth--skills`](https://github.com/better-auth/skills.git)
  - [`browser-use--browser-use`](https://github.com/browser-use/browser-use.git)
  - [`callstackincubator--agent-skills`](https://github.com/callstackincubator/agent-skills.git)
  - [`coreyhaines31--marketingskills`](https://github.com/coreyhaines31/marketingskills.git)
  - [`expo--skills`](https://github.com/expo/skills.git)
  - [`f--awesome-chatgpt-prompts`](https://github.com/f/awesome-chatgpt-prompts.git)
  - [`firecrawl--cli`](https://github.com/firecrawl/cli.git)
  - [`giuseppe-trisciuoglio--developer-kit`](https://github.com/giuseppe-trisciuoglio/developer-kit.git)
  - [`google-gemini--gemini-cli`](https://github.com/google-gemini/gemini-cli.git)
  - [`google-labs-code--stitch-skills`](https://github.com/google-labs-code/stitch-skills.git)
  - [`hyf0--vue-skills`](https://github.com/hyf0/vue-skills.git)
  - [`inference-sh--skills`](https://github.com/inference-sh/skills.git)
  - [`intellectronica--agent-skills`](https://github.com/intellectronica/agent-skills.git)
  - [`jezweb--claude-skills`](https://github.com/jezweb/claude-skills.git)
  - [`jimliu--baoyu-skills`](https://github.com/jimliu/baoyu-skills.git)
  - [`kadajett--agent-nestjs-skills`](https://github.com/kadajett/agent-nestjs-skills.git)
  - [`langgenius--dify`](https://github.com/langgenius/dify.git)
  - [`napoleond--clawdirect`](https://github.com/napoleond/clawdirect.git)
  - [`napoleond--instaclaw`](https://github.com/napoleond/instaclaw.git)
  - [`nextlevelbuilder--ui-ux-pro-max-skill`](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git)
  - [`obra--superpowers`](https://github.com/obra/superpowers.git)
  - [`onmax--nuxt-skills`](https://github.com/onmax/nuxt-skills.git)
  - [`op7418--humanizer-zh`](https://github.com/op7418/humanizer-zh.git)
  - [`othmanadi--planning-with-files`](https://github.com/othmanadi/planning-with-files.git)
  - [`remotion-dev--skills`](https://github.com/remotion-dev/skills.git)
  - [`resend--email-best-practices`](https://github.com/resend/email-best-practices.git)
  - [`resend--react-email`](https://github.com/resend/react-email.git)
  - [`sickn33--antigravity-awesome-skills`](https://github.com/sickn33/antigravity-awesome-skills.git)
  - [`softaworks--agent-toolkit`](https://github.com/softaworks/agent-toolkit.git)
  - [`squirrelscan--skills`](https://github.com/squirrelscan/skills.git)
  - [`subsy--ralph-tui`](https://github.com/subsy/ralph-tui.git)
  - [`supabase--agent-skills`](https://github.com/supabase/agent-skills.git)
  - [`vercel--ai`](https://github.com/vercel/ai.git)
  - [`vercel--turborepo`](https://github.com/vercel/turborepo.git)
  - [`vercel-labs--agent-browser`](https://github.com/vercel-labs/agent-browser.git)
  - [`vercel-labs--agent-skills`](https://github.com/vercel-labs/agent-skills.git)
  - [`vercel-labs--next-skills`](https://github.com/vercel-labs/next-skills.git)
  - [`vercel-labs--skills`](https://github.com/vercel-labs/skills.git)
  - [`vuejs-ai--skills`](https://github.com/vuejs-ai/skills.git)
  - [`wshobson--agents`](https://github.com/wshobson/agents.git)
  - [`zackkorman--skills`](https://github.com/zackkorman/skills.git)
- [`skills/publishing/`](skills/publishing/)
  - [`x-article-publisher-skill`](https://github.com/wshuyi/x-article-publisher-skill)
- [`skills/research/`](skills/research/)
  - [`ipsw-skill`](https://github.com/blacktop/ipsw-skill)
  - [`notebooklm-py`](https://github.com/teng-lin/notebooklm-py)
  - [`notebooklm-skill`](https://github.com/PleasePrompto/notebooklm-skill)
- [`skills/tooling/`](skills/tooling/)
  - [`agent-browser`](skills/tooling/agent-browser)
  - [`agent-skills`](https://github.com/vercel-labs/agent-skills)
  - [`ciembor--agent-rules-books`](https://github.com/ciembor/agent-rules-books)
  - [`claude-code-templates`](https://github.com/davila7/claude-code-templates)
  - [`design-engineer-auditor-package`](https://github.com/kylezantos/design-engineer-auditor-package)
  - [`mcp-progressive-agentskill`](https://github.com/cablate/mcp-progressive-agentskill)
  - [`resend--email-best-practices`](https://github.com/resend/email-best-practices)
  - [`skills`](https://github.com/anthropics/skills)
- [`skills/workflows/`](skills/workflows/)
  - [`planning-with-files`](https://github.com/OthmanAdi/planning-with-files)
  - [`superpowers`](https://github.com/obra/superpowers)
<!-- SKILLS-LIST:END -->
