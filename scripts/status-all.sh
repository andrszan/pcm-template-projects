#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$ROOT_DIR/catalog.json"

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

while IFS=$'\t' read -r id; do
  [[ -n "$id" ]] || continue
  print_repository_status "$id" "$ROOT_DIR/repositories/$id"
done < <(
  python3 - "$CONFIG_FILE" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as file:
    repositories = json.load(file)["repositories"]

for repository_id in repositories:
    print(repository_id)
PY
)
