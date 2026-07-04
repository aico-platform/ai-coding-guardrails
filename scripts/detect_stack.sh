#!/usr/bin/env bash
# Detect lint / typecheck / test commands for the current repository.
# Prints one line suitable for && chaining. Exit 0 always (falls back to defaults).
#
# Also supports:
#   detect_stack.sh --stack     → prints: node|python|rust|go|makefile|unknown
#   detect_stack.sh --monorepo  → prints: turbo|nx|pnpm-workspaces|lerna|none
set -euo pipefail

join_cmds() {
  local out="" arg
  for arg in "$@"; do
    if [ -z "$out" ]; then out="$arg"; else out="$out && $arg"; fi
  done
  echo "$out"
}

has_pkg_script() {
  local name="$1"
  [ -f package.json ] && grep -q "\"${name}\"" package.json
}

detect_monorepo() {
  if [ -f turbo.json ]; then echo turbo; return; fi
  if [ -f nx.json ]; then echo nx; return; fi
  if [ -f pnpm-workspace.yaml ]; then echo pnpm-workspaces; return; fi
  if [ -f lerna.json ]; then echo lerna; return; fi
  echo none
}

detect_stack_name() {
  if [ -f package.json ]; then echo node; return; fi
  if [ -f pyproject.toml ] || [ -f requirements.txt ] || [ -f setup.py ]; then echo python; return; fi
  if [ -f Cargo.toml ]; then echo rust; return; fi
  if [ -f go.mod ]; then echo go; return; fi
  if [ -f Makefile ] && grep -qE '^test:' Makefile; then echo makefile; return; fi
  echo unknown
}

node_pm() {
  local pm=npm
  [ -f pnpm-lock.yaml ] && pm=pnpm
  [ -f yarn.lock ] && pm=yarn
  [ -f bun.lockb ] && pm=bun
  echo "$pm"
}

node_commands() {
  local pm
  pm="$(node_pm)"
  local mono
  mono="$(detect_monorepo)"

  if [ "$mono" = turbo ]; then
    local cmds=()
    has_pkg_script lint && cmds+=("$pm exec turbo run lint")
    has_pkg_script typecheck && cmds+=("$pm exec turbo run typecheck")
    has_pkg_script test && cmds+=("$pm exec turbo run test")
    if [ ${#cmds[@]} -gt 0 ]; then join_cmds "${cmds[@]}"; return; fi
    echo "$pm exec turbo run test  # configure turbo pipeline names if needed"
    return
  fi

  if [ "$mono" = nx ]; then
    echo "npx nx run-many -t lint,test  # add typecheck to -t if configured"
    return
  fi

  if [ "$mono" = pnpm-workspaces ] || [ "$mono" = lerna ]; then
    local cmds=()
    has_pkg_script lint && cmds+=("$pm run lint")
    has_pkg_script test && cmds+=("$pm run test")
    if [ ${#cmds[@]} -gt 0 ]; then join_cmds "${cmds[@]}"; return; fi
    echo "$pm -r test  # monorepo — edit filter if needed"
    return
  fi

  local cmds=()
  has_pkg_script lint && cmds+=("$pm run lint")
  has_pkg_script typecheck && cmds+=("$pm run typecheck")
  has_pkg_script check && [ ${#cmds[@]} -eq 0 ] && cmds+=("$pm run check")
  has_pkg_script test && cmds+=("$pm run test")
  has_pkg_script build && cmds+=("$pm run build")

  if [ ${#cmds[@]} -eq 0 ]; then
    echo "$pm test  # no lint/typecheck scripts found — edit verification commands"
    return
  fi
  join_cmds "${cmds[@]}"
}

python_commands() {
  local cmds=()
  command -v ruff >/dev/null 2>&1 && cmds+=("ruff check .")
  [ -f pyproject.toml ] && grep -q 'mypy' pyproject.toml 2>/dev/null && cmds+=("mypy .")
  if [ -d tests ] || find . -maxdepth 3 -name 'test_*.py' -print -quit 2>/dev/null | grep -q .; then
    if [ -f pyproject.toml ] || command -v pytest >/dev/null 2>&1; then
      cmds+=("pytest")
    else
      cmds+=("python -m pytest")
    fi
  fi
  if [ ${#cmds[@]} -eq 0 ]; then
    echo "pytest  # default — edit if your project uses different commands"
    return
  fi
  join_cmds "${cmds[@]}"
}

case "${1:-}" in
  --stack) detect_stack_name; exit 0 ;;
  --monorepo) detect_monorepo; exit 0 ;;
esac

stack="$(detect_stack_name)"
case "$stack" in
  node) node_commands ;;
  python) python_commands ;;
  rust) echo "cargo clippy && cargo test" ;;
  go) echo "go vet ./... && go test ./..." ;;
  makefile)
    if grep -qE '^lint:' Makefile; then echo "make lint && make test"; else echo "make test"; fi
    ;;
  *) echo "make lint && make typecheck && make test  # default — run: bash scripts/configure_verification.sh" ;;
esac
