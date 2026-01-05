# Claude Code Tools

Telegram notification hook for Claude Code task completion - get notified with Claude's full response when tasks finish!

## Example Notification

When Claude finishes a task, you'll receive a message like this:

```
✅ Claude Code Task Completed

📁 Session: my-awesome-project
🔖 ID: 4ea4998d
⏰ Time: 2026-01-05 12:15:30

💬 Response:
Perfect! I've updated the script to read from the transcript JSONL file to get the full response and proper session name.

The script now:
1. Reads the transcript_path from the Stop hook
2. Extracts the project/session name from the path
3. Gets Claude's full response from the last line of the JSONL file
4. Sends up to 3500 characters (to stay within Telegram's 4096 char limit)
5. Prevents infinite loops with stop_hook_active check

You should now receive much more detailed notifications with the actual response content!
```

## Features

- 📱 Full Claude response sent to Telegram (up to 3500 chars)
- 📁 Session/project name extraction
- 🔖 Session ID for reference
- ⏰ Timestamp of completion
- 🔒 Secure credential storage via environment variables
- 🔁 Infinite loop prevention

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/friday-james/claude-hooks/master/install.sh | bash
```

This installs the hook and configures Claude Code automatically. Run the same command to update.

## Setup

1. Set your Telegram credentials as environment variables in `~/.bashrc` or `~/.zshrc`:
   ```bash
   export TELEGRAM_BOT_TOKEN="your_bot_token_here"
   export TELEGRAM_CHAT_ID="your_chat_id_here"
   ```

2. Reload your shell:
   ```bash
   source ~/.bashrc  # or source ~/.zshrc
   ```

### Manual Install

If you prefer manual installation:

1. Copy the hook script:
   ```bash
   mkdir -p ~/.claude/hooks
   cp telegram-notify.sh ~/.claude/hooks/
   chmod +x ~/.claude/hooks/telegram-notify.sh
   ```

2. Add to `~/.claude/settings.json`:
   ```json
   {
     "hooks": {
       "Stop": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "$HOME/.claude/hooks/telegram-notify.sh",
               "timeout": 10
             }
           ]
         }
       ]
     }
   }
   ```

## Getting Telegram Credentials

1. Message [@BotFather](https://t.me/botfather) on Telegram
2. Send `/newbot` and follow prompts
3. Copy the bot token
4. Start a chat with your bot
5. Visit `https://api.telegram.org/bot<YOUR_TOKEN>/getUpdates` to get your chat ID

## Testing

```bash
echo '{"hook_event_name": "Stop", "session_id": "test123"}' | ~/.claude/hooks/telegram-notify.sh
```

You should receive a Telegram message.
