#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$ROOT_DIR/catalog.json"
EXIT_CODE=0

while IFS=$'\t' read -r id name git_url default_branch; do
  [[ -n "$id" && -n "$name" ]] || continue

  target="$ROOT_DIR/repositories/$name"

  if [[ -d "$target/.git" ]]; then
    printf '[%s] present: %s\n' "$id" "$target"
    continue
  fi

  if [[ -e "$target" ]]; then
    printf '[%s] error: path exists but is not a Git repository: %s\n' "$id" "$target" >&2
    EXIT_CODE=1
    continue
  fi

  if [[ -z "$git_url" ]]; then
    printf '[%s] missing and no remote is configured: %s\n' "$id" "$target" >&2
    EXIT_CODE=1
    continue
  fi

  mkdir -p "$(dirname "$target")"
  printf '[%s] cloning %s (%s) into %s\n' "$id" "$git_url" "$default_branch" "$target"
  if ! git clone --branch "$default_branch" --single-branch "$git_url" "$target"; then
    printf '[%s] clone failed\n' "$id" >&2
    EXIT_CODE=1
  fi
done < <(
  python3 - "$CONFIG_FILE" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as file:
    repositories = json.load(file)["repositories"]

for repository_id, repository in repositories.items():
    print(
        repository_id,
        repository["name"],
        repository["git_url"],
        repository["default_branch"],
        sep="\t",
    )
PY
)

exit "$EXIT_CODE"
