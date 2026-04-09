#!/bin/bash
SESSION_NAME="eod-wrap-up-$(date +%Y-%m-%d)"
LOG_FILE="$HOME/Library/Logs/claude-tasks/eod-wrap-up.log"

echo "[$(date)] Starting EOD wrap-up — session: $SESSION_NAME" >> "$LOG_FILE"

cd /Users/YOUR_USERNAME/claude && /Users/YOUR_USERNAME/.local/bin/claude \
  -p "Run the EOD wrap-up skill. Read /Users/YOUR_USERNAME/claude/eod-wrap-up/SKILL.md and execute all steps fully. Your session name is ${SESSION_NAME} — use this exact string in the Slack notification resume command." \
  -n "${SESSION_NAME}" \
  --allowedTools "Read,Write,Edit,Bash,Glob,Grep,mcp__granola__get_meetings,mcp__granola__list_meetings,mcp__granola__query_granola_meetings,mcp__granola__get_meeting_transcript,mcp__granola__list_meeting_folders,mcp__claude_ai_Microsoft_365__outlook_calendar_search,mcp__claude_ai_Microsoft_365__outlook_email_search,mcp__claude_ai_Slack__slack_search_public_and_private,mcp__claude_ai_Slack__slack_read_channel,mcp__claude_ai_Slack__slack_send_message" \
  >> "$LOG_FILE" 2>&1

echo "[$(date)] EOD wrap-up complete" >> "$LOG_FILE"
