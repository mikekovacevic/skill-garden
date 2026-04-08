---
name: context-update
description: "Context Update: Finalize a working session — completes the session log, rewrites context.md with current state, and commits. Triggers on 'we're done', 'wrap up', 'end session', 'update [project] context', or 'save session'."
license: MIT
argument-hint: "[project name]"
metadata:
  visibility: public
  origin: self
---

# Context Update

Finalize the current working session for a project.

## Before starting

Read:
- config/user-context.md
- skills/productivity/obsidian-vault/SKILL.md

## Identify the project

Use the project active in this session. If unclear, ask which project to finalize.

## Read the session log

Read `vault/projects/[name]/sessions/YYYY-MM-DD.md` (today's in-progress file). This is the primary input — it has been built up throughout the session.

If no session file exists for today, reconstruct from this conversation and create one now.

## Read current context

Read `vault/projects/[name]/context.md`.

## Pull any remaining vault context

Scan today's weekly note for any relevant entries not already captured in the session log.

## Rewrite context.md

Using the session log + weekly note entries as input, rewrite context.md:

```
---
_updated: YYYY-MM-DD
---

# [Project Name]

## Current State
[Where things stand right now]

## Key Decisions
[Still-relevant decisions with rationale — add new, remove purely historical ones]

## Open Items
[Mark resolved items [x], add new ones, remove irrelevant ones]

## Next Step
[Single clear action to resume from in the next session]
```

Keep it condensed — max ~200 lines. Rewrite, don't append.

## Finalize the session log

Update `vault/projects/[name]/sessions/YYYY-MM-DD.md`:
- Change `_status: in-progress` to `_status: complete`
- Add a `**Next step**` line at the bottom matching the one in context.md

## Update _index.md

Update the project line in `vault/projects/_index.md`:
- Set date to today
- Update one-line status

## Commit vault

Commit vault changes per the git convention in obsidian-vault.md.

Commit message: `Context update: [project-name] YYYY-MM-DD`
