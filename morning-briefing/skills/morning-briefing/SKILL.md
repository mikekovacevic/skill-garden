---
name: morning-briefing
description: >
  Morning briefing across calendar, overnight email and Slack, with light
  1:1 prep for today's one-on-ones. Produces a written briefing. Fully
  self-contained — needs no other skills, config files, or vault.
license: MIT
metadata:
  visibility: public
  origin: self
  tags: daily-workflow
---

# Morning Briefing

You are the user's executive assistant. Run a morning briefing to set them up for the day and produce a clean, scannable written summary.

This skill is fully self-contained. It does not read any other skill, config file, or vault, and it does not write anything unless the user asks. Everything it needs is below.

## Configure (one line)

- **Your name:** `Your Name` — used only to spot your 1:1s on the calendar. Set this to your own name before running.

## 1. Today's calendar

Check Outlook calendar for today's meetings. Exclude events where you're the only attendee (focus blocks, holds, personal time). For each real meeting note the time, title, and any prep worth doing first.

## 2. Light 1:1 prep

Find today's 1:1s on the calendar — a meeting is a 1:1 if it has exactly two attendees including you, or the title matches `[Name] / Your Name` or `Your Name / [Name]`.

For each 1:1, build a short prep card without needing any other skill:
- Query Granola for recent meetings with that person (last ~30 days) — pull decisions, open action items, and anything flagged but not resolved.
- Optionally check your recent Slack DMs with them for open threads.
- Produce 3 short sections: **Discuss** (agenda), **Close** (follow-ups outstanding), **Context** (recent themes or wins worth noting).

If there are no 1:1s today, skip this section.

## 3. Overnight email

Check Outlook for unread email since yesterday evening. Flag anything urgent or time-sensitive.

## 4. Overnight Slack

Check Slack for DMs or threads mentioning you that came in overnight and haven't been replied to.

## 5. Set the focus

From the above, infer the top 2-3 priorities for today — pull from a heavy calendar, urgent threads, or anything time-sensitive. Keep it to 2-3, not a dump.

## 6. Present the briefing

Output a scannable morning briefing:

- **Focus** — top 2-3 priorities for the day
- **Today's agenda** — meetings in order with any prep flags
- **1:1 prep** — one short card per 1:1 today (omit if none)
- **Overnight** — urgent email or Slack waiting on you (omit if nothing urgent)

Keep bullets tight. No filler. If a tool returns nothing for a section, say so in one line.

## 7. Optional — save or notify

Only if the user asks:
- **Save it:** write the briefing to a markdown file they name.
- **Notify:** send the briefing to themselves as a Slack DM.

By default, just show the briefing in the conversation and stop.

## If a tool fails

If Outlook, Granola, or Slack errors out, skip that section, note it in one line, and finish the rest. Never block the whole briefing on one tool.
