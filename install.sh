#!/bin/bash

set -e

REPO_URL="https://raw.githubusercontent.com/friday-james/claude-hooks/master"
HOOKS_DIR="$HOME/.claude/hooks"
SETTINGS_FILE="$HOME/.claude/settings.json"

echo "📦 Claude Code Telegram Notification Hook Installer"
echo ""

# Create hooks directory
mkdir -p "$HOOKS_DIR"

# Download the hook script
echo "⬇️  Downloading telegram-notify.sh..."
curl -fsSL "$REPO_URL/telegram-notify.sh" -o "$HOOKS_DIR/telegram-notify.sh"
chmod +x "$HOOKS_DIR/telegram-notify.sh"
echo "✓ Installed to $HOOKS_DIR/telegram-notify.sh"

# Check if settings.json exists
if [ ! -f "$SETTINGS_FILE" ]; then
  echo "{}" > "$SETTINGS_FILE"
fi

# Check if hook is already configured
if jq -e '.hooks.Stop[]?.hooks[]? | select(.command | contains("telegram-notify"))' "$SETTINGS_FILE" > /dev/null 2>&1; then
  echo "✓ Hook already configured in settings.json"
else
  echo "⚙️  Adding hook to Claude Code settings..."
  # Add the Stop hook configuration
  jq '.hooks.Stop = [{"hooks": [{"type": "command", "command": "$HOME/.claude/hooks/telegram-notify.sh", "timeout": 10}]}]' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"
  mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
  echo "✓ Hook configured in $SETTINGS_FILE"
fi

echo ""
echo "⚠️  Before using, set these environment variables in your shell config:"
echo "   export TELEGRAM_BOT_TOKEN=\"your_bot_token\""
echo "   export TELEGRAM_CHAT_ID=\"your_chat_id\""
echo ""
echo "✅ Installation complete!"
