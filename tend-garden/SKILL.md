---
name: tend-garden
description: >
  Tend your skill garden: validate skills against visibility rules, publish public skills
  from a source repo, and clean stale entries. Use when syncing the garden after updating
  skills locally. Trigger on "tend the garden", "publish skills", "sync garden", or
  "validate skills".
license: MIT
metadata:
  visibility: public
  origin: self
---

# Tend the Garden

Validate and publish public skills from your source repo to the garden.

## Scripts

| Script | What it does |
|---|---|
| `scripts/publish.sh` | Full pipeline: validate, copy public skills, clean stale, commit |
| `scripts/validate.sh` | Lint validator for visibility-tier rules |

## Usage

### Publish all public skills

```bash
./tend/scripts/publish.sh /path/to/your/skills /path/to/your/garden
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
./tend/scripts/validate.sh /path/to/garden

# Validate source repo (nested layout)
./tend/scripts/validate.sh --source /path/to/skills
```

## Validation rules

| Visibility | Checks |
|---|---|
| `public` | No absolute paths with username, no personal names, no Slack IDs, no company-internal URLs |
| `internal` | No absolute paths with username, no Slack IDs |
| `private` | Skipped |

## Extending validation

Edit `scripts/validate.sh` to add patterns. The `check_file` function runs grep-based checks per visibility tier.
