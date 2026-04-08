---
name: write-a-skill
description: >
  Create, review, or lint agent skills following the directory-per-skill convention.
  Use when creating a new skill, reviewing an existing skill's structure, linting a skill
  against convention rules, or when asked to "write a skill", "create a skill", "lint this
  skill", or "check skill structure".
license: MIT
metadata:
  visibility: public
  origin: self
---

# Write a Skill

## Process

1. **Gather requirements**: ask about the task/domain, specific use cases, whether it needs scripts, and any reference materials
2. **Draft the skill**: create SKILL.md + reference files following the convention below
3. **Review with user**: present the draft, ask what's missing or unclear
4. **Lint check**: run the review checklist before finalizing

## Directory Convention

```
skill-name/
  SKILL.md            # Main instructions (required)
  REFERENCE.md        # Detailed docs, templates, rubrics (if needed)
  examples.md         # Usage examples (optional)
  scripts/            # Utility scripts (optional)
```

- `SKILL.md` is the entry point. The agent reads this first.
- Reference files hold overflow content that SKILL.md links to inline.
- Directory name matches the `name` field in frontmatter, kebab-case.

## Frontmatter

Every SKILL.md starts with:

Follows the [Agent Skills specification](https://agentskills.io/specification).

```yaml
---
name: skill-name
description: >
  What it does in one sentence. Use when [specific trigger phrases and keywords].
license: MIT
metadata:
  visibility: public
  origin: self
---
```

### Top-level fields (agentskills.io spec)

| Field | Required | Notes |
|---|---|---|
| `name` | Yes | Max 64 chars, lowercase + hyphens, must match directory name |
| `description` | Yes | Max 1024 chars. First 250 show in slash command menu. |
| `license` | No | Add `MIT` for public skills |
| `compatibility` | No | Environment requirements if any |
| `allowed-tools` | No | Space-delimited list of pre-approved tools (experimental) |

### Claude Code extensions (top-level)

| Field | Default | Use when |
|---|---|---|
| `user-invocable: false` | true | Skill is background knowledge or auto-match only. Hides from `/` menu. |
| `argument-hint: "[thing]"` | (none) | Skill expects user input at invocation. Shows hint in `/` menu. |

### Metadata fields (custom, inside `metadata:`)

| Field | Use when |
|---|---|
| `visibility: public\|internal\|private` | Always set. Controls lint rules and publish eligibility. |
| `origin: self\|<repo URL>` | Always set. `self` for skills you wrote, repo URL for installed skills. |

### Visibility tiers

| Tier | Rules | Publish target |
|---|---|---|
| `public` | Variables only, no personal or company info | Garden repo |
| `internal` | Can reference company tools/systems, no personal info | Local only (or company repo) |
| `private` | No restrictions | Local only |

### Description rules

The description is the **only thing the agent sees** when deciding which skill to load. It's surfaced in the system prompt alongside all other installed skills.

- First sentence: what capability this provides
- Second sentence: "Use when [specific triggers with keywords]"
- Max 1024 characters. First 250 characters show in the slash command menu, so front-load the capability statement.
- Written in third person
- Include actionable keywords the agent can match on

**Good**: "Generate structured ATS interview feedback from a meeting transcript. Use when asked to generate feedback for a candidate, write up interview notes, or process a hiring screen after a call."

**Bad**: "Helps with hiring."

## SKILL.md Rules

- **Target under 100 lines.** If over 100, split into SKILL.md + REFERENCE.md.
- Lead with the workflow (what to do), not background (why).
- Link reference files inline where relevant: `See [REFERENCE.md](REFERENCE.md)`
- No hardcoded user paths, names, or channel IDs in library skills. Use `${VAULT_ROOT}`, `${WORKSPACE_ROOT}`, `${SLACK_DM_CHANNEL}`.
- Reference other skills by name, not by file path. The agent decides when to load them.
- Embed short templates inline. Move long templates (>20 lines) to REFERENCE.md.

## Shell Preprocessing

Claude Code can inject shell output into a skill before the agent reads it. Only fires through the skill system (`/command` or auto-match), not `claude -p` with `Read`.

**Use for:** deterministic, fast lookups the skill always needs (today's date, git branch, env vars, reading a short file).
**Avoid for:** network calls, anything needing agent judgment, large outputs that bloat the prompt.

Inline: `` !`date +%Y-%m-%d` `` resolves before the agent sees the prompt.

Multi-line block:

    ```!
    git branch --show-current
    wc -l vault/follow-ups.md
    ```

Output replaces the block. The agent never sees the commands.

## When to Split Files

- SKILL.md exceeds 100 lines
- Content has distinct domains (philosophy vs examples vs templates)
- Advanced features are rarely needed by the main workflow
- Scoring rubrics, evaluation criteria, or long output templates

## When to Add Scripts

- Operation is deterministic (validation, formatting, pattern matching)
- Same code would be generated repeatedly across invocations
- Errors need explicit exit codes for hook integration

Scripts save tokens and improve reliability vs generated code. Keep them short (<50 lines) and focused on one task.

## Review Checklist

- [ ] Description includes trigger phrases ("Use when...")
- [ ] Description is under 1024 characters
- [ ] SKILL.md is under 100 lines (or overflow is in REFERENCE.md)
- [ ] `visibility` field is set (public, internal, or private)
- [ ] `user-invocable: false` if skill has no direct user workflow
- [ ] `argument-hint` set if skill expects user input at invocation
- [ ] Reference file links use relative paths
- [ ] Directory name matches `name` field

## Lint Mode

When asked to "lint" a skill, check it against every rule above. Report:

```
PASS: [rule]
FAIL: [rule] — [what's wrong, line number if applicable, suggested fix]
```

Count passes and failures. If any rule is ambiguous for this skill, mark it WARN with reasoning.

Also check:
- If skill body starts with "Identify X from..." or "Parse X from...", `argument-hint` should be present
- If skill has no step/process sections (pure reference), `user-invocable` should be false
- If `origin` is set, the source repo/URL should be noted

Visibility-specific lint:
- `public`: fail on absolute paths with username, personal names, Slack/channel IDs, company-internal URLs
- `internal`: fail on absolute paths with username, personal names, Slack/channel IDs
- `private`: skip lint
