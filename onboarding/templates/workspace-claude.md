# My Workspace

This is the root working directory for all Claude sessions.

**Root path (on disk)**: `/Users/[YOUR_USERNAME]/claude`

## Directory Layout

```
/Users/[YOUR_USERNAME]/claude/
  CLAUDE.md              - symlink to config/workspace-claude.md
  skills/                - Claude skills and reference docs
  vault/                 - Obsidian vault: notes, meetings, weekly logs
  .claude/commands/      - Claude Code slash commands
  .mcp.json              - MCP server config
  claude_desktop_config.json          - Claude Desktop config (gitignored, has secrets)
  claude_desktop_config.template.json - config template with placeholders
  mcp-servers/           - compiled MCP servers (optional)
```

## Output Routing

- Investigation outputs, data analyses, one-off research → `investigations/`
- Cowork session outputs, deliverables, tracked work → `projects/`
- Presentation files → `presentations/`
- Reusable skills and reference docs → `skills/`
- Notes, meeting recaps, action items → `vault/` only (follow vault skill first)
- Do not drop files in the root unless there is no better home

When working inside a repo subdirectory, save outputs within that repo. Ask before committing anything to git.

## Obsidian Vault

Vault root: `/Users/[YOUR_USERNAME]/claude/vault`

Always read these reference files before working with the vault:
- `obsidian-vault/SKILL.md` - layout, templates, git commit convention
- `config/user-context.md` - context about who you are and how you work

## Skills

All user skills live in `skills/` and are git controlled. Each skill is a directory containing `SKILL.md` (required) and optional `REFERENCE.md`. Directory names are `kebab-case` within subdirectories (e.g. `productivity/`, `data/`, `infrastructure/`).

**Always active** (load without being asked):
- `communication/SKILL.md` - communication framework; applies to all drafting, messaging, and verbal prep

For all other skills, read the relevant skill file before executing. Run `ls skills/*/` to see what's available.

## Claude Desktop Config

The Claude Desktop config file is symlinked into this workspace from its platform location:

| Platform | Source path |
|---|---|
| macOS | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| Linux | `~/.config/Claude/claude_desktop_config.json` |

Editing `claude_desktop_config.json` in this directory is sufficient - no need to touch the source path directly. Changes take effect after a full Claude Desktop restart.

## Scheduled Tasks

When running as a scheduled task, read the skill file from `skills/`. The skill file will tell you which reference files to read first.

For the full list of active tasks, schedules, file locations, and management commands, see `scheduled-tasks/SKILL.md`.
