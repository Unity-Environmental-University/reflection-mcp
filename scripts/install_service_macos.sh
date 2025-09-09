#!/usr/bin/env bash
set -euo pipefail

PLIST_SRC="$(cd "$(dirname "$0")" && pwd)/macos/launchagents/com.reflection.mcp.plist"
PLIST_DST="${HOME}/Library/LaunchAgents/com.reflection.mcp.plist"

mkdir -p "${HOME}/Library/LaunchAgents" "${HOME}/Library/Logs"
cp -f "$PLIST_SRC" "$PLIST_DST"

launchctl unload "$PLIST_DST" >/dev/null 2>&1 || true
launchctl load "$PLIST_DST"
launchctl start com.reflection.mcp

echo "reflection-mcp loaded. Logs:"
echo "  tail -f \"$HOME/Library/Logs/reflection-mcp.out\" \"$HOME/Library/Logs/reflection-mcp.err\""

