# Claude Code Workspace Template

A productivity system built on Claude Code. Gives you:

- **Morning briefing** - runs at 8am, checks your calendar, overnight email/Slack, and sets your daily focus. Updates your Obsidian weekly note automatically.
- **EOD wrap-up** - runs at 5pm, recaps meetings, captures action items, flags anything unresolved.
- **Weekly digest** - runs Friday afternoon, writes a retrospective and preps you for next week.
- **Project context** - each active project has a `context.md` that stays current across sessions. Resume any project and Claude already knows where things stand.

All three tasks run locally via your OS scheduler (launchd on macOS, systemd/cron on Linux). No active session required. Output goes to your Obsidian vault and a Slack DM notification with a deep link.

---

## Prerequisites

- [Claude Code](https://claude.ai/code) installed (`claude` in your PATH)
- [Obsidian](https://obsidian.md) installed
- macOS or Linux (scheduled tasks use launchd on macOS, systemd or cron on Linux)
- Connected MCP tools (see Step 4):
  - **Granola** - meeting notes
  - **Outlook / Microsoft 365** - calendar and email
  - **Slack** - notifications and overnight activity

---

## Quick Start

### 1. Clone and open

```bash
git clone https://github.com/[YOUR_USERNAME]/claude-code-template ~/claude
cd ~/claude
claude
```

### 2. Run onboarding

Open Claude Code in the directory, then paste this prompt:

```
I just cloned the claude-code-template repo and I'm setting up my workspace for the first time. Please read onboarding/SKILL.md and run every step to set up my identity, vault, MCP connections, and scheduled tasks. Walk me through it interactively - ask for my details before filling anything in.
```

Claude will ask for your name, role, timezone, tools, and preferences, then create all the personal config files for you. Takes about 20 minutes.

### 3. Set up your MCP connections

Copy `.mcp.json.template` to `.mcp.json` and fill in your tokens:

```bash
cp .mcp.json.template .mcp.json
```

Edit `.mcp.json` and replace the placeholder values with your own tokens (GitHub PAT, etc.).

For Slack, Outlook, and Atlassian: connect via [claude.ai Settings > Connectors](https://claude.ai/settings/connectors). These use OAuth and don't need tokens in `.mcp.json`.

### 4. Set up scheduled tasks

The task scripts auto-detect your OS and claude binary location. Copy them into place:

```bash
mkdir -p .claude/scripts
cp onboarding/templates/run-*.sh .claude/scripts/
chmod +x .claude/scripts/*.sh
```

#### macOS (launchd)

```bash
mkdir -p ~/Library/LaunchAgents
```

Create a plist for each task in `~/Library/LaunchAgents/`. See `scheduled-tasks/SKILL.md` for the exact plist format.

Register:
```bash
launchctl load ~/Library/LaunchAgents/com.yourusername.claude.morning-briefing.plist
launchctl load ~/Library/LaunchAgents/com.yourusername.claude.eod-wrap-up.plist
launchctl load ~/Library/LaunchAgents/com.yourusername.claude.weekly-digest.plist
```

Test:
```bash
bash .claude/scripts/run-morning-briefing.sh
tail -f ~/Library/Logs/claude-tasks/morning-briefing.log
```

#### Linux (systemd)

Create systemd user service and timer files in `~/.config/systemd/user/`. See `scheduled-tasks/SKILL.md` for the format.

Enable:
```bash
systemctl --user daemon-reload
systemctl --user enable --now claude-morning-briefing.timer
```

Test:
```bash
bash .claude/scripts/run-morning-briefing.sh
tail -f ~/.local/share/claude-tasks/logs/morning-briefing.log
```

#### Linux (cron fallback)

If systemd is unavailable:
```bash
crontab -e
# Add:
# 8 8 * * 1-5 $HOME/claude/.claude/scripts/run-morning-briefing.sh
# 7 17 * * 1-5 $HOME/claude/.claude/scripts/run-eod-wrap-up.sh
# 31 16 * * 5 $HOME/claude/.claude/scripts/run-weekly-digest.sh
```

---

## How It Works

### Skills

Skills are markdown files in `skills/` that Claude reads before executing a task. They act as detailed instructions, the equivalent of an SOP. When a scheduled task fires, it runs `claude -p "Run the [skill]"` which loads the skill and executes every step.

You can call any skill interactively too: just describe what you want and Claude will find and run the right one.

### Project Context

Each project lives in `vault/projects/[name]/`:

```
vault/projects/
  _index.md              - active project list with status and last-updated date
  [project]/
    context.md           - current state snapshot (max ~200 lines, rewritten not appended)
    sessions/            - dated session logs
  archive/               - completed projects
```

To start working on a project:
> "I'm working on [project name]"

Claude loads the context, checks for updates since the last session, creates a session log, and picks up where you left off.

To save state at the end of a session:
> "We're done"

Claude runs `/project-save`, rewrites `context.md` with the current state, marks the session complete, and updates `_index.md`.

**Tiers:**
- **Tier 1** - active work with frequent Claude Code sessions (has `context.md` + `sessions/`)
- **Tier 2** - tracked context only, progressed mostly through meetings (has `context.md` only)

### Vault

Notes live in an Obsidian vault at `vault/`. The scheduled tasks write to weekly notes automatically. You open Obsidian to read the output. The Slack notification includes a deep link that opens the right file directly.

Weekly notes follow a Monday-dated naming convention (`YYYY-MM-DD.md`) and use reverse chronological order within the file.

### Scheduled Tasks

Each task is a shell script that runs `claude -p` (non-interactive) with:
- A prompt instructing Claude to read and run the relevant skill file
- A session name passed via `-n` so you can resume the session later
- An `--allowedTools` list pre-approving the MCP tools the task needs

The Slack notification at the end of each task includes:
- A deep link to open the weekly note in Obsidian
- The `claude --resume [session-name]` command to pick up the session interactively

---

## Customizing

### Change task times

**macOS:** Edit the plist files in `~/Library/LaunchAgents/` and reload with `launchctl unload` then `launchctl load`.

**Linux (systemd):** Edit the timer files in `~/.config/systemd/user/` and run `systemctl --user daemon-reload`.

**Linux (cron):** Edit with `crontab -e`.

### Add or modify skills

Skills are in `skills/`. Each skill is a directory with a `SKILL.md` file. Edit it and changes take effect on the next run. No restart needed.

### Add a new project

> "Start a context for [project name]"

Claude creates `context.md` and adds it to `_index.md`.

---

## File Reference

| Path | Purpose |
|------|---------|
| `CLAUDE.md` | Loaded in every session: your identity, workflow, and project routing |
| `config/user-context.md` | Your name, role, timezone, and connected tools |
| `obsidian-vault/SKILL.md` | Vault layout, note templates, git convention |
| `scheduled-tasks/SKILL.md` | Task schedule, file locations, management commands |
| `skills/` | All skill files |
| `onboarding/templates/` | Template versions of personal files for new setups |
| `.claude/scripts/` | Shell scripts for scheduled tasks |
| `.mcp.json` | MCP server config (gitignored, copy from `.mcp.json.template`) |
| `vault/` | Obsidian vault (separate git repo) |

## Placeholder Reference

| Placeholder | Where used | Replace with |
|---|---|---|
| `[YOUR_USERNAME]` | Markdown templates | Your OS username (e.g. `jane`) |
| `[YOUR_FULL_NAME]` | user-context.md | Your full name |
| `[YOUR_EMAIL]` | user-context.md | Your email address |
| `[YOUR_HOME_DIR]` | vault-claude.md | Your home directory path (e.g. `/Users/jane` or `/home/jane`) |
| `[YOUR_NAME]` | vault-claude.md | Your full name (for the heading) |
| `[YOUR_ROLE]` | user-context.md | Your job title |
| `[YOUR_COMPANY]` | user-context.md | Your company name |
