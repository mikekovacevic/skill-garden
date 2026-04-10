---
name: 1on1-prep
description: >
  Prepare for a 1:1 by pulling context from the vault, Granola, and Slack DMs.
license: MIT
argument-hint: "[person name]"
metadata:
  visibility: public
  origin: self
  tags: productivity
---

# 1:1 Prep

Prepare a structured prep card for a 1:1 meeting with a specific person, or for all 1:1s today.

## Before starting

Read the following reference files:
- config/user-context.md
- obsidian-vault/SKILL.md

## Identifying the person(s)

If a specific person is named, use them directly.

Otherwise, check Outlook calendar for today's meetings and identify 1:1s using these criteria:
- Title contains `${USER_NAME}` AND the meeting has exactly 2 attendees, OR
- Title matches patterns like `[Name] / ${USER_NAME}` or `${USER_NAME} / [Name]`

Run all steps below for each identified person.

---

## Derive the vault file path

Convert the person's full name to lowercase-hyphenated format.

Examples:
- "Jane Smith" -> `jane-smith`
- "Alex Johnson" -> `alex-johnson`

Vault file path: `${VAULT_ROOT}/meetings/1-1s/[name].md`

If the file doesn't exist yet, note that — do not create it during prep. The EOD skill creates it after the first meeting occurs.

## Read the vault file

If it exists, read:
- The `## Next 1:1` section — standing agenda items built up between meetings
- The most recent dated section — context on what was last discussed
- Any recurring themes or open threads across older entries

Note the date of the most recent dated entry — this becomes the Granola lookback start date.

## Query Granola for recent notes

Determine the lookback window:
- If the vault file has no dated entries (or doesn't exist): look back 30 days
- Otherwise: query from the date of the most recent dated entry to today

Query Granola for meetings involving the person by name. Focus on extracting:
- Key decisions or outcomes
- Action items assigned to you or to the other person
- Anything flagged but not yet confirmed resolved

## Find the person's Slack user ID

Use `slack_search_users` to find the person by full name and retrieve their Slack user ID.

## Search for Slack canvases in the DM

Using the person's Slack user ID:
- Search with `in:<@USER_ID> type:canvases`, `content_types: files`, `channel_types: im`
- Read any canvases found using `slack_read_canvas`
- Note canvas titles and relevant content

## Synthesize the prep card

Produce a structured prep card:

---

**[Person Name] / ${USER_NAME} — [time, with Zoom link if available]**

**Agenda — what to discuss**
- Items from the `## Next 1:1` vault section and any canvas topics
- Unresolved items or themes surfaced in Granola notes

**Follow-ups to close**
- Action items from prior meetings (yours or theirs) not yet confirmed done
- Anything flagged in Granola or the vault that is still open

**Reminders / context**
- Recurring themes, tensions, or dynamics from vault history
- Wins to acknowledge, team context, anything to be mindful of going in

---

Keep bullets short and scannable. No filler. Cite Granola links inline where relevant.

## Write prep to the vault file

After synthesizing the prep card, write it into the person's vault file so it's available when you open the note.

If the vault file exists:
- Find the `## Next 1:1` section
- If it contains only a `<!-- -->` placeholder, replace it with a `### Prep — YYYY-MM-DD` block containing the Agenda, Follow-ups to close, and Reminders sections from the prep card
- If `## Next 1:1` already has content (standing items added manually), insert the `### Prep — YYYY-MM-DD` block above the existing content, preserving it below

If the vault file does not exist yet:
- Skip this step — the EOD skill creates the file after the first meeting occurs

Do NOT modify any dated meeting sections (e.g. `## March 23, 2026`). Only update `## Next 1:1`.

## Output

When called standalone: output the prep card directly.

When called from the morning briefing: return the prep card(s) to be embedded under `### 1:1 Prep` in the morning brief output.
