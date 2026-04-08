---
name: publish
description: >
  Publish public skills from a source repo to a skill garden. Validates all skills,
  copies public ones, removes stale entries, and commits. Use when syncing a garden
  repo after updating skills locally. Trigger on "publish skills", "sync garden",
  "update garden", or "push to garden".
license: MIT
metadata:
  visibility: public
  origin: self
---

# Publish to Skill Garden

Validate and publish public skills from your source repo to the garden.

## Scripts

| Script | What it does |
|---|---|
| `scripts/publish.sh` | Full publish pipeline: validate, copy public skills, clean stale, commit |
| `scripts/validate.sh` | Lint validator for visibility-tier rules |

## Usage

### Publish all public skills

```bash
./publish/scripts/publish.sh /path/to/your/skills /path/to/your/garden
```

The script will:
1. Run lint validation on all source skills (fails if any public skill has personal info)
2. Copy every `visibility: public` skill to the garden (SKILL.md + commands/ + REFERENCE.md)
3. Remove garden skills that are no longer public in source
4. Validate the garden copy
5. Commit (you push manually)

### Validate only

```bash
# Validate garden (flat layout)
./publish/scripts/validate.sh /path/to/garden

# Validate source repo (nested layout)
./publish/scripts/validate.sh --source /path/to/skills
```

## Validation rules

| Visibility | Checks |
|---|---|
| `public` | No absolute paths with username, no personal names, no Slack IDs, no company-internal URLs |
| `internal` | No absolute paths with username, no Slack IDs |
| `private` | Skipped |

## Extending validation

Edit `scripts/validate.sh` to add patterns. The `check_file` function runs grep-based checks per visibility tier. Add new patterns there.
