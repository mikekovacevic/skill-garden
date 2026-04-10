---
name: onboarding
description: >
  Bootstrap a new Claude Code workspace: identity, vault, scheduled tasks, and MCP connections.
license: MIT
metadata:
  visibility: public
  origin: self
  tags: tooling
---

# Onboarding

Walk the user through setting up their Claude Code workspace step by step. Confirm each step before proceeding to the next.

## Overview

This setup creates:
- A personal identity file Claude reads in every session
- An Obsidian vault for notes, projects, and weekly tracking
- Three scheduled tasks (morning briefing, EOD wrap-up, weekly digest)
- A project context system for continuity across sessions

Estimated time: 20-30 minutes.

---

## Step 1 — Identity file

Copy `onboarding/templates/user-context.md` to `config/user-context.md`.

Ask the user for:
- Full name
- Email address
- Role and company name
- Timezone (city + abbreviation, e.g. Toronto / ET)
- Which tools they use: calendar, email, chat, meeting notes, project tracking, ATS

Fill in the placeholders and write the file. Show them the result.

---

## Step 2 — Vault identity file

Copy `onboarding/templates/vault-claude.md` to `vault/CLAUDE.md`.

Ask the user for:
- Their home directory username (e.g. `/Users/jane`)
- Their name (for the `# Heading`)
- Role, company, and direct reports (brief org description)
- Manager name and title
- List of connected MCP tools
- Any personal preferences (communication style, formatting, etc.)

Fill in the placeholders and write the file.

---

## Step 3 — Workspace CLAUDE.md

Copy `onboarding/templates/workspace-claude.md` to `config/workspace-claude.md`.

Replace all `[YOUR USERNAME]` placeholders with the user's actual username from Step 2.

Then create the symlink so CLAUDE.md in the root points to it:
```bash
ln -sf config/workspace-claude.md CLAUDE.md
```

---

## Step 4 — Obsidian vault structure

Create the vault directory structure:

```bash
mkdir -p vault/weekly
mkdir -p vault/meetings/1-1s
mkdir -p vault/projects/archive
mkdir -p vault/templates/templater
```

Create `vault/projects/_index.md` with:
```markdown
# Active Projects
```

Create `vault/follow-ups.md` with:
```markdown
# Follow-ups

## Open

## Closed
```

Ask the user if they have an existing Obsidian vault they want to connect, or if they're starting fresh. If existing, ask for the vault path and update obsidian-vault.md accordingly.

---

## Step 5 — MCP connections

Read `config/user-context.md` to understand which tools the user has.

For each tool, explain what MCP server is needed and how to connect it:

- **Granola** — add to `.mcp.json` as `{"type": "http", "url": "https://mcp.granola.ai/mcp"}`
- **Slack** — connect via claude.ai Settings → Connectors (handles OAuth automatically)
- **Outlook/Microsoft 365** — connect via claude.ai Settings → Connectors
- **Atlassian (Jira/Confluence)** — connect via claude.ai Settings → Connectors
- **GitHub** — add to `.mcp.json` using the GitHub MCP server with a personal access token

Show the user what's already configured in `.mcp.json` and `scheduled-tasks/SKILL.md`.

---

## Step 6 — Scheduled tasks

Read `scheduled-tasks/SKILL.md`.

Confirm with the user:
- Do they want all three tasks (morning briefing, EOD wrap-up, weekly digest)?
- Are the default times right (8:08am, 5:07pm, 4:31pm Fridays)?
- What is their Slack DM channel ID for notifications? (They can find it by opening their Slack DM with themselves and checking the URL — the channel ID starts with `D`)

For each task, check if the script exists in `.claude/scripts/`. If not, explain they need to create the scripts and plist files — refer to `scheduled-tasks/SKILL.md` for the exact format.

Remind them to register the launchd agents:
```bash
launchctl load ~/Library/LaunchAgents/com.username.claude.morning-briefing.plist
launchctl load ~/Library/LaunchAgents/com.username.claude.eod-wrap-up.plist
launchctl load ~/Library/LaunchAgents/com.username.claude.weekly-digest.plist
```
(Replace `com.username` with their own identifier.)

---

## Step 7 — First project

Ask: "Do you have any active projects you're tracking? If so, tell me the name and a brief description of where things stand and I'll create the first context file."

For each project they name:
- Create `vault/projects/[name]/context.md` with the information they provide
- Add it to `vault/projects/_index.md`
- Ask: Tier 1 (active Claude Code sessions) or Tier 2 (tracked context only)?

---

## Step 8 — Verify

Run a quick sanity check:
- Confirm `config/user-context.md` exists and has no unfilled placeholders
- Confirm `vault/CLAUDE.md` exists and has no unfilled placeholders
- Confirm `vault/projects/_index.md` exists
- List what MCP servers are configured

Show the user a summary of what's set up and what's still pending (manual steps like Slack channel ID, launchd registration, etc.).

---

## Done

Tell the user:
- They can run a manual test of the morning briefing with: `bash .claude/scripts/run-morning-briefing.sh`
- They can check logs at: `~/Library/Logs/claude-tasks/`
- To start working on a project, just say "I'm working on [project name]"
- To update project context at the end of a session, say "we're done"
