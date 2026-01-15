# my-crazy-skills

Collection of AI skills tracked as git submodules. Categories live under `skills/` and reflect the current organization.

## Layout

Auto-generated from the `skills/` directory.

<!-- SKILLS-LIST:START -->
- `skills/creative/`
  - `skill-prompt-generator`
- `skills/frontend/`
  - `ui-ux-pro-max-skill`
- `skills/general/`
  - `claude-skills`
- `skills/learning/`
  - `33-js-concepts`
- `skills/platforms/`
  - `clawdhub`
  - `marketplace`
- `skills/publishing/`
  - `x-article-publisher-skill`
- `skills/research/`
  - `ipsw-skill`
  - `notebooklm-skill`
- `skills/tooling/`
  - `agent-skills`
  - `claude-code-templates`
  - `mcp-progressive-agentskill`
  - `skills`
- `skills/workflows/`
  - `planning-with-files`
  - `superpowers`
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
