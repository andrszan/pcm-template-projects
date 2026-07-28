#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$ROOT_DIR/repositories.yaml"

print_repository_status() {
  local id="$1"
  local repository_path="$2"

  printf '[%s]\n' "$id"
  printf 'path: %s\n' "$repository_path"

  if [[ ! -d "$repository_path/.git" ]]; then
    printf 'branch: -\n'
    printf 'status: missing\n\n'
    return
  fi

  local branch
  local changes
  branch="$(git -C "$repository_path" branch --show-current)"
  changes="$(git -C "$repository_path" status --porcelain)"

  if [[ -z "$branch" ]]; then
    branch='(detached)'
  fi

  printf 'branch: %s\n' "$branch"
  if [[ -z "$changes" ]]; then
    printf 'status: clean\n\n'
  else
    printf 'status: dirty\n'
    printf '%s\n\n' "$changes"
  fi
}

print_repository_status root "$ROOT_DIR"

while IFS='|' read -r id relative_path; do
  [[ -n "$id" && -n "$relative_path" ]] || continue
  print_repository_status "$id" "$ROOT_DIR/$relative_path"
done < <(
  awk '
    /^[[:space:]]*-[[:space:]]+id:/ {
      id = $0
      sub(/^[[:space:]]*-[[:space:]]+id:[[:space:]]*/, "", id)
    }
    /^[[:space:]]+path:/ {
      path = $0
      sub(/^[[:space:]]+path:[[:space:]]*/, "", path)
      if (id != "") print id "|" path
    }
  ' "$CONFIG_FILE"
)
