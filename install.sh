#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

check_command() {
  local cmd="$1"

  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: Missing command: $cmd" >&2
    exit 1
  fi

  printf "%-8s " "$cmd"
  "$cmd" --version | head -1
}

chmod +x "${SCRIPT_DIR}/claude-codex-pipeline-cmux"

echo "Command is ready: ${SCRIPT_DIR}/claude-codex-pipeline-cmux"
echo ""
echo "Checking required commands:"
check_command claude
check_command codex
check_command python3
check_command git
echo ""
echo "Add this directory to PATH:"
echo "export PATH=\"${SCRIPT_DIR}:\$PATH\""
echo ""
echo "For zsh, you can append it to ~/.zshrc:"
echo "echo 'export PATH=\"${SCRIPT_DIR}:\$PATH\"' >> ~/.zshrc"
