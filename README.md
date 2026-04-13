# Skill Garden

Why "garden"? Because it's not a polished product or a rigid framework. It's a collection of skills I actually use, grown from real workflows, shared so others can browse, borrow, and adapt. Some are well-tended, some are experimental, and there may be a few weeds. Dig around, take what's useful, leave what isn't.

Use at your own risk. No warranty, no SLA, no customer support. Just a person sharing what works for them. Built for [Claude Code](https://claude.ai/code).

## Install

Skills are **symlinked** from the garden repo, not copied. This means `git pull` in the garden automatically updates all installed skills.

### Recommended: clone and install

```bash
cd ~/claude
git clone https://github.com/mikekovacevic/skill-garden.git

# Install all skills (creates symlinks into ~/claude/skills/)
cd skill-garden
./install.sh --all
```

This creates:
- `~/claude/skills/<name>` -> `~/claude/skill-garden/<name>` (symlink per skill)
- `~/claude/.claude/commands/<name>.md` -> bundled slash commands (symlinked)
- `~/claude/.claude/skills` -> `~/claude/skills` (auto-discovery symlink for Claude Code)

### Updating

```bash
cd ~/claude/skill-garden
git pull
```

That's it. Symlinks mean installed skills update automatically.

### Install specific skills

```bash
./install.sh morning-briefing follow-up projects

# List available skills
./install.sh --list
```

### Full workspace setup (new users)

After installing, run the onboarding skill to set up your identity, vault, and scheduled tasks:

```bash
cd ~/claude
claude
# Then say: "Run the onboarding skill"
```

## Skills

### Daily workflows

| Skill | Description | Commands |
|---|---|---|
| [morning-briefing](morning-briefing/) | Daily briefing: calendar, email, Slack, weekly note update | |
| [eod-wrap-up](eod-wrap-up/) | End-of-day review across meeting notes, email, Slack, calendar | |
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

## Skill format

Each skill follows the [Agent Skills](https://agentskills.io) spec with extensions. See [write-a-skill](write-a-skill/) for the full convention.

```yaml
---
name: skill-name
description: >
  What it does. Use when [trigger phrases].
visibility: public
origin: self
---
```

Skills with bundled commands include a `commands/` subdirectory:

```
skill-name/              # in the garden repo
  SKILL.md
  commands/
    command-name.md
```

After install, the skill and its commands are separated:

```
~/claude/skills/skill-name/     # skill directory
  SKILL.md
.claude/commands/command-name.md  # slash command (extracted)
```

## Attribution

Skills are either original (`origin: self`) or installed from other sources. Check each skill's `origin` frontmatter field.

## License

MIT
