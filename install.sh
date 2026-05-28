#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
TARGET="${BIN_DIR}/claude-codex-pipeline-cmux"

mkdir -p "$BIN_DIR"
ln -sfn "${SCRIPT_DIR}/claude-codex-pipeline-cmux" "$TARGET"
chmod +x "${SCRIPT_DIR}/claude-codex-pipeline-cmux"

echo "Installed: $TARGET"
echo "Make sure this directory is on PATH: $BIN_DIR"
