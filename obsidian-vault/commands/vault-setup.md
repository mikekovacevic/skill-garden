Set up the Obsidian vault directory structure. Read `skills/productivity/obsidian-vault/SKILL.md` for the full convention first.

Check if `${VAULT_ROOT}` exists. If not, ask the user where they want the vault (default: `vault/` in the workspace root).

Create the directory structure:

```bash
mkdir -p ${VAULT_ROOT}/weekly
mkdir -p ${VAULT_ROOT}/meetings/1-1s
mkdir -p ${VAULT_ROOT}/projects/archive
mkdir -p ${VAULT_ROOT}/templates/templater
```

Create `${VAULT_ROOT}/projects/_index.md` if it doesn't exist:
```markdown
# Active Projects

| name | phase | updated | status |
|---|---|---|---|
```

Create `${VAULT_ROOT}/follow-ups.md` if it doesn't exist:
```markdown
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
```

Initialize git if not already a repo:
```bash
cd ${VAULT_ROOT}
git init
git add -A
git commit -m "Initial vault setup"
```

Show the user what was created and confirm the vault is ready.
