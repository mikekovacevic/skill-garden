---
name: morning-briefing
description: "Morning Briefing: Run a daily morning briefing that checks calendar, email, Slack, and updates the Obsidian weekly note. Use this skill when you ask for a morning briefing, daily standup prep, or want to know what's on your plate for the day. Also trigger on 'what do I have today', 'morning update', 'prep my day', or 'what happened overnight'."
license: MIT
metadata:
  visibility: public
  origin: self
  tags: daily-workflow
---

# Morning Briefing

You are the user's executive assistant. Run a morning briefing to set them up for the day, then update their weekly note in Obsidian.

## Before starting

Read the following reference files:
- user-context/SKILL.md
- obsidian-vault/SKILL.md

## Read open action items

Read the weekly note and check for any open action items from previous days. Note anything overdue or carried forward.

## Project health check

Read `${VAULT_ROOT}/projects/_index.md`. For each active project, check the date field. Flag any project where the date is more than 30 days ago as stale. Collect stale projects for inclusion in the briefing output. If no projects are stale, omit the Projects section entirely.

## Today's calendar

Check Outlook calendar for today's meetings. Exclude any events where you are the only attendee (focus blocks, holds, personal blocks, etc.) — only include meetings with at least one other person. For each included meeting note:
- Time and title
- Any prep you should do before it

## 1:1 prep

Read `1on1-prep/SKILL.md` and run it for any 1:1s detected on today's calendar.

Identify 1:1s using these criteria:
- Title contains `${USER_NAME}` AND exactly 2 attendees, OR
- Title matches patterns like `[Name] / ${USER_NAME}` or `${USER_NAME} / [Name]`

For each 1:1 found, run the full 1on1-prep skill and collect the prep card(s). These will be included in the final output under `### 1:1 Prep`. If no 1:1s are on the calendar today, skip this step.

## Email overnight

Check Outlook for unread emails that arrived since yesterday EOD. Flag anything urgent or time-sensitive.

## Slack overnight

Check Slack for any DMs or threads mentioning you that came in overnight and haven't been replied to.

## Update the weekly note

The weekly note uses **reverse chronological order** — the most recent day is at the top, just below the Open Action Items block.

If today's section does not yet exist in the file:
- Create a new day section (Focus, Agenda, Notes, Action Items with placeholders)
- Insert it at the TOP of the day sections, immediately after the `---` that follows the Open Action Items block
- Do NOT create sections for future days

If today's section already exists, find it and update:
- **Focus**: Replace the placeholder with the top 2-3 priorities for today. Determine priorities from: yesterday's incomplete action items (carryover), today's calendar (what's heavy or important), any urgent Slack threads. Keep it to 2-3 items max.
- **Agenda**: Replace the placeholder with today's meetings in chronological order. Exclude self-only calendar blocks.

IMPORTANT: Do NOT touch the "### Action Items" or "### Notes" sections if they already have content. Only replace HTML comment placeholders.

If the weekly file doesn't exist, create it with only today's section (plus Weekly Retrospective at the bottom). See obsidian-vault.md reference for template and rules.

## Commit to git

Commit vault changes per the git convention in obsidian-vault.md.

## Check open follow-ups

Read `${VAULT_ROOT}/follow-ups.md` if it exists. Surface any open items (under `## Open`) in the briefing. If there are none, omit the section entirely.

## Present the morning briefing

Output a scannable summary:
- **Focus** — top 2-3 priorities for the day
- **Today's agenda** — meetings in order with any prep flags
- **1:1 Prep** — one prep card per 1:1 detected today (omit section if none)
- **Overnight email/Slack** — anything urgent that needs a response
- **Due today** — any action items with today's due date
- **Follow-ups** — open items from follow-ups.md (omit section if none)
- **Projects** — any active projects not updated in 30+ days, flagged as stale (omit section if none)

## Eval

Before sending the Slack notification, verify:

1. Today's section exists in the weekly note and Focus/Agenda are not still HTML comment placeholders
2. If 1:1s were detected on the calendar, at least one prep card is present in the output
3. The git commit for today was created

If any check fails, append `⚠️ Eval: [specific failure]` to the Slack message body.

## Send Slack notification

Send a Slack message to channel `${SLACK_DM_CHANNEL}` (personal DM) only. Do not send to any other channel or user under any circumstances.

The session name was provided in the prompt — use it exactly as given in the resume command.

```
**Morning Briefing** is ready
<obsidian://open?vault=vault&file=weekly/[MONDAY-DATE]|Open in Obsidian>
Resume: `claude --resume [SESSION_NAME]`
```

Where `[MONDAY-DATE]` is the Monday date of this week (the weekly note filename, YYYY-MM-DD) and `[SESSION_NAME]` is the session name from the prompt.
