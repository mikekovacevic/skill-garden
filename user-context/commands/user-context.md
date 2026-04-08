Create or update the user context config file at `user-context/SKILL.md`.

If the file already exists, read it first and show the current values. Ask what the user wants to update.

If the file doesn't exist, ask for the following (one step at a time, confirm before writing):

1. **Full name**
2. **Email address**
3. **Role and company** (e.g. "Engineering Manager at Acme")
4. **Timezone** - city and abbreviation (e.g. "Toronto / Eastern Time (ET)")
5. **Connected tools** - for each, ask which they use:
   - Calendar: Outlook or Google Calendar
   - Email: Outlook or Gmail
   - Chat: Slack or Teams
   - Meeting notes: Granola, Otter, or manual
   - Project tracking: Jira, Linear, GitHub Issues, or none
   - ATS: Lever, Greenhouse, Ashby, or none

Write the file using this format:

```markdown
# User Context

## Identity

- **Name**: [name]
- **Email**: [email]
- **Role**: [role] at [company]
- **Timezone**: [city / timezone]. Always display calendar events and scheduled times in [abbreviation]. MCP tools return UTC - convert all times before presenting them.

## Connected Tools

- **Calendar**: [tool]
- **Email**: [tool]
- **Chat**: [tool]
- **Meeting notes**: [tool]
- **Project tracking**: [tool]
- **Notes**: Obsidian (see obsidian-vault skill for conventions)
- **ATS**: [tool]

## Slack Signal Rules

- Skip automated bot noise (alerts, billing notifications, CI pings, etc.)
- Flag anything time-sensitive or that cannot wait until tomorrow
- Default to Slack for all communication drafts; only use email when explicitly asked
```

After writing, confirm what was saved.
