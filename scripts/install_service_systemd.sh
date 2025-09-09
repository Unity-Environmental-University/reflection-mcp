#!/usr/bin/env bash
set -euo pipefail

UNIT_SRC="$(cd "$(dirname "$0")" && pwd)/linux/systemd/reflection-mcp.service"
UNIT_DIR="${HOME}/.config/systemd/user"
UNIT_DST="${UNIT_DIR}/reflection-mcp.service"

mkdir -p "$UNIT_DIR"
cp -f "$UNIT_SRC" "$UNIT_DST"

systemctl --user daemon-reload
systemctl --user enable --now reflection-mcp.service

echo "reflection-mcp installed and started."
echo "Check status: systemctl --user status reflection-mcp.service"
echo "Logs: journalctl --user -u reflection-mcp.service -f"

