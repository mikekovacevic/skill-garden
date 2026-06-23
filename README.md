# Skill Garden

Why "garden"? Because it's not a polished product or a rigid framework. It's a collection of skills I actually use, grown from real workflows, shared so others can browse, borrow, and adapt. Some are well-tended, some are experimental, and there may be a few weeds. Dig around, take what's useful, leave what isn't.

Use at your own risk. No warranty, no SLA, no customer support. Just a person sharing what works for them. Built for [Claude Code](https://claude.ai/code).

## Install

Skill Garden is a [Claude Code plugin marketplace](https://docs.claude.com/en/docs/claude-code/plugins). Add the marketplace once, then install only the skills you want.

```
/plugin marketplace add mikekovacevic/skill-garden
/plugin install morning-briefing@skill-garden
/plugin install follow-up@skill-garden
```

Or open the interactive picker:

```
/plugin
```

### Updating

```
/plugin marketplace update skill-garden
```

### Uninstall a skill

```
/plugin uninstall <name>@skill-garden
```

### Full workspace setup (new users)

After installing, run the onboarding skill to set up your identity, vault, and scheduled tasks:

```
/plugin install onboarding@skill-garden
# Then in any Claude Code session: "Run the onboarding skill"
```

### Legacy install (symlink-based)

The original `install.sh` still works for users who prefer symlinks over the plugin system. Clone the repo and run `./install.sh --all` (or `--list`, or individual skill names) to symlink skills into `~/claude/skills/`. Re-run after `git pull`. The plugin marketplace is the recommended path.

## Skills

### Daily workflows

| Skill | Description | Commands |
|---|---|---|
| [morning-briefing](morning-briefing/) | Self-contained morning briefing: calendar, overnight email & Slack, light 1:1 prep | |
| [eod-wrap-up](eod-wrap-up/) | Self-contained end-of-day review across meetings, email, Slack, tomorrow's calendar | |
| [weekly-digest](weekly-digest/) | Weekly summary across meetings, project tracking, Slack, calendar | |

### Project management

| Skill | Description | Commands |
|---|---|---|
| [projects](projects/) | Project lifecycle: create, resume, save, list | `/project-list`, `/project-new`, `/project-resume`, `/project-save` |

### Productivity

| Skill | Description | Commands |
|---|---|---|
| [copy-to-clipboard](copy-to-clipboard/) | Copy content to clipboard, bypassing terminal line wrapping | `/copy` |
| [follow-up](follow-up/) | Quickly capture a follow-up item to revisit later | |
| [1on1-prep](1on1-prep/) | Prepare for a 1:1 by pulling context from vault and connected tools | |
| [youtube-transcript](youtube-transcript/) | Download, persist, and analyze YouTube video transcripts | `/youtube` |

### Communication

| Skill | Description | Commands |
|---|---|---|
| [communication](communication/) | Communication framework: BLUF, Just-In-Time Context, Zoom In | |
| [writing-audit](writing-audit/) | Audit writing as an informed-but-not-expert reader | |

### Conventions (background knowledge)

These skills are `user-invocable: false`. They're loaded automatically by other skills for context, not invoked directly.

| Skill | Description |
|---|---|
| [obsidian-vault](obsidian-vault/) | Vault layout, weekly note conventions, action items format, git commit rules |
| [write-a-skill](write-a-skill/) | Skill authoring convention: directory format, frontmatter, lint rules |

## Variables

Skills use variables instead of hardcoded paths. Define these in your `CLAUDE.md`:

| Variable | Purpose | Example |
|---|---|---|
| `${VAULT_ROOT}` | Path to your Obsidian vault | `/Users/you/vault` |
| `${WORKSPACE_ROOT}` | Path to your Claude workspace | `/Users/you/claude` |
| `${SLACK_DM_CHANNEL}` | Your Slack DM channel ID | `D01ABCDEF` |
| `${USER_NAME}` | Your first name (for calendar matching) | `Jane` |

## Repo layout

Each skill is its own plugin under a directory at the repo root:

```
skill-garden/
├── .claude-plugin/marketplace.json    # marketplace manifest
├── morning-briefing/
│   ├── .claude-plugin/plugin.json     # plugin manifest
│   └── skills/morning-briefing/SKILL.md
├── projects/
│   ├── .claude-plugin/plugin.json
│   ├── skills/projects/SKILL.md
│   └── commands/                       # bundled slash commands
│       ├── project-list.md
│       └── ...
└── ...
```

## Skill format

Each skill follows the [Agent Skills](https://agentskills.io) spec. See [write-a-skill](write-a-skill/) for the authoring convention.

```yaml
---
name: skill-name
description: >
  What it does. Use when [trigger phrases].
---
```

## Attribution

Skills are either original (`origin: self`) or installed from other sources. Check each skill's `origin` frontmatter field.

## License

MIT
