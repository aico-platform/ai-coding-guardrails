#!/usr/bin/env bash
# Post-install init: verification commands, repo context, optional stack adapters.
#
# Usage:
#   bash scripts/init.sh
#   bash scripts/init.sh --adapters
#   bash scripts/init.sh --non-interactive
#   bash scripts/init.sh --risk-paths src/auth,src/billing
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WITH_ADAPTERS=false
CTX_ARGS=()

while [ $# -gt 0 ]; do
  case "$1" in
    --adapters) WITH_ADAPTERS=true; shift ;;
    *) CTX_ARGS+=("$1"); shift ;;
  esac
done

echo "== Configuring verification commands =="
bash "$SCRIPT_DIR/configure_verification.sh"

echo
echo "== Configuring repository context =="
bash "$SCRIPT_DIR/configure_context.sh" "${CTX_ARGS[@]}"

if $WITH_ADAPTERS; then
  echo
  echo "== Installing stack adapter =="
  bash "$SCRIPT_DIR/install_adapters.sh"
fi

echo
echo "Init complete."
