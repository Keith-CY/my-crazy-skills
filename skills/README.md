# Skills Organization

This directory contains AI skills organized by category. Each skill is added as a git submodule to stay aligned with its upstream repository.

## Directory Structure

- `learning/`: Learning resources and concept guides.
- `frontend/`: UI/UX engineering, CSS/styling, and component development.
- `creative/`: Creative tooling such as prompt generation.
- `research/`: Research, analysis, and domain-specific investigation tools.
- `tooling/`: Agent tooling, templates, and skill libraries.
- `workflows/`: Structured workflows for planning and delivery.
- `platforms/`: Skill registries and marketplaces.
- `publishing/`: Writing and publishing automation.

## Adding a New Skill

To add a new skill, add it as a submodule under the appropriate category:

```bash
git submodule add <repository_url> skills/<category>/<skill_name>
```

Example:
```bash
git submodule add https://github.com/example/playwright-skill skills/frontend/playwright
```

After adding, make sure submodules are initialized locally:

```bash
git submodule update --init --recursive
```

## Automatic Updates

Submodules are automatically updated daily via GitHub Actions.
