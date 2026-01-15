#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./INSTALL.sh [--global] [--project /path/to/project] [--codex|--claude|--gemini|--opencode]

Options:
  --global            Install to the user's global skills directory (default)
  --project PATH      Install to PATH/<agent skills dir>
  --codex             Target Codex skills (default)
  --claude            Target Claude Code skills
  --gemini            Target Gemini CLI skills
  --opencode          Target OpenCode skills
  -h, --help          Show this help

Notes:
  - This creates a symlink from this repo's skills/ directory.
  - Existing non-symlink destinations are backed up with a .bak timestamp.
EOF
}

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_skills="${root_dir}/skills"

mode="global"
target="codex"
project_path=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global)
      mode="global"
      shift
      ;;
    --project)
      mode="project"
      project_path="${2:-}"
      if [[ -z "${project_path}" ]]; then
        echo "Error: --project requires a path." >&2
        exit 1
      fi
      shift 2
      ;;
    --codex|--claude|--gemini|--opencode)
      new_target="${1#--}"
      if [[ "${target}" != "codex" && "${target}" != "${new_target}" ]]; then
        echo "Error: only one target can be specified." >&2
        exit 1
      fi
      target="${new_target}"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ ! -d "${source_skills}" ]]; then
  echo "Error: skills directory not found at ${source_skills}" >&2
  exit 1
fi

if [[ "${mode}" == "project" ]]; then
  if [[ ! -d "${project_path}" ]]; then
    echo "Error: project path not found: ${project_path}" >&2
    exit 1
  fi
fi

case "${target}" in
  codex)
    base_dir_global="${HOME}/.codex"
    base_dir_project=".codex"
    ;;
  claude)
    base_dir_global="${HOME}/.claude"
    base_dir_project=".claude"
    ;;
  gemini)
    base_dir_global="${HOME}/.gemini"
    base_dir_project=".gemini"
    ;;
  opencode)
    base_dir_global="${HOME}/.config/opencode"
    base_dir_project=".opencode"
    ;;
  *)
    echo "Error: unsupported target: ${target}" >&2
    exit 1
    ;;
esac

if [[ "${mode}" == "project" ]]; then
  dest_dir="${project_path}/${base_dir_project}"
else
  dest_dir="${base_dir_global}"
fi

dest_skills="${dest_dir}/skills"

mkdir -p "${dest_dir}"

if [[ -L "${dest_skills}" ]]; then
  current_target="$(readlink "${dest_skills}")"
  if [[ "${current_target}" == "${source_skills}" ]]; then
    echo "Already linked: ${dest_skills} -> ${source_skills}"
    exit 0
  fi
  rm "${dest_skills}"
elif [[ -e "${dest_skills}" ]]; then
  ts="$(date +%Y%m%d%H%M%S)"
  backup="${dest_skills}.bak.${ts}"
  mv "${dest_skills}" "${backup}"
  echo "Backed up existing skills to ${backup}"
fi

ln -s "${source_skills}" "${dest_skills}"
echo "Linked: ${dest_skills} -> ${source_skills}"
echo "Restart Codex to pick up new skills."
