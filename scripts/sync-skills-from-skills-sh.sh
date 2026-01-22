#!/usr/bin/env bash
set -euo pipefail

VIEW="${VIEW:-all-time}"          # all-time | trending
MIN_INSTALLS="${MIN_INSTALLS:-1000}"
MAX_SOURCES="${MAX_SOURCES:-0}"   # 0 = no limit
DEST_DIR="${DEST_DIR:-skills/popular}"

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT_DIR"

mkdir -p "$DEST_DIR"

TMP_SOURCES="$(mktemp)"
existing_urls="$(mktemp)"

python3 scripts/skills-sh-popular-sources.py \
  --view "$VIEW" \
  --min-installs "$MIN_INSTALLS" \
  --max-sources "$MAX_SOURCES" \
  --format slug \
  > "$TMP_SOURCES"

trap 'rm -f "$existing_urls" "$TMP_SOURCES"' EXIT
if [[ -f .gitmodules ]]; then
  git config -f .gitmodules --get-regexp '^submodule\\..*\\.url$' | awk '{print $2}' | sort -u > "$existing_urls" || true
else
  : > "$existing_urls"
fi

added_count=0

while IFS= read -r source; do
  [[ -n "$source" ]] || continue

  url="https://github.com/${source}"
  url_git="${url}.git"

  if grep -Fxq "$url" "$existing_urls" || grep -Fxq "$url_git" "$existing_urls"; then
    continue
  fi

  owner="${source%%/*}"
  repo="${source#*/}"
  safe_name="${owner}--${repo}"
  submodule_path="${DEST_DIR}/${safe_name}"

  if [[ -e "$submodule_path" ]]; then
    echo "Skipping ${source} (path exists): ${submodule_path}" >&2
    continue
  fi

  echo "Adding submodule: ${source} -> ${submodule_path}"
  git submodule add "$url_git" "$submodule_path"
  added_count=$((added_count + 1))
done < "$TMP_SOURCES"

echo "Added ${added_count} new submodule(s)"
