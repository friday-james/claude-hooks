# Claude Code Tools

Telegram notification hook for Claude Code task completion.

## Setup

1. Copy the hook script to your Claude hooks directory:
   ```bash
   cp telegram-notify.sh ~/.claude/hooks/
   chmod +x ~/.claude/hooks/telegram-notify.sh
   ```

2. Add your Telegram credentials to the script:
   - Edit `~/.claude/hooks/telegram-notify.sh`
   - Replace `YOUR_BOT_TOKEN_HERE` with your bot token
   - Replace `YOUR_CHAT_ID_HERE` with your chat ID

3. Add the hook configuration to `~/.claude/settings.json`:
   ```json
   {
     "hooks": {
       "Stop": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "/home/james/.claude/hooks/telegram-notify.sh",
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
