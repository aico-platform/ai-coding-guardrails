#!/usr/bin/env bash
# Write detected verification commands into .cursor/rules/03-testing-and-validation.mdc
set -euo pipefail

RULE=".cursor/rules/03-testing-and-validation.mdc"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$RULE" ]; then
  echo "ERROR: $RULE not found. Install guardrails first (copy .cursor/rules/ or run install.sh)."
  exit 1
fi

cmds="$(bash "$SCRIPT_DIR/detect_stack.sh")"
start="# guardrails-verification-start"
end="# guardrails-verification-end"

if ! grep -q "$start" "$RULE"; then
  echo "ERROR: verification markers not found in $RULE (expected $start / $end)."
  exit 1
fi

tmp="$(mktemp)"
awk -v start="$start" -v end="$end" -v cmds="$cmds" '
  $0 == start { print; print cmds; inblock=1; next }
  inblock && $0 == end { inblock=0; print; next }
  !inblock { print }
' "$RULE" > "$tmp"
mv "$tmp" "$RULE"

echo "Configured verification commands in $RULE:"
echo "  $cmds"
