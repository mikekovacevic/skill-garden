---
name: projects
description: >
  Project lifecycle management: creating, resuming, saving, and listing projects in the vault.
  Defines project phases (investigation, T2, T1), context.md format, session logs, archiving,
  and confidential project rules. Loaded automatically when working with projects.
  Use when creating a project, resuming work, saving session state, or listing active projects.
license: MIT
user-invocable: false
metadata:
  visibility: public
  origin: self
  tags: project-management
---

# Projects

Projects live in `${VAULT_ROOT}/projects/`. Each project is a directory with a `context.md` file and optional session logs.

## Commands

Install these to `~/.claude/commands/` for slash command access:

| Command | File | What it does |
|---|---|---|
| `/project-list` | `commands/project-list.md` | Show active projects from _index.md |
| `/project-new` | `commands/project-new.md` | Create a new project from raw context |
| `/project-resume` | `commands/project-resume.md` | Pick a project and resume work |
| `/project-save` | `commands/project-save.md` | Save session state and write a session summary |

## Project structure

```
${VAULT_ROOT}/projects/
  _index.md                          # Active project list (markdown table)
  [name]/
    context.md                       # Current state snapshot (max ~200 lines)
    sessions/                        # Dated session logs (T1 only)
      YYYY-MM-DD.md
  archive/                           # Completed projects
```

## Phases

A project can graduate from one phase to the next:

- **investigation** - early-stage dig, may go nowhere or may graduate to T2/T1
- **T2** - tracked context, progressed mostly through meetings. Has `context.md` only.
- **T1** - active recurring work with multiple Claude Code sessions. Has `context.md` + `sessions/`.

## _index.md format

```
| name | investigation|T2|T1 | YYYY-MM-DD | one-line status |
```

Only active projects appear here. Update the date and status line when running project-save.

## context.md format

```
---
_updated: YYYY-MM-DD
---

# Project Title

## Current State
...

## Key Decisions
...

## Open Items
- [ ] ...

## Next Step
...
```

Always condensed (rewritten, not appended). Max ~200 lines. For stub files awaiting extraction, add `_status: needs-extraction`.

## Archiving

Move folder to `${VAULT_ROOT}/projects/archive/`, remove from `_index.md`. Do not delete.

## Stale detection

Projects with `_updated` older than 30 days should be flagged in the morning briefing.

## Confidential projects

Projects with `_confidential: true` in context.md frontmatter contain sensitive data that must not appear in scheduled task outputs, Slack drafts, meeting notes, or any context visible to others. Only accessed when the user explicitly asks to work on them.
