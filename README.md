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
  - [`anthropics--skills`](https://github.com/anthropics/skills.git)
  - [`better-auth--skills`](https://github.com/better-auth/skills.git)
  - [`callstackincubator--agent-skills`](https://github.com/callstackincubator/agent-skills.git)
  - [`coreyhaines31--marketingskills`](https://github.com/coreyhaines31/marketingskills.git)
  - [`expo--skills`](https://github.com/expo/skills.git)
  - [`remotion-dev--skills`](https://github.com/remotion-dev/skills.git)
  - [`vercel-labs--agent-browser`](https://github.com/vercel-labs/agent-browser.git)
  - [`vercel-labs--agent-skills`](https://github.com/vercel-labs/agent-skills.git)
- [`skills/publishing/`](skills/publishing/)
  - [`x-article-publisher-skill`](https://github.com/wshuyi/x-article-publisher-skill)
- [`skills/research/`](skills/research/)
  - [`ipsw-skill`](https://github.com/blacktop/ipsw-skill)
  - [`notebooklm-py`](https://github.com/teng-lin/notebooklm-py)
  - [`notebooklm-skill`](https://github.com/PleasePrompto/notebooklm-skill)
- [`skills/tooling/`](skills/tooling/)
  - [`agent-browser`](skills/tooling/agent-browser)
  - [`agent-skills`](https://github.com/vercel-labs/agent-skills)
  - [`claude-code-templates`](https://github.com/davila7/claude-code-templates)
  - [`design-engineer-auditor-package`](https://github.com/kylezantos/design-engineer-auditor-package)
  - [`mcp-progressive-agentskill`](https://github.com/cablate/mcp-progressive-agentskill)
  - [`skills`](https://github.com/anthropics/skills)
- [`skills/workflows/`](skills/workflows/)
  - [`planning-with-files`](https://github.com/OthmanAdi/planning-with-files)
  - [`superpowers`](https://github.com/obra/superpowers)
<!-- SKILLS-LIST:END -->
