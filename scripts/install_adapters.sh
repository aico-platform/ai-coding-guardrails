#!/usr/bin/env bash
# Copy optional stack adapter into .cursor/rules/ when stack matches.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

find_adapters_dir() {
  for d in "$SCRIPT_DIR/../adapters" "./adapters" "adapters"; do
    if [ -d "$d" ] && [ -f "$d/python.mdc" -o -f "$d/node.mdc" ]; then
      echo "$(cd "$d" && pwd)"
      return 0
    fi
  done
  return 1
}

ADAPTERS="$(find_adapters_dir 2>/dev/null || true)"
if [ -z "$ADAPTERS" ]; then
  echo "No adapters/ directory found (Pro pack only). Skipping."
  exit 0
fi

stack="$(bash "$SCRIPT_DIR/detect_stack.sh" --stack)"
installed=0

install_adapter() {
  local src="$1" dst="$2"
  if [ ! -f "$src" ]; then return; fi
  if [ -f "$dst" ]; then
    echo "  skip (exists): $dst"
    return
  fi
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  echo "  installed:     $dst"
  installed=$((installed + 1))
}

case "$stack" in
  python) install_adapter "$ADAPTERS/python.mdc" ".cursor/rules/08-python-stack.mdc" ;;
  node) install_adapter "$ADAPTERS/node.mdc" ".cursor/rules/08-node-stack.mdc" ;;
  *) echo "No stack adapter for: $stack (adapters available: python, node)" ;;
esac

[ "$installed" -gt 0 ] && echo "Stack adapter installed." || true
