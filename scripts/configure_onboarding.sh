#!/usr/bin/env bash
# Onboarding: company, project, tooling context for AI agents.
# Part of init.sh — re-run on install/upgrade/deploy to refresh auto sections.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT="docs/tooling-context.md"
GUARDRAILS_CTX="docs/guardrails-context.md"
NONINTERACTIVE=false
FORCE=false
COMPANY=""
PROJECT=""
TOOLS=""
COMPLIANCE=""

ALL_TOOLS=(github linear jira confluence sharepoint miro)

usage() {
  cat <<EOF
Usage: configure_onboarding.sh [options]

  --non-interactive       No prompts (CI / deploy scripts)
  --force                 Re-patch auto blocks even if tooling-context exists
  --company NAME          Company / org name
  --project NAME          Project or product name
  --tools LIST            Comma-separated: github,linear,jira,confluence,sharepoint,miro
  --compliance LEVEL      Target compliance level 1-5

Also runs configure_context.sh for stack / high-risk paths.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --non-interactive) NONINTERACTIVE=true ;;
    --force) FORCE=true ;;
    --company) shift; COMPANY="${1:-}" ;;
    --project) shift; PROJECT="${1:-}" ;;
    --tools) shift; TOOLS="${1:-}" ;;
    --compliance) shift; COMPLIANCE="${1:-}" ;;
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

ensure_template() {
  mkdir -p docs docs/integrations/baseline
  if [ ! -f "$OUT" ] || $FORCE; then
    if [ -f "docs/tooling-context.template.md" ]; then
      cp docs/tooling-context.template.md "$OUT"
    elif [ -f "$PACK_ROOT/docs/tooling-context.template.md" ]; then
      cp "$PACK_ROOT/docs/tooling-context.template.md" "$OUT"
    else
      echo "ERROR: tooling-context.template.md not found"; exit 1
    fi
  fi
  if [ -d "$PACK_ROOT/integrations/baseline" ]; then
    for f in "$PACK_ROOT/integrations/baseline/"*.md; do
      [ -f "$f" ] || continue
      base="$(basename "$f")"
      [ -f "docs/integrations/baseline/$base" ] || cp "$f" "docs/integrations/baseline/$base"
    done
  fi
  [ -f "$PACK_ROOT/integrations/README.md" ] && \
    [ ! -f docs/integrations/README.md ] && cp "$PACK_ROOT/integrations/README.md" docs/integrations/README.md
}

prompt_if_empty() {
  local varname="$1" prompt="$2" default="${3:-}"
  local val
  if [ -n "${!varname}" ]; then return; fi
  if $NONINTERACTIVE || [ ! -t 0 ]; then
    eval "$varname=\"$default\""
    return
  fi
  printf '%s [%s]: ' "$prompt" "$default" >&2
  read -r val || true
  eval "$varname=\"${val:-$default}\""
}

select_tools_interactive() {
  if [ -n "$TOOLS" ]; then return; fi
  if $NONINTERACTIVE; then
    TOOLS="github"
    return
  fi
  if [ ! -t 0 ]; then
    TOOLS="github"
    return
  fi
  echo "Active tools (comma-separated, default: github):" >&2
  echo "  github, linear, jira, confluence, sharepoint, miro" >&2
  read -r reply || true
  TOOLS="${reply:-github}"
}

tool_active() {
  local t="$1"
  local IFS=','; local x
  for x in $TOOLS; do
    x="$(echo "$x" | tr '[:upper:]' '[:lower:]' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [ "$x" = "$t" ] && return 0
  done
  return 1
}

company_content() {
  local policy="${COMPLIANCE:-4}"
  cat <<EOF
- **Organization:** ${COMPANY:-(not set)}
- **AI policy:** \`docs/ai-coding-policy.md\` if present, else Guardrails default
- **Compliance target:** Level ${policy} (see \`docs/compliance-levels.md\`)
EOF
}

project_content() {
  local repo remote
  repo="$(basename "$(pwd)")"
  remote="$(git remote get-url origin 2>/dev/null || echo '(local)')"
  cat <<EOF
- **Name:** ${PROJECT:-$repo}
- **Repository:** ${remote}
- **Purpose:** (describe in one line — edit this file)
- **Primary agents entry:** \`TEAM.md\` when Team OS installed, else \`AGENTS.md\` / \`CLAUDE.md\`
EOF
}

tooling_table_content() {
  local t label domain
  echo "| Domain | Tool | Active | Reference / id format |"
  echo "| --- | --- | --- | --- |"
  echo "| Version control | GitHub | $(tool_active github && echo yes || echo no) | \`#123\` PR/issue |"
  echo "| Tracking | GitHub Issues | $(tool_active github && echo yes || echo no) | \`#123\` |"
  echo "| Tracking | Linear | $(tool_active linear && echo yes || echo no) | \`LIN-123\` |"
  echo "| Tracking | Jira | $(tool_active jira && echo yes || echo no) | \`PROJ-123\` |"
  echo "| Docs (wiki) | Confluence | $(tool_active confluence && echo yes || echo no) | page URL |"
  echo "| Docs (repo) | Markdown | yes | \`docs/\` |"
  echo "| Policy / files | SharePoint | $(tool_active sharepoint && echo yes || echo no) | internal URL |"
  echo "| Design | Miro | $(tool_active miro && echo yes || echo no) | board URL |"
}

integrations_content_fixed() {
  local t f any=false
  for t in "${ALL_TOOLS[@]}"; do
    tool_active "$t" || continue
    f="docs/integrations/baseline/${t}.md"
    if [ -f "$f" ]; then
      any=true
      echo "### ${t}"
      echo
      cat "$f"
      echo
    fi
  done
  if [ -f docs/integrations/custom.md ]; then
    any=true
    echo "### custom (company overrides)"
    echo
    cat docs/integrations/custom.md
    echo
  fi
  if ! $any; then
    echo "(no active tool profiles — set --tools or edit Active tooling table)"
  fi
}

prompt_if_empty COMPANY "Company / org name" ""
prompt_if_empty PROJECT "Project name" "$(basename "$(pwd)")"
prompt_if_empty COMPLIANCE "Compliance level (1-5)" "3"
select_tools_interactive

evolution_content() {
  echo "| Date | Change | Author |"
  echo "| --- | --- | --- |"
  echo "| $(date +%Y-%m-%d) | Initial onboarding (configure_onboarding.sh) | init |"
}

ensure_template

patch_block "$OUT" "# guardrails-company-start" "# guardrails-company-end" "$(company_content)"
patch_block "$OUT" "# guardrails-project-start" "# guardrails-project-end" "$(project_content)"
patch_block "$OUT" "# guardrails-tooling-start" "# guardrails-tooling-end" "$(tooling_table_content)"
patch_block "$OUT" "# guardrails-integrations-start" "# guardrails-integrations-end" "$(integrations_content_fixed)"

if $FORCE || ! grep -q "Initial onboarding" "$OUT" 2>/dev/null; then
  patch_block "$OUT" "# guardrails-evolution-start" "# guardrails-evolution-end" "$(evolution_content)"
fi

echo "Configured $OUT (tools: $TOOLS)"

# Stack / risk context (existing)
if [ -f "$SCRIPT_DIR/configure_context.sh" ]; then
  bash "$SCRIPT_DIR/configure_context.sh" $($NONINTERACTIVE && echo --non-interactive)
fi

# Pointer in guardrails-context if both exist
if [ -f "$GUARDRAILS_CTX" ] && ! grep -q tooling-context "$GUARDRAILS_CTX" 2>/dev/null; then
  printf '\nSee also: `docs/tooling-context.md` (company, project, tooling).\n' >> "$GUARDRAILS_CTX"
fi

echo "Onboarding complete. Edit $OUT and docs/integrations/custom.md to evolve."
