---
name: follow-up
description: "Quickly capture a follow-up item — an idea, investigation, or Cowork session to revisit later. Use when wrapping up a session and want to park something without losing context, or any time mid-session when something comes up you don't want to forget. Trigger phrases: add a follow-up, log this for later, park this, I want to come back to this, remind me to look into, capture this as a follow-up, save this idea."
license: MIT
metadata:
  visibility: public
  origin: self
---

# Follow-up Capture

Use this skill to quickly park an idea, investigation, or session thread so it doesn't get lost while you stay focused on active work.

**This is not for work action items.** Work tasks that come out of meetings or notes go in the weekly note under `### Action Items` for the relevant day. Follow-ups are for Claude investigations, session continuations, and things to explore or revisit — not deliverables.

## Before you start

Read `skills/productivity/obsidian-vault/SKILL.md` for vault paths and commit conventions.

## What to capture

Gather the following — infer from conversation context where you can, and only ask for what's genuinely missing:

1. **Title** — short name (5–10 words)
2. **Why / context** — what prompted this; one sentence
3. **Next action** — what to do when you come back; be specific
4. **Target date** — optional; only include if the user mentions a timeframe

If you can infer most of it from the conversation, skip asking and just confirm with a one-liner.

## File location

`${VAULT_ROOT}/follow-ups.md`

Create the file if it doesn't exist using the structure in the "File structure" section below.

## Capture the source session

Include the current session name in the entry if known (e.g. from a recent `/rename` or from context). This makes it scannable when reviewing follow-ups later.

If you can't identify the session name confidently, omit it rather than guess.

## Entry format

Today is !`date +%Y-%m-%d`.

One line per follow-up. Append inside the `> [!note]- Entries` callout block, newest first. Prefix each line with `> ` to keep it inside the callout. Do not add entries inside the query blocks — the Open and Done sections update automatically.

```
- [ ] **[Title]**: [why/context]. Next: [specific action] ➕ YYYY-MM-DD 📅 YYYY-MM-DD — _[Session title]_
```

## File structure (if creating from scratch)

````markdown
# Follow-ups

## Open

```tasks
not done
path includes follow-ups
hide created date
hide done date
hide scheduled date
hide start date
hide edit button
```

## Done

```tasks
done
path includes follow-ups
hide created date
hide scheduled date
hide start date
hide edit button
sort by done reverse
```

> [!note]- Entries
> <!-- new entries go here, prefixed with > -->
````

## After writing

One short confirmation, e.g. "Logged." or "Parked for later." Then commit:

```bash
cd ${VAULT_ROOT}
git add follow-ups.md
git commit -m "Follow-up: YYYY-MM-DD"
```
