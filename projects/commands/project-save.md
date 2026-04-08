Read `skills/productivity/obsidian-vault/SKILL.md` and `config/user-context.md` before proceeding.

Write a session summary for this conversation and save it to the vault.

## Steps

1. **Determine the destination.** Look at what this session was about:
   - If it relates to a project in `${VAULT_ROOT}/projects/`, write to `${VAULT_ROOT}/projects/[name]/sessions/YYYY-MM-DD.md`
   - If the project doesn't have a `sessions/` directory yet, create one
   - If no project exists for this work, create one first (phase: investigation) with a `context.md`, add to `_index.md`, then write the session file
   - If unsure which project, ask before writing

2. **Write the summary.** Keep it concise and scannable. Structure:
   ```
   # Session: [short title] - YYYY-MM-DD
   _status: complete

   ## What was done
   - Bullet points of key actions taken

   ## Decisions made
   - Anything decided that affects future work

   ## Files changed
   - List any files created or modified (skip if none)

   ## Next steps
   - What's left to do, if anything
   ```

Keep the summary factual and brief. This is a record for future sessions, not a narrative.
