---
name: obsidian-vault
description: >
  Obsidian vault layout, weekly note conventions, action item format, and git commit rules.
  Loaded automatically by skills that read or write to the vault.
  Use as background context when working with weekly notes or action items.
  For project conventions, see the projects skill.
license: MIT
user-invocable: false
metadata:
  visibility: public
  origin: self
---

# Obsidian Vault Layout

## Paths

- **Vault root**: `${VAULT_ROOT}`
- **Action items**: `${VAULT_ROOT}/action-items.md`
- **Weekly notes**: `${VAULT_ROOT}/weekly/YYYY-MM-DD.md`
- **Projects**: `${VAULT_ROOT}/projects/` (see the `projects` skill for full conventions)

## Weekly Note Convention

Weekly files are named by the Monday date of that week: `YYYY-MM-DD.md`

Template structure:

```
# Week of YYYY-MM-DD

## Open Action Items

```tasks
not done
```

---

## [Weekday] YYYY-MM-DD   <- most recent day first

### Focus

<!-- To be filled by morning briefing -->

### Agenda

<!-- To be filled by morning briefing -->

### Notes

<!-- -->

### Action Items

<!-- -->

---

(older days follow in reverse chronological order down to Monday)
```

Days appear in **reverse chronological order** (Friday at top, Monday at bottom). Only days that have already occurred are present in the file. Future days are NOT pre-created.

If the file doesn't exist, create it with only the current day's section (plus the Weekly Retrospective at the bottom).

### Section update rules

- **Focus**: Updated by morning briefing. Top 2-3 priorities for the day.
- **Agenda**: Updated by morning briefing. Meetings in chronological order.
- **Notes**: Updated by EOD wrap-up. Brief summary of key meeting decisions (2-4 bullets per meeting). Do not overwrite if notes already exist.
- **Action Items**: Updated by EOD wrap-up and manually throughout the day. Task outcomes using Tasks plugin syntax. Only add items that are your action items, not items owned by others.
- **Weekly Retrospective**: Written by weekly digest on Friday. Inserted at the top (after the `# Week of` heading) when it runs.
- Never modify sections for other days.
- NEVER overwrite existing content. Only replace HTML comment placeholders.

## Action Items Format (Obsidian Tasks Plugin)

action-items.md uses dynamic Tasks query blocks to auto-populate from the entire vault. Do NOT manually write to this file.

### Emoji key

- + YYYY-MM-DD — date created
- due YYYY-MM-DD — due date (only add when a clear deadline is known)
- done YYYY-MM-DD — date completed

## Git Commit Convention

After modifying vault files, commit with:

```bash
cd ${VAULT_ROOT}
git add -A
git commit -m "<task-name>: YYYY-MM-DD"
```

Replace `<task-name>` with the skill that ran (e.g., "Morning briefing", "EOD wrap-up", "Weekly digest").
