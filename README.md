# my-crazy-skills

## Quick install

**Run this once to link skills globally for Codex:**

```bash
curl -fsSL https://raw.githubusercontent.com/Keith-CY/my-crazy-skills/main/INSTALL.sh | sh
```

Notes:
- If you want a per-project link instead of global, download `INSTALL.sh` and run `./INSTALL.sh --project /path/to/project`.

Collection of AI skills tracked as git submodules. Categories live under `skills/` and reflect the current organization.

## Layout

Auto-generated from the `skills/` directory.

<!-- SKILLS-LIST:START -->
- [`skills/creative/`](skills/creative/)
  - [`skill-prompt-generator`](skills/creative/skill-prompt-generator)
- [`skills/frontend/`](skills/frontend/)
  - [`ui-skills`](skills/frontend/ui-skills)
  - [`ui-ux-pro-max-skill`](skills/frontend/ui-ux-pro-max-skill)
- [`skills/general/`](skills/general/)
  - [`claude-skills`](skills/general/claude-skills)
- [`skills/learning/`](skills/learning/)
  - [`33-js-concepts`](skills/learning/33-js-concepts)
- [`skills/platforms/`](skills/platforms/)
  - [`clawdhub`](skills/platforms/clawdhub)
  - [`marketplace`](skills/platforms/marketplace)
- [`skills/publishing/`](skills/publishing/)
  - [`x-article-publisher-skill`](skills/publishing/x-article-publisher-skill)
- [`skills/research/`](skills/research/)
  - [`ipsw-skill`](skills/research/ipsw-skill)
  - [`notebooklm-skill`](skills/research/notebooklm-skill)
- [`skills/tooling/`](skills/tooling/)
  - [`agent-skills`](skills/tooling/agent-skills)
  - [`claude-code-templates`](skills/tooling/claude-code-templates)
  - [`design-engineer-auditor-package`](skills/tooling/design-engineer-auditor-package)
  - [`mcp-progressive-agentskill`](skills/tooling/mcp-progressive-agentskill)
  - [`skills`](skills/tooling/skills)
- [`skills/workflows/`](skills/workflows/)
  - [`planning-with-files`](skills/workflows/planning-with-files)
  - [`superpowers`](skills/workflows/superpowers)
<!-- SKILLS-LIST:END -->

## Getting started

Clone with submodules:

```bash
git clone --recurse-submodules <repo_url>
```

If you already cloned:

```bash
git submodule update --init --recursive
```

## Add a skill

```bash
git submodule add <repository_url> skills/<category>/<skill_name>
```

Example:

```bash
git submodule add https://github.com/example/playwright-skill skills/frontend/playwright
```

## Updates

Submodules are automatically updated daily via GitHub Actions.
