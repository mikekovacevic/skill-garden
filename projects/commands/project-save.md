Read `skills/productivity/obsidian-vault/SKILL.md` and `config/user-context.md` before proceeding.

Finalize the current working session for a project.

## Identify the project

Use the project active in this session. If unclear, ask which project to finalize.

## Determine the session file

Session file: `${VAULT_ROOT}/projects/[name]/sessions/YYYY-MM-DD.md`

- If the file exists with `_status: in-progress`, use it as the primary input
- If no session file exists for today, reconstruct from this conversation and create one
- If the project doesn't have a `sessions/` directory, create one

## Write or update the session log

```
# Session: [short title] - YYYY-MM-DD
_status: complete

## What was done
- Bullet points of key actions taken

## Decisions made
- Anything decided that affects future work

## Files changed
- List any files created or modified (skip if none)

## Next step
- Single clear action to resume from
```

## Rewrite context.md

Read `${VAULT_ROOT}/projects/[name]/context.md`, then rewrite it using the session log as input:

```
---
_updated: YYYY-MM-DD
---

# [Project Name]

## Current State
[Where things stand right now]

## Key Decisions
[Still-relevant decisions with rationale. Add new, remove purely historical ones]

## Open Items
[Mark resolved items [x], add new ones, remove irrelevant ones]

## Next Step
[Single clear action to resume from in the next session]
```

Keep it condensed, max ~200 lines. Rewrite, don't append.

## Update _index.md

Update the project line in `${VAULT_ROOT}/projects/_index.md`:
- Set date to today
- Update one-line status

## Commit vault

```bash
cd ${VAULT_ROOT}
git add -A
git commit -m "Context update: [project-name] YYYY-MM-DD"
```
