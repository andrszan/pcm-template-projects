#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$ROOT_DIR/repositories.yaml"
EXIT_CODE=0

while IFS='|' read -r id relative_path remote; do
  [[ -n "$id" && -n "$relative_path" ]] || continue

  target="$ROOT_DIR/$relative_path"

  if [[ -d "$target/.git" ]]; then
    printf '[%s] present: %s\n' "$id" "$target"
    continue
  fi

  if [[ -e "$target" ]]; then
    printf '[%s] error: path exists but is not a Git repository: %s\n' "$id" "$target" >&2
    EXIT_CODE=1
    continue
  fi

  if [[ -z "$remote" ]]; then
    printf '[%s] missing and no remote is configured: %s\n' "$id" "$target" >&2
    EXIT_CODE=1
    continue
  fi

  mkdir -p "$(dirname "$target")"
  printf '[%s] cloning %s into %s\n' "$id" "$remote" "$target"
  if ! git clone "$remote" "$target"; then
    printf '[%s] clone failed\n' "$id" >&2
    EXIT_CODE=1
  fi
done < <(
  awk '
    function emit() {
      if (id != "") print id "|" path "|" remote
    }
    /^[[:space:]]*-[[:space:]]+id:/ {
      emit()
      id = $0
      sub(/^[[:space:]]*-[[:space:]]+id:[[:space:]]*/, "", id)
      path = ""
      remote = ""
      next
    }
    /^[[:space:]]+path:/ {
      path = $0
      sub(/^[[:space:]]+path:[[:space:]]*/, "", path)
      next
    }
    /^[[:space:]]+remote:/ {
      remote = $0
      sub(/^[[:space:]]+remote:[[:space:]]*/, "", remote)
      next
    }
    END { emit() }
  ' "$CONFIG_FILE"
)

exit "$EXIT_CODE"
