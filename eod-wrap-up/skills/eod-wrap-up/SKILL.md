---
name: eod-wrap-up
description: >
  End-of-day review across Granola, email, Slack, and calendar.
  Updates the weekly note with meeting notes and action items.
license: MIT
metadata:
  visibility: public
  origin: self
  tags: daily-workflow
---

# EOD Wrap-Up

You are the user's executive assistant. Run an end-of-day review across connected tools and write the results to the weekly note.

## Before starting

Read the following reference files:
- config/user-context.md
- obsidian-vault/SKILL.md

## Read current state

Read the weekly note. Note any existing content in today's Action Items section (you may have added items manually during the day). These must not be overwritten.

## Meeting recap

Query Granola for today's meetings. For each one, extract:
- Key decisions made
- Action items assigned to you (NOT items assigned to others)
- Anyone you need to follow up with

## 1:1 vault updates

For any meeting today that was a 1:1 (title contains `${USER_NAME}` with exactly 2 attendees, or matches `[Name] / ${USER_NAME}` / `${USER_NAME} / [Name]`):

**Derive the vault file path:**
Convert the other person's name to lowercase-hyphenated format (e.g., "Robert Robinson" -> `robert-robinson`).
Path: `${VAULT_ROOT}/meetings/1-1s/[name].md`

**If the file doesn't exist:** create it with the structure below and write today's dated entry.

```
# 1:1 - [Full Name]

## Next 1:1

<!-- -->

---

## [Today's date, e.g. March 23, 2026]

[notes]
```

**If the file exists:** read it first, then:

1. **Handle the `## Next 1:1` section:**
   - Cross-reference each item against today's Granola notes
   - Items clearly discussed and resolved: remove from `## Next 1:1`
   - Items not clearly addressed or uncertain: move them into today's dated entry with a `(carried forward)` label, then remove from `## Next 1:1`
   - After handling all items, leave `## Next 1:1` blank (just the placeholder comment) for adding new agenda items

2. **Write today's dated entry** immediately after the `## Next 1:1` section, before any existing dated entries. Format:

```
## [Month Day, Year]

- [Key decisions or outcomes from the meeting]
- [Action items: note who owns each one, flag your items clearly]
- [Any follow-ups or next steps discussed]
- (carried forward) [items moved from Next 1:1 that weren't clearly addressed]
```

Only include your action items in the weekly note (per existing rules). The 1:1 vault file can include action items for both parties since it's context for the relationship.

## Email backlog

Check Outlook for emails received today that are unread or likely unactioned. Flag any that should not wait until tomorrow.

## Slack threads

Check Slack for threads or DMs you are part of that had activity today and where you haven't replied. Flag anything time-sensitive.

## Tomorrow's calendar

Check Outlook calendar for tomorrow's meetings. Flag any prep you should do tonight.

## Update the weekly note

Find today's section in the weekly note and update:
- **Notes**: Brief summary of today's key meeting decisions from Granola (2-4 bullets per meeting). Do not overwrite existing notes.
- **Action Items**: APPEND new items below any existing items. Use Tasks plugin syntax. Only add items that are your responsibility, not items owned by other people even if discussed in meetings.

IMPORTANT: Do NOT touch action-items.md. It uses dynamic Tasks query blocks and updates itself automatically.

## Commit to git

Commit vault changes per the git convention in obsidian-vault.md.

## Project context check

Read `${VAULT_ROOT}/projects/_index.md`. Review today's meeting decisions and action items against the active projects list. For any decision or meaningful development that relates to a tracked project, note it as a candidate for a context update — include the project name and a one-line summary of what changed or was decided.

## Present the EOD summary

Output a scannable summary:
- **Meeting Recap** — key decisions + action items per meeting (include Granola citation links)
- **1:1 Updates** — for each 1:1 today: confirm vault file was updated, list any carried-forward items that weren't resolved, note new action items
- **Email Backlog** — unread/unactioned emails, flag urgent ones
- **Slack** — unanswered threads, flag time-sensitive ones
- **Carryover / Jira** — note any action items that should become Jira tickets
- **Tomorrow** — meetings and any prep needed
- **Done for today?** — clear to close, or list flagged items still open
- **Context updates** — projects where today's decisions warrant a context update (omit section if none)

## Eval

Before sending the Slack notification, verify:

1. Today's Notes section in the weekly note has content (not just a placeholder)
2. Today's Action Items section has at least one item (if any meetings occurred today)
3. For any 1:1 detected today, the person's vault file contains an entry dated today
4. The git commit for today was created

If any check fails, append `⚠️ Eval: [specific failure]` to the Slack message body.

## Send Slack notification

Send a Slack message to channel `${SLACK_DM_CHANNEL}` (personal DM) only. Do not send to any other channel or user under any circumstances.

The session name was provided in the prompt — use it exactly as given in the resume command.

```
**EOD Wrap-Up** is ready
<obsidian://open?vault=vault&file=weekly/[MONDAY-DATE]|Open in Obsidian>
Resume: `claude --resume [SESSION_NAME]`
```

Where `[MONDAY-DATE]` is the Monday date of this week (the weekly note filename, YYYY-MM-DD) and `[SESSION_NAME]` is the session name from the prompt.
