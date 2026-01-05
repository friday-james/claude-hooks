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

# Extract basic info
session_id=$(echo "$hook_input" | jq -r '.session_id // "unknown"')
transcript_path=$(echo "$hook_input" | jq -r '.transcript_path // ""')
stop_hook_active=$(echo "$hook_input" | jq -r '.stop_hook_active // false')
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Prevent infinite loops
if [ "$stop_hook_active" = "true" ]; then
  exit 0
fi

# Expand tilde in path
transcript_path="${transcript_path/#\~/$HOME}"

# Get session name from transcript path or use session ID
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  # Extract project name from path (the parent directory name)
  session_name=$(basename "$(dirname "$transcript_path")")

  # Get Claude's last response from the transcript
  # Read last line, extract content from assistant message
  last_line=$(tail -1 "$transcript_path")

  # Check if it's an assistant message
  role=$(echo "$last_line" | jq -r '.role // ""')

  if [ "$role" = "assistant" ]; then
    # Extract content - could be array of content blocks or simple text
    claude_response=$(echo "$last_line" | jq -r '
      if .content | type == "array" then
        .content[] | select(.type == "text") | .text
      elif .content | type == "string" then
        .content
      else
        "No response"
      end
    ' | tr -d '\000')
  else
    claude_response="Task completed (no text response)"
  fi
else
  session_name="Session ${session_id:0:8}"
  claude_response="No transcript available"
fi

# Telegram max message length is 4096 chars
# Reserve some chars for headers, truncate response if needed
MAX_RESPONSE_LEN=3500
if [ ${#claude_response} -gt $MAX_RESPONSE_LEN ]; then
  claude_response="${claude_response:0:$MAX_RESPONSE_LEN}..."
fi

# Create message
MESSAGE="✅ Claude Code Task Completed

📁 Session: ${session_name}
🔖 ID: ${session_id:0:8}
⏰ Time: ${timestamp}

💬 Response:
${claude_response}"

# Send to Telegram
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -H "Content-Type: application/json" \
  -d "$(jq -n \
    --arg chat_id "$TELEGRAM_CHAT_ID" \
    --arg text "$MESSAGE" \
    '{chat_id: $chat_id, text: $text}')" > /dev/null 2>&1

exit 0
