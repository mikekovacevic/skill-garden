You're creating a new project in the vault. The user will dump raw context (notes, Slack threads, meeting takeaways, stream of consciousness, whatever). Let them go first. Do not ask structured questions upfront.

Once the user has shared their context, synthesize it and propose:

1. **Project name** (kebab-case, 2-3 words)
2. **One-line description**
3. **Current state** (extracted from their context)
4. **Key decisions** (if any are implied)
5. **Open items / next steps**
6. **Phase** (investigation, T1, or T2, with your reasoning):
   - `investigation` - early-stage dig, may go nowhere or may graduate later
   - `T2` - tracked context, progressed mostly through meetings
   - `T1` - active recurring work with multiple Claude Code sessions

Present this as a proposal and ask the user to confirm or adjust. Then once confirmed:

1. Create `${VAULT_ROOT}/projects/<name>/context.md` using the format from the `projects` skill.

2. Add the project to `${VAULT_ROOT}/projects/_index.md` as a new table row in the appropriate phase position, following the existing format:
   `| <name> | <phase> | YYYY-MM-DD | <one-line description> |`

3. If the phase is T1, create the `${VAULT_ROOT}/projects/<name>/sessions/` directory.

4. Confirm what was created and suggest `/project-resume` to start working on it.
