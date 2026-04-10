# [YOUR_NAME]

## Who I am

[Role] at [Company]. I manage [team name(s)]. My directs include [name], [name], and [name]. I report to [manager name], [manager title].

## My workflow

Three scheduled tasks run daily:
- **Morning briefing** (8:08am weekdays) - calendar, overnight email/Slack, updates weekly note Focus + Agenda
- **EOD wrap-up** (5:07pm weekdays) - recaps meeting notes, appends action items to weekly note
- **Weekly digest** (4:31pm Fridays) - week summary, writes Weekly Retrospective to weekly note

## Obsidian vault

Vault root: `[YOUR_HOME_DIR]/claude/vault/`
- `weekly/YYYY-MM-DD.md` - weekly notes (Monday-dated)
- `meetings/1-1s/firstname-lastname.md` - 1:1 notes
- `projects/_index.md` - active project list
- `projects/[name]/context.md` - project current state
- `projects/[name]/sessions/YYYY-MM-DD.md` - session logs
- `projects/archive/` - completed projects
- `action-items.md` - dynamic Tasks query. Do NOT write to it directly.

Full vault conventions: `obsidian-vault/SKILL.md`

## Projects

When I say "I'm working on [project]", "resume [project]", or "pick up [project]":

1. Check `sessions/` for any file with `_status: in-progress` - if found: "There's an unfinished session from [date]. Continue from there or start fresh?"
2. Read `context.md` - note the `_updated` date
3. Scan recent weekly notes for relevant entries dated after `_updated`. If found: "Found updates since [date] - roll them in before we start?"
4. Create `sessions/YYYY-MM-DD.md` with `_status: in-progress`, the session goal, and a one-line context summary. Create `sessions/` if it doesn't exist.
5. Append a bullet to the session log after each meaningful action (decision made, file modified, investigation complete)

When I say "we're done", "wrap up", or "end session" - run `/project-save` to finalize.

**Session log format:**
```
# Session - YYYY-MM-DD
_status: in-progress

**Goal**: [goal]

## Log
- Loaded context: [one-line current state]
- [entries appended during session]
```

**Other commands:**
- "Start a context for [project]" - create context.md, add to _index.md
- "Archive [project]" - move to archive/, remove from _index.md
- "Resume [project] from archive" - move back, add to _index.md
- "List my projects" - read _index.md + scan archive/

## Connected tools

[List your connected MCP tools, e.g.: Outlook (calendar + email), Slack, Granola (meeting notes), Jira, Obsidian]

## Preferences

- Short bullet points, scannable
- Conversational tone, not formal
- Default to Slack messages (ask before writing emails)
- [Add your own preferences here]
