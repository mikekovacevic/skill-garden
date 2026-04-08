Read `${VAULT_ROOT}/projects/_index.md` and present the projects as a numbered list, grouped by phase (T1, T2, investigation). Ask the user to pick one.

Once selected, read the following files for that project (if they exist):
1. `${VAULT_ROOT}/projects/<name>/context.md` - project context and goals
2. The most recent session file in `${VAULT_ROOT}/projects/<name>/sessions/` (by filename date)

Then summarize:
- What the project is about (from context.md)
- What was done last session (from the latest session file, if any)
- Suggested next steps or open threads

Ask the user what they'd like to work on for this project today.
