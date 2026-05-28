#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

chmod +x "${SCRIPT_DIR}/claude-codex-pipeline-cmux"

echo "Command is ready: ${SCRIPT_DIR}/claude-codex-pipeline-cmux"
echo ""
echo "Add this directory to PATH:"
echo "export PATH=\"${SCRIPT_DIR}:\$PATH\""
echo ""
echo "For zsh, you can append it to ~/.zshrc:"
echo "echo 'export PATH=\"${SCRIPT_DIR}:\$PATH\"' >> ~/.zshrc"
