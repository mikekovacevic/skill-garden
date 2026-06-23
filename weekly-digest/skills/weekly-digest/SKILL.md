---
name: weekly-digest
description: >
  Weekly retrospective across Granola meetings, Jira, Slack, and next
  week's calendar. Produces a written digest. Fully self-contained —
  needs no other skills, config files, or vault.
license: MIT
metadata:
  visibility: public
  origin: self
  tags: daily-workflow
---

# Weekly Digest

You are the user's executive assistant. Run a comprehensive weekly review across their connected tools and produce a clean, scannable retrospective.

This skill is fully self-contained. It does not read any other skill, config file, or vault, and it does not write anything unless the user asks. Everything it needs is below.

## Configure (one line)

- **Your name:** `Your Name` — used only to identify the items and Jira issues that are yours. Set this to your own name before running.

## 1. Meetings this week

Query Granola for this week's meetings. Summarize key decisions and recurring themes across the week — what kept coming up, not a meeting-by-meeting dump.

## 2. Jira status

List the Jira issues you own. Highlight anything overdue, blocked, or at risk.

## 3. Unresolved Slack threads

Find Slack threads from this week where you're involved but haven't replied or closed the loop. Flag anything still waiting on you.

## 4. Next week prep

Check Outlook calendar for Monday's meetings and surface any prep worth doing before the week starts.

## 5. Build the retrospective

From everything above, write a short retrospective with these four sections (2-4 bullets each, only genuinely notable items):

- **Wins** — key accomplishments and progress this week
- **Carried forward** — open items that need attention next week
- **Key decisions** — important decisions made this week and their context
- **Notes** — anything else worth remembering about this week

## 6. Present the digest

Output a scannable summary:

- **Meetings this week** — key decisions, recurring themes
- **Jira** — status of owned issues, blockers, risks
- **Slack** — unresolved threads that need attention
- **Next week** — Monday meetings, prep needed
- **Retrospective** — the Wins / Carried forward / Key decisions / Notes from step 5

End with a short "Week in review" paragraph you could paste straight into a standup update.

## 7. Optional — save or notify

Only if the user asks:
- **Save it:** write the digest to a markdown file they name.
- **Notify:** send the digest to themselves as a Slack DM.

By default, just show the digest in the conversation and stop.

## If a tool fails

If Granola, Jira, Outlook, or Slack errors out, skip that section, note it in one line, and finish the rest. Never block the whole digest on one tool.
