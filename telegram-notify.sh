#!/bin/bash

# Telegram credentials - reads from environment variables
# Set these in your ~/.bashrc or ~/.zshrc:
#   export TELEGRAM_BOT_TOKEN="your_token"
#   export TELEGRAM_CHAT_ID="your_chat_id"

if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
  echo "Error: TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID must be set as environment variables" >&2
  exit 1
fi

# Read hook input from stdin
hook_input=$(cat)

# Extract session info
session=$(echo "$hook_input" | jq -r '.session_id // "unknown"' | cut -c1-8)
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Create message
MESSAGE="✅ Claude Code task completed

Session: ${session}
Time: ${timestamp}"

# Send to Telegram
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -H "Content-Type: application/json" \
  -d "{
    \"chat_id\": \"${TELEGRAM_CHAT_ID}\",
    \"text\": \"${MESSAGE}\"
  }" > /dev/null 2>&1

exit 0
