#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
README="${ROOT_DIR}/README.md"
SKILLS_DIR="${ROOT_DIR}/skills"
DEDUPED_DIR="${ROOT_DIR}/skills/.deduped"
REPO_ROOT="${ROOT_DIR}"
START_MARKER="<!-- SKILLS-LIST:START -->"
END_MARKER="<!-- SKILLS-LIST:END -->"

if [ -d "${DEDUPED_DIR}" ]; then
  SKILLS_DIR="${DEDUPED_DIR}"
elif command -v bun >/dev/null 2>&1 && [ -f "${ROOT_DIR}/scripts/dedupe-skills.ts" ]; then
  bun "${ROOT_DIR}/scripts/dedupe-skills.ts" --root "${ROOT_DIR}" --out "skills/.deduped" >/dev/null || true
  if [ -d "${DEDUPED_DIR}" ]; then
    SKILLS_DIR="${DEDUPED_DIR}"
  fi
fi

export README SKILLS_DIR REPO_ROOT START_MARKER END_MARKER

python3 - <<'PY'
import configparser
import os
from pathlib import Path

readme_path = Path(os.environ["README"])
skills_dir = Path(os.environ["SKILLS_DIR"])
repo_root = Path(os.environ["REPO_ROOT"])
start = os.environ["START_MARKER"]
end = os.environ["END_MARKER"]
gitmodules_path = repo_root / ".gitmodules"

submodule_urls = {}
if gitmodules_path.exists():
    config = configparser.ConfigParser()
    config.read(gitmodules_path)
    for section in config.sections():
        path = config.get(section, "path", fallback=None)
        url = config.get(section, "url", fallback=None)
        if path and url:
            submodule_urls[path] = url

categories = {}
if skills_dir.is_dir():
    for category in sorted([p for p in skills_dir.iterdir() if p.is_dir()]):
        items = sorted([p.name for p in category.iterdir() if p.is_dir()])
        if items:
            categories[category.name] = items

lines = []
for category, items in categories.items():
    category_path = f"skills/{category}/"
    lines.append(f"- [`{category_path}`]({category_path})")
    for item in items:
        item_path = f"skills/{category}/{item}"
        link = submodule_urls.get(item_path, item_path)
        lines.append(f"  - [`{item}`]({link})")

skills_block = "\n".join(lines) if lines else "- _No skills found._"

content = readme_path.read_text()
start_idx = content.find(start)
end_idx = content.find(end)

if start_idx == -1 or end_idx == -1 or end_idx < start_idx:
    raise SystemExit("README markers not found or malformed.")

before = content[: start_idx + len(start)]
after = content[end_idx:]

new_content = f"{before}\n{skills_block}\n{after}"
readme_path.write_text(new_content)
PY
