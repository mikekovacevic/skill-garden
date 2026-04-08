---
name: weekly-digest
description: "Weekly Digest: Run a comprehensive weekly summary across Granola meetings, Jira, Slack, and calendar. Writes a retrospective to the weekly note. Use this skill when you ask for a weekly digest, week in review, weekly summary, or want to prep for the next week. Also trigger on 'how was my week', 'weekly recap', 'what happened this week', or 'prep for next week'."
license: MIT
metadata:
  visibility: public
  origin: self
  tags: daily-workflow
---

# Weekly Digest

You are the user's executive assistant. Run a comprehensive weekly summary across all connected tools and write the retrospective to the weekly note.

## Before starting

Read the following reference files:
- user-context/SKILL.md
- obsidian-vault/SKILL.md

## Meetings this week

Query Granola for this week's meetings. Summarize key decisions and recurring themes across the week.

## Action item audit

Review the weekly note for all action items across the week. Flag what's done vs still open. Identify anything that was missed or should carry forward to next week.

## Jira status

List all Jira issues you own. Highlight anything overdue, blocked, or at risk.

## Unresolved Slack threads

Find any Slack threads from this week where you are involved but haven't replied or closed the loop.

## Next week prep

Check Outlook calendar for Monday's meetings and surface any prep you should do before the week starts.

## Project gap scan

Read `${VAULT_ROOT}/projects/_index.md`. Compare the recurring themes and topics surfaced in this week's meetings against the active projects list. If any significant topic came up multiple times this week that isn't already tracked as a project, flag it as a candidate for a new project context — include the topic and a one-line rationale. If nothing new stands out, omit this section.

## Write the Weekly Retrospective

Insert a new `## Weekly Retrospective` section at the top of the weekly note, immediately after the `# Week of` heading line. Do not look for a placeholder — just prepend it. The section should look like:

```
## Weekly Retrospective

### Wins
- Key accomplishments and progress this week

### Carried Forward
- Open items that need attention next week

### Key Decisions
- Important decisions made this week and their context

### Notes
- Anything else worth remembering about this week
```

Keep each section to 2-4 bullets max. Be concise and factual. Only include genuinely notable items, not every small task.

## Commit to git

Commit vault changes per the git convention in obsidian-vault.md.

## Present the weekly digest

Output a scannable summary:
- **Meetings this week** — key decisions, recurring themes
- **Action items** — done vs open, anything overdue
- **Jira** — status of owned issues, blockers, risks
- **Slack** — unresolved threads that need attention
- **Next week** — Monday meetings, prep needed

End with a short "Week in review" paragraph you could use as a standup update.
- **Potential new projects** — recurring topics this week not yet tracked in _index.md (omit section if none)

## Eval

Before sending the Slack notification, verify:

1. The Weekly Retrospective section exists in the weekly note immediately after the `# Week of` heading
2. All four subsections (Wins, Carried Forward, Key Decisions, Notes) each have at least one bullet
3. The git commit for today was created

If any check fails, append `⚠️ Eval: [specific failure]` to the Slack message body.

## Send Slack notification

Send a Slack message to channel `${SLACK_DM_CHANNEL}` (personal DM) only. Do not send to any other channel or user under any circumstances.

The session name was provided in the prompt — use it exactly as given in the resume command.

```
**Weekly Digest** is ready
<obsidian://open?vault=vault&file=weekly/[MONDAY-DATE]|Open in Obsidian>
Resume: `claude --resume [SESSION_NAME]`
```

Where `[MONDAY-DATE]` is the Monday date of this week (the weekly note filename, YYYY-MM-DD) and `[SESSION_NAME]` is the session name from the prompt.
