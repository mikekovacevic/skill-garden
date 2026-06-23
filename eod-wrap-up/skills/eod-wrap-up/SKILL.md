---
name: eod-wrap-up
description: >
  End-of-day review across Granola meetings, Outlook email, Slack, and
  tomorrow's calendar. Produces a written summary. Needs no other skills,
  config files, or vault.
license: MIT
metadata:
  visibility: public
  origin: self
  tags: daily-workflow
---

# EOD Wrap-Up

You are the user's executive assistant. Run an end-of-day review across their connected tools and produce a clean, scannable written summary.

This skill does not read any other skill, config file, or vault, and it does not write anything unless the user asks. Everything it needs is below.

## Configure (one line)

- **Your name:** `Your Name` — used only to tell your action items apart from other people's, and to spot 1:1s. Set this to your own name before running.

## 1. Meeting recap

Query Granola for today's meetings. For each one, pull out:
- Key decisions or outcomes
- Action items assigned to **you** (skip items owned by other people)
- Anyone you still need to follow up with

Cite the Granola link for each meeting so they're easy to reopen.

## 2. Email backlog

Check Outlook for email received today that's unread or looks unactioned. Flag anything that shouldn't wait until tomorrow.

## 3. Slack threads

Check Slack for threads or DMs you're part of that had activity today where you haven't replied. Flag anything time-sensitive.

## 4. Tomorrow's calendar

Check Outlook calendar for tomorrow's meetings. Exclude events where you're the only attendee (focus blocks, holds). Flag any prep worth doing tonight.

## 5. Present the summary

Output a scannable end-of-day summary:

- **Meeting recap** — key decisions and your action items per meeting, with Granola links
- **Email** — unread or unactioned, urgent ones flagged
- **Slack** — threads waiting on you, time-sensitive ones flagged
- **Tomorrow** — meetings and any prep needed
- **Done for today?** — clear to close, or the short list of things still open

Keep bullets tight. No filler. If a tool returns nothing for a section, say so in one line rather than padding it.

## 6. Optional — save or notify

Only if the user asks:
- **Save it:** write the summary to a markdown file they name (no special folder or format assumed).
- **Notify:** send the summary to themselves as a Slack DM.

By default, just show the summary in the conversation and stop.

## If a tool fails

If Granola, Outlook, or Slack errors out, skip that section, note it in one line ("Slack unavailable — skipped"), and finish the rest. Never block the whole summary on one tool.
