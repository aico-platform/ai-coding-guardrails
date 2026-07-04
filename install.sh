#!/usr/bin/env bash
set -euo pipefail

# AI Coding Guardrails — free edition installer
#
# Usage (from your repo root):
#   curl -fsSL https://raw.githubusercontent.com/aico-platform/ai-coding-guardrails/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- --detect
#   curl -fsSL .../install.sh | bash -s -- --detect --non-interactive
#
# Copies the guardrails into the current directory. Never overwrites
# existing files; skipped files are reported so you can merge by hand.

REPO_TARBALL="https://github.com/aico-platform/ai-coding-guardrails/archive/refs/heads/main.tar.gz"

bold() { printf '\033[1m%s\033[0m\n' "$1"; }

DETECT=false
INIT_EXTRA=()
while [ $# -gt 0 ]; do
  case "$1" in
    --detect) DETECT=true; shift ;;
    --adapters|--non-interactive) INIT_EXTRA+=("$1"); shift ;;
    --risk-paths)
      INIT_EXTRA+=("$1" "${2:-}")
      shift 2
      ;;
    *) shift ;;
  esac
done

if [ ! -d .git ]; then
  echo "note: current directory is not a git repo root — installing here anyway: $(pwd)"
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

bold "Downloading AI Coding Guardrails..."
curl -fsSL "$REPO_TARBALL" | tar -xz -C "$tmp" --strip-components=1

installed=0
skipped=0

install_file() { # src dst
  local src="$1" dst="$2"
  if [ ! -f "$src" ]; then return; fi
  if [ -e "$dst" ]; then
    echo "  skip (exists): $dst"
    skipped=$((skipped + 1))
  else
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "  installed:     $dst"
    installed=$((installed + 1))
  fi
}

bold "Installing..."
install_file "$tmp/claude/CLAUDE.md" "CLAUDE.md"
install_file "$tmp/AGENTS.md" "AGENTS.md"
for f in "$tmp"/claude/commands/*.md; do
  [ -f "$f" ] && install_file "$f" ".claude/commands/$(basename "$f")"
done
for f in "$tmp"/cursor/rules/*.mdc; do
  [ -f "$f" ] && install_file "$f" ".cursor/rules/$(basename "$f")"
done
for f in "$tmp"/shared/*.md; do
  [ -f "$f" ] && install_file "$f" "docs/$(basename "$f")"
done
install_file "$tmp/github/pull_request_template.md" ".github/pull_request_template.md"
install_file "$tmp/github/copilot-instructions.md" ".github/copilot-instructions.md"
install_file "$tmp/windsurf/rules/00-agent-operating-contract.md" ".windsurf/rules/00-agent-operating-contract.md"
install_file "$tmp/windsurf/.windsurfrules" ".windsurfrules"
install_file "$tmp/scripts/detect_stack.sh" "scripts/detect_stack.sh"
install_file "$tmp/scripts/configure_verification.sh" "scripts/configure_verification.sh"
install_file "$tmp/scripts/configure_context.sh" "scripts/configure_context.sh"
install_file "$tmp/scripts/init.sh" "scripts/init.sh"
install_file "$tmp/scripts/install_adapters.sh" "scripts/install_adapters.sh"
install_file "$tmp/docs/guardrails-context.template.md" "docs/guardrails-context.template.md"
chmod +x scripts/*.sh 2>/dev/null || true

echo
bold "Done: $installed installed, $skipped skipped (already existed)."

if $DETECT; then
  echo
  bold "Running init (verification + repository context)..."
  bash scripts/init.sh "${INIT_EXTRA[@]}"
else
  echo
  echo "Next steps:"
  echo "  1. Full init: bash scripts/init.sh"
  echo "     Or: curl ... | bash -s -- --detect"
  echo "  2. Verify — ask your agent to fix a typo and show risk + evidence."
fi
