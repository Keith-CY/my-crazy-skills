# my-crazy-skills

## Quick install

**Run this once to link skills globally for Codex:**

```bash
curl -fsSL https://raw.githubusercontent.com/Keith-CY/my-crazy-skills/main/INSTALL.sh | sh
```

Notes:
- `curl | sh` auto-clones to `~/.cache/my-crazy-skills` if no local `skills/` is found.
- Target other agents:
  - Claude:
    ```bash
    curl -fsSL https://raw.githubusercontent.com/Keith-CY/my-crazy-skills/main/INSTALL.sh | sh -s -- --claude
    ```
  - Gemini:
    ```bash
    curl -fsSL https://raw.githubusercontent.com/Keith-CY/my-crazy-skills/main/INSTALL.sh | sh -s -- --gemini
    ```
  - OpenCode:
    ```bash
    curl -fsSL https://raw.githubusercontent.com/Keith-CY/my-crazy-skills/main/INSTALL.sh | sh -s -- --opencode
    ```
- Per-project link (Codex example):
  ```bash
  curl -fsSL https://raw.githubusercontent.com/Keith-CY/my-crazy-skills/main/INSTALL.sh | sh -s -- --project /path/to/project
  ```
- Per-project + target (Claude example):
  ```bash
  curl -fsSL https://raw.githubusercontent.com/Keith-CY/my-crazy-skills/main/INSTALL.sh | sh -s -- --claude --project /path/to/project
  ```

Collection of AI skills tracked as git submodules. Categories live under `skills/` and reflect the current organization.

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
- [`skills/learning/`](skills/learning/)
  - [`33-js-concepts`](https://github.com/leonardomso/33-js-concepts)
- [`skills/platforms/`](skills/platforms/)
  - [`clawdhub`](https://github.com/clawdbot/clawdhub)
  - [`marketplace`](https://github.com/aiskillstore/marketplace)
- [`skills/publishing/`](skills/publishing/)
  - [`x-article-publisher-skill`](https://github.com/wshuyi/x-article-publisher-skill)
- [`skills/research/`](skills/research/)
  - [`ipsw-skill`](https://github.com/blacktop/ipsw-skill)
  - [`notebooklm-skill`](https://github.com/PleasePrompto/notebooklm-skill)
- [`skills/tooling/`](skills/tooling/)
  - [`agent-skills`](https://github.com/vercel-labs/agent-skills)
  - [`claude-code-templates`](https://github.com/davila7/claude-code-templates)
  - [`design-engineer-auditor-package`](https://github.com/kylezantos/design-engineer-auditor-package)
  - [`mcp-progressive-agentskill`](https://github.com/cablate/mcp-progressive-agentskill)
  - [`skills`](https://github.com/anthropics/skills)
- [`skills/workflows/`](skills/workflows/)
  - [`planning-with-files`](https://github.com/OthmanAdi/planning-with-files)
  - [`superpowers`](https://github.com/obra/superpowers)
<!-- SKILLS-LIST:END -->
