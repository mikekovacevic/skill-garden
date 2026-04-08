---
name: context-handoff
description: "Context Handoff: End a session cleanly and prepare to resume it later — in a new Claude Code session or on mobile. If working on a named project, runs context-update first then generates a resume prompt. Triggers on 'export context', 'end session', 'handoff', 'resume later', 'switch to mobile', or 'context handoff'."
license: MIT
metadata:
  visibility: public
  origin: self
---

# Context Handoff

End a working session cleanly so it can be resumed in a new Claude Code session or on mobile.

## Before starting

Read `skills/productivity/obsidian-vault/SKILL.md` — needed for vault project paths and session file conventions.

---

## When working on a named project

If this session has been working on a project in `vault/projects/`:

1. Run the **context-update** skill first — this saves the project state and writes a session summary to `sessions/`
2. Then generate a short resume prompt (see below) pointing at the project context

The session summary IS the handoff for project work. The resume prompt just tells the next session where to look.

**Resume prompt format:**
```
Resume [project-name] work. Read vault/projects/[name]/context.md and the latest file in vault/projects/[name]/sessions/ to get up to speed, then pick up from the Next Step.
```

---

## When NOT working on a named project

For ad-hoc sessions with no project context file, generate a full handoff summary:

```
## Session Handoff

**Goal**: [one sentence — what are we trying to accomplish?]

**Context**: [2-4 bullets of background needed to understand the work]

**What we did**: [bullet list of decisions made, outputs created, progress so far]

**Files touched**: [list any files created or modified with their paths]

**Open questions**: [anything unresolved or deferred]

**Next step**: [single clear action to pick up from]

**Resume prompt**: [one sentence to paste to kick off the next session]
```

Keep it tight. 30-second read. Everything a new session needs, nothing it doesn't.

---

## Importing context (starting a session with a handoff)

When a handoff summary or resume prompt is pasted at the start of a session:

1. If it's a project resume prompt: read the context.md and latest session file, then confirm the goal and next step in one sentence
2. If it's a full handoff summary: acknowledge the context in one sentence, ask one question if anything is ambiguous, then proceed from the Next Step

Do not re-explain what was done. Just resume.

---

## Mobile use

To hand off to Claude.ai mobile: generate the full handoff summary format above and paste it into a new Claude.ai chat.

To hand back from mobile: end the mobile session with "generate a handoff summary" and paste the result into a new Claude Code session.
