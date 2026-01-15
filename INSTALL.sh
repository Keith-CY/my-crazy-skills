#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./INSTALL.sh [--global] [--project /path/to/project]

Options:
  --global            Install to ~/.codex/skills (default)
  --project PATH      Install to PATH/.codex/skills
  -h, --help          Show this help

Notes:
  - This creates a symlink from this repo's skills/ directory.
  - Existing non-symlink destinations are backed up with a .bak timestamp.
EOF
}

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_skills="${root_dir}/skills"

mode="global"
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
  dest_dir="${project_path}/.codex"
  dest_skills="${dest_dir}/skills"
else
  dest_dir="${HOME}/.codex"
  dest_skills="${dest_dir}/skills"
fi

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
