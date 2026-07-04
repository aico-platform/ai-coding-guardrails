#!/usr/bin/env bash
# Detect lint / typecheck / test commands for the current repository.
# Prints one line suitable for && chaining. Exit 0 always (falls back to defaults).
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

node_commands() {
  local pm=npm
  [ -f pnpm-lock.yaml ] && pm=pnpm
  [ -f yarn.lock ] && pm=yarn
  [ -f bun.lockb ] && pm=bun

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

if [ -f package.json ]; then
  node_commands
elif [ -f pyproject.toml ] || [ -f requirements.txt ] || [ -f setup.py ]; then
  python_commands
elif [ -f Cargo.toml ]; then
  echo "cargo clippy && cargo test"
elif [ -f go.mod ]; then
  echo "go vet ./... && go test ./..."
elif [ -f Makefile ] && grep -qE '^test:' Makefile; then
  if grep -qE '^lint:' Makefile; then
    echo "make lint && make test"
  else
    echo "make test"
  fi
else
  echo "make lint && make typecheck && make test  # default — run: bash scripts/configure_verification.sh"
fi
