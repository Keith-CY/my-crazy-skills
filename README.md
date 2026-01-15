# my-crazy-skills

## Quick install

**Run this once to link skills globally for Codex:**

```bash
curl -fsSL https://raw.githubusercontent.com/Keith-CY/my-crazy-skills/main/INSTALL.sh | sh
```

Notes:
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
