#!/usr/bin/env bash
set -euo pipefail

# AI Coding Guardrails — free edition installer
#
# Usage (from your repo root):
#   curl -fsSL https://raw.githubusercontent.com/aico-platform/ai-coding-guardrails/main/install.sh | bash
#
# Copies the guardrails into the current directory. Never overwrites
# existing files; skipped files are reported so you can merge by hand.

REPO_TARBALL="https://github.com/aico-platform/ai-coding-guardrails/archive/refs/heads/main.tar.gz"

bold() { printf '\033[1m%s\033[0m\n' "$1"; }

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
  install_file "$f" ".claude/commands/$(basename "$f")"
done
for f in "$tmp"/cursor/rules/*.mdc; do
  install_file "$f" ".cursor/rules/$(basename "$f")"
done
for f in "$tmp"/shared/*.md; do
  install_file "$f" "docs/$(basename "$f")"
done
install_file "$tmp/github/pull_request_template.md" ".github/pull_request_template.md"

echo
bold "Done: $installed installed, $skipped skipped (already existed)."
echo
echo "Next steps:"
echo "  1. Open .cursor/rules/03-testing-and-validation.mdc and point the"
echo "     example commands at your repo's lint/typecheck/test commands."
echo "  2. Verify it works — ask your agent:"
echo "       \"Fix a typo in the README, then tell me the risk level"
echo "        and show your evidence.\""
echo "     A guarded agent reports Risk: Low with an Evidence section."
