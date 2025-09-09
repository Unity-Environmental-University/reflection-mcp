#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${HOME}/.local/bin"
mkdir -p "$TARGET"
install -m 0755 "$ROOT/bin/reflection-mcp" "$TARGET/reflection-mcp"
echo "Installed to $TARGET/reflection-mcp"
echo "Add to PATH if needed: export PATH=\"$HOME/.local/bin:$PATH\""

