#!/usr/bin/env bash
# Detect high-risk paths and write docs/guardrails-context.md
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="docs/guardrails-context.md"
NONINTERACTIVE=false
RISK_INPUT=""

usage() {
  echo "Usage: configure_context.sh [--non-interactive] [--risk-paths a,b,c]"
}

while [ $# -gt 0 ]; do
  case "$1" in
    --non-interactive) NONINTERACTIVE=true ;;
    --risk-paths) shift; RISK_INPUT="${1:-}" ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1"; usage; exit 1 ;;
  esac
  shift
done

patch_block() {
  local file="$1" start="$2" end="$3" content="$4"
  local tmp content_file
  content_file="$(mktemp)"
  printf '%s\n' "$content" > "$content_file"
  tmp="$(mktemp)"
  awk -v start="$start" -v end="$end" -v cf="$content_file" '
    BEGIN {
      while ((getline line < cf) > 0)
        content = (content ? content ORS : "") line
      close(cf)
    }
    $0 == start { print; print content; skip=1; next }
    skip && $0 == end { skip=0; print; next }
    !skip { print }
  ' "$file" > "$tmp"
  rm -f "$content_file"
  mv "$tmp" "$file"
}

auto_detect_risk_paths() {
  local patterns=(
    '**/auth/**' '**/authentication/**' '**/login/**' '**/session/**'
    '**/billing/**' '**/payment/**' '**/payments/**'
    '**/migrations/**' '**/migration/**'
    '**/infra/**' '**/infrastructure/**' '**/terraform/**' '**/pulumi/**'
    '**/secrets/**' '**/.github/workflows/**'
  )
  local seen="" line dir
  for dir in auth authentication login session billing payment payments migrations migration infra infrastructure terraform pulumi; do
    while IFS= read -r line; do
      case "$seen" in *"$line"*) continue ;; esac
      seen="${seen}${line}"$'\n'
      echo "- \`${line%/}\`"
    done < <(find . -type d -name "$dir" 2>/dev/null \
      | grep -v node_modules | grep -v '.git' | grep -v '.venv' | grep -v dist \
      | head -20 | sed 's|^\./||')
  done
  if [ -z "$seen" ]; then
    echo "- (none auto-detected — add paths below or re-run with --risk-paths)"
  fi
}

risk_paths_content() {
  if [ -n "$RISK_INPUT" ]; then
    local IFS=','; local p
    for p in $RISK_INPUT; do
      p="$(echo "$p" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
      [ -n "$p" ] && echo "- \`${p}\`"
    done
    return
  fi

  if ! $NONINTERACTIVE && [ -t 0 ]; then
    echo "High-risk paths (comma-separated, Enter to auto-detect):" >&2
    read -r reply || true
    if [ -n "$reply" ]; then
      RISK_INPUT="$reply"
      risk_paths_content
      return
    fi
  fi
  auto_detect_risk_paths
}

stack_notes_content() {
  local stack mono cmds
  stack="$(bash "$SCRIPT_DIR/detect_stack.sh" --stack)"
  mono="$(bash "$SCRIPT_DIR/detect_stack.sh" --monorepo)"
  cmds="$(bash "$SCRIPT_DIR/detect_stack.sh")"
  echo "- Primary stack: **${stack}**"
  echo "- Monorepo tooling: **${mono}**"
  echo "- Verification (see rule 03): \`${cmds}\`"
}

monorepo_content() {
  local mono
  mono="$(bash "$SCRIPT_DIR/detect_stack.sh" --monorepo)"
  if [ "$mono" = none ]; then
    echo "Single-package repository (no turbo/nx/pnpm-workspaces/lerna detected)."
  else
    echo "Monorepo detected: **${mono}**. Scope changes to affected packages; use root verification commands from rule 03."
  fi
}

mkdir -p docs
if [ ! -f "$OUT" ]; then
  if [ -f "docs/guardrails-context.template.md" ]; then
    cp docs/guardrails-context.template.md "$OUT"
  elif [ -f "$SCRIPT_DIR/../docs/guardrails-context.template.md" ]; then
    cp "$SCRIPT_DIR/../docs/guardrails-context.template.md" "$OUT"
  else
    cat > "$OUT" <<'EOF'
# Repository context for AI agents

## High-risk paths
# guardrails-high-risk-start
# guardrails-high-risk-end

## Stack notes
# guardrails-stack-notes-start
# guardrails-stack-notes-end

## Monorepo layout
# guardrails-monorepo-start
# guardrails-monorepo-end
EOF
  fi
fi

patch_block "$OUT" "# guardrails-high-risk-start" "# guardrails-high-risk-end" "$(risk_paths_content)"
patch_block "$OUT" "# guardrails-stack-notes-start" "# guardrails-stack-notes-end" "$(stack_notes_content)"
patch_block "$OUT" "# guardrails-monorepo-start" "# guardrails-monorepo-end" "$(monorepo_content)"

echo "Configured $OUT"
