#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.claude/bin:/usr/local/bin:$PATH"

SESSION_NAME="eod-wrap-up-$(date +%Y-%m-%d)"

# Portable log directory
if [ "$(uname)" = "Darwin" ]; then
  LOG_DIR="$HOME/Library/Logs/claude-tasks"
else
  LOG_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/claude-tasks/logs"
fi
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/eod-wrap-up.log"

# Find claude binary
CLAUDE_BIN="$(command -v claude 2>/dev/null)"
if [ -z "$CLAUDE_BIN" ]; then
  echo "[$(date)] ERROR: claude not found in PATH" >> "$LOG_FILE"
  exit 1
fi

WORKSPACE="$HOME/claude"

echo "[$(date)] Starting EOD wrap-up - session: $SESSION_NAME" >> "$LOG_FILE"

cd "$WORKSPACE" && "$CLAUDE_BIN" \
  -p "Run the EOD wrap-up skill. Read $WORKSPACE/skills/eod-wrap-up/SKILL.md and execute all steps fully. Your session name is ${SESSION_NAME} - use this exact string in the Slack notification resume command." \
  -n "${SESSION_NAME}" \
  --allowedTools "Read,Write,Edit,Bash,Glob,Grep,mcp__granola__get_meetings,mcp__granola__list_meetings,mcp__granola__query_granola_meetings,mcp__granola__get_meeting_transcript,mcp__granola__list_meeting_folders,mcp__claude_ai_Microsoft_365__outlook_calendar_search,mcp__claude_ai_Microsoft_365__outlook_email_search,mcp__claude_ai_Slack__slack_search_public_and_private,mcp__claude_ai_Slack__slack_read_channel,mcp__claude_ai_Slack__slack_send_message" \
  >> "$LOG_FILE" 2>&1

echo "[$(date)] EOD wrap-up complete" >> "$LOG_FILE"
