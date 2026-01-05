#!/bin/bash

# Your Telegram credentials - REPLACE THESE
TELEGRAM_BOT_TOKEN="YOUR_BOT_TOKEN_HERE"
TELEGRAM_CHAT_ID="YOUR_CHAT_ID_HERE"

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
