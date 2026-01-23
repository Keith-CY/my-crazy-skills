#!/bin/sh
set -eu
if [ -n "${BASH_VERSION:-}" ]; then
  set -o pipefail
fi

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

script_dir=""
if [ -n "${BASH_SOURCE:-}" ]; then
  script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
elif [ -f "$0" ]; then
  case "$0" in
    */*)
      script_dir=$(cd "$(dirname "$0")" && pwd -P)
      ;;
  esac
fi

if [ -n "${script_dir}" ] && [ -d "${script_dir}/skills" ]; then
  root_dir="${script_dir}"
elif [ -d "./skills" ]; then
  root_dir="$(pwd -P)"
else
  root_dir=""
fi

source_root="${root_dir}"
source_skills_raw="${source_root}/skills"
source_skills="${source_skills_raw}"

mode="global"
target="codex"
project_path=""

while [ $# -gt 0 ]; do
  case "$1" in
    --global)
      mode="global"
      shift
      ;;
    --project)
      mode="project"
      project_path="${2:-}"
      if [ -z "${project_path}" ]; then
        echo "Error: --project requires a path." >&2
        exit 1
      fi
      shift 2
      ;;
    --codex|--claude|--gemini|--opencode)
      new_target="${1#--}"
      if [ "${target}" != "codex" ] && [ "${target}" != "${new_target}" ]; then
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

if [ ! -d "${source_skills}" ]; then
  repo_url="https://github.com/Keith-CY/my-crazy-skills"
  cache_dir="${HOME}/.cache/my-crazy-skills"
  if command -v git >/dev/null 2>&1; then
    if [ -d "${cache_dir}/skills" ]; then
      echo "Using cached repo at ${cache_dir}"
    elif [ -e "${cache_dir}" ] && [ ! -d "${cache_dir}/.git" ]; then
      echo "Error: ${cache_dir} exists but is not a git repo." >&2
      echo "Move it aside or remove it, then re-run the installer." >&2
      exit 1
    else
      mkdir -p "${HOME}/.cache"
      echo "Cloning ${repo_url} into ${cache_dir}"
      git clone --recurse-submodules "${repo_url}" "${cache_dir}"
    fi
    source_root="${cache_dir}"
    source_skills_raw="${source_root}/skills"
    source_skills="${source_skills_raw}"
  else
    echo "Error: skills directory not found and git is not installed." >&2
    echo "Install git or clone the repo and run from its root." >&2
    exit 1
  fi
fi

# Prefer a de-duplicated tree so skills aren't double-listed when the same upstream
# repo is included multiple times under different categories (same commit).
dedup_out="${source_skills_raw}/.deduped"
if [ -d "${dedup_out}" ]; then
  source_skills="${dedup_out}"
elif command -v bun >/dev/null 2>&1 && [ -f "${source_root}/scripts/dedupe-skills.ts" ]; then
  echo "Generating deduped skills tree with bun..."
  if bun "${source_root}/scripts/dedupe-skills.ts" --root "${source_root}" --out "skills/.deduped" >/dev/null; then
    if [ -d "${dedup_out}" ]; then
      source_skills="${dedup_out}"
    fi
  else
    echo "Warning: failed to generate deduped skills tree; installing raw skills/ instead." >&2
  fi
fi

if [ "${mode}" = "project" ]; then
  if [ ! -d "${project_path}" ]; then
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

if [ "${mode}" = "project" ]; then
  dest_dir="${project_path}/${base_dir_project}"
else
  dest_dir="${base_dir_global}"
fi

dest_skills="${dest_dir}/skills"

mkdir -p "${dest_dir}"

if [ -L "${dest_skills}" ]; then
  current_target="$(readlink "${dest_skills}")"
  if [ "${current_target}" = "${source_skills}" ]; then
    echo "Already linked: ${dest_skills} -> ${source_skills}"
    exit 0
  fi
  rm "${dest_skills}"
elif [ -e "${dest_skills}" ]; then
  ts="$(date +%Y%m%d%H%M%S)"
  backup="${dest_skills}.bak.${ts}"
  mv "${dest_skills}" "${backup}"
  echo "Backed up existing skills to ${backup}"
fi

ln -s "${source_skills}" "${dest_skills}"
echo "Linked: ${dest_skills} -> ${source_skills}"
echo "Restart Codex to pick up new skills."
