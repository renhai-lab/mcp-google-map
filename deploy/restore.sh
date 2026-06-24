#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "[1/4] Installing systemd service..."
sudo cp "$SCRIPT_DIR/mcp-google-map.service" /etc/systemd/system/
sudo systemctl daemon-reload

echo "[2/4] Checking .env..."
if [ ! -f "$REPO_DIR/.env" ]; then
    echo "⚠️  .env not found. Creating from .env.example..."
    cp "$REPO_DIR/.env.example" "$REPO_DIR/.env"
    echo "    → Edit $REPO_DIR/.env and add your GOOGLE_MAPS_API_KEY"
    exit 1
fi

echo "[3/4] Enabling and starting service..."
sudo systemctl enable mcp-google-map.service
sudo systemctl restart mcp-google-map.service

echo "[4/4] Verifying..."
sleep 2
sudo systemctl status mcp-google-map.service --no-pager | head -12

echo ""
echo "✅ Restore complete."
echo "   Endpoint: http://<host>:3020/mcp"
echo "   Logs:     journalctl -u mcp-google-map.service -f"
