#!/bin/bash
# Install skills from the garden.
#
# Skills (SKILL.md directories) go to the skills directory.
# Bundled slash commands go to the commands directory.
#
# Usage:
#   ./install.sh morning-briefing follow-up    # install specific skills
#   ./install.sh --all                         # install all skills
#   ./install.sh --list                        # list available skills
#
# Options:
#   --skills-dir <path>     where to install skills (default: ~/claude/skills if exists, else ~/.claude/commands)
#   --commands-dir <path>   where to install commands (default: .claude/commands if found, else ~/.claude/commands)
#   --profile <name>        add installed skills to a profile's skills.conf

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GARDEN_DIR="$SCRIPT_DIR"

# Defaults: --skills-dir flag > ~/claude/skills (if exists) > ~/.claude/commands
SKILLS_INSTALL_DIR=""
COMMANDS_INSTALL_DIR=""
PROFILE=""

# Parse options
args=()
while [ $# -gt 0 ]; do
  case "$1" in
    --skills-dir)
      SKILLS_INSTALL_DIR="$2"
      shift 2
      ;;
    --commands-dir)
      COMMANDS_INSTALL_DIR="$2"
      shift 2
      ;;
    --profile)
      PROFILE="$2"
      shift 2
      ;;
    *)
      args+=("$1")
      shift
      ;;
  esac
done
set -- "${args[@]}"

# Auto-detect skills dir: flag > ~/claude/skills (if exists) > ~/.claude/commands
if [ -z "$SKILLS_INSTALL_DIR" ]; then
  if [ -d "$HOME/claude/skills" ]; then
    SKILLS_INSTALL_DIR="$HOME/claude/skills"
  else
    SKILLS_INSTALL_DIR="$HOME/.claude/commands"
  fi
fi

# Auto-detect commands dir: flag > project .claude/commands (if exists) > ~/.claude/commands
if [ -z "$COMMANDS_INSTALL_DIR" ]; then
  if [ -d "$HOME/claude/.claude/commands" ]; then
    COMMANDS_INSTALL_DIR="$HOME/claude/.claude/commands"
  else
    COMMANDS_INSTALL_DIR="$HOME/.claude/commands"
  fi
fi

if [ $# -eq 0 ]; then
  echo "Usage: ./install.sh [options] [--all | --list | skill-name ...]"
  echo ""
  echo "Options:"
  echo "  --skills-dir <path>     Skills install directory (default: ~/claude/skills if exists, else ~/.claude/commands)"
  echo "  --commands-dir <path>   Commands install directory (default: .claude/commands if found, else ~/.claude/commands)"
  echo "  --profile <name>        Add to profile's skills.conf (e.g. personal, work)"
  exit 1
fi

is_skill() {
  [ -f "$1/SKILL.md" ]
}

# Extract short description from SKILL.md frontmatter
get_description() {
  local skill_file="$1/SKILL.md"
  sed -n '/^description:/,/^[a-z]/p' "$skill_file" | head -2 | tail -1 | sed 's/^ *//'
}

if [ "$1" = "--list" ]; then
  echo "Available skills:"
  for dir in "$GARDEN_DIR"/*/; do
    is_skill "$dir" || continue
    name=$(basename "$dir")
    desc=$(get_description "$dir")
    printf "  %-25s %s\n" "$name" "$desc"
  done
  exit 0
fi

mkdir -p "$SKILLS_INSTALL_DIR"
mkdir -p "$COMMANDS_INSTALL_DIR"

# Build skill list
if [ "$1" = "--all" ]; then
  skills=()
  for dir in "$GARDEN_DIR"/*/; do
    is_skill "$dir" && skills+=("$dir")
  done
else
  skills=()
  for name in "$@"; do
    if [ -d "$GARDEN_DIR/$name" ] && is_skill "$GARDEN_DIR/$name"; then
      skills+=("$GARDEN_DIR/$name/")
    else
      echo "Skill not found: $name"
      exit 1
    fi
  done
fi

installed=0
installed_names=()

for skill_path in "${skills[@]}"; do
  name=$(basename "$skill_path")

  # Install skill directory to skills dir
  rm -rf "$SKILLS_INSTALL_DIR/$name"
  cp -r "$skill_path" "$SKILLS_INSTALL_DIR/$name"

  # Extract bundled commands to commands dir (and remove from skill copy)
  if [ -d "$SKILLS_INSTALL_DIR/$name/commands" ]; then
    for cmd in "$SKILLS_INSTALL_DIR/$name"/commands/*.md; do
      [ -f "$cmd" ] || continue
      cmd_name=$(basename "$cmd" .md)
      cp "$cmd" "$COMMANDS_INSTALL_DIR/$cmd_name.md"
      echo "  + command: /$cmd_name -> $COMMANDS_INSTALL_DIR/$cmd_name.md"
    done
    rm -rf "$SKILLS_INSTALL_DIR/$name/commands"
  fi

  echo "Installed: $name -> $SKILLS_INSTALL_DIR/$name/"
  installed=$((installed + 1))
  installed_names+=("$name")
done

# Optionally add to profile's skills.conf
if [ -n "$PROFILE" ]; then
  SKILLS_CONF="$HOME/claude/machines/$PROFILE/skills.conf"
  if [ -f "$SKILLS_CONF" ]; then
    added=0
    for name in "${installed_names[@]}"; do
      if ! grep -q "^active  $name$" "$SKILLS_CONF" && ! grep -q "^always  $name$" "$SKILLS_CONF"; then
        echo "active  $name" >> "$SKILLS_CONF"
        echo "  + added to $PROFILE skills.conf: $name"
        added=$((added + 1))
      fi
    done
    if [ "$added" -gt 0 ]; then
      echo ""
      echo "Run 'bash ~/claude/scripts/update-skills.sh $PROFILE' to regenerate CLAUDE.md skill list."
    fi
  else
    echo "Warning: skills.conf not found for profile '$PROFILE' at $SKILLS_CONF"
  fi
fi

echo "---"
echo "$installed skill(s) installed"
echo "  Skills:   $SKILLS_INSTALL_DIR"
echo "  Commands: $COMMANDS_INSTALL_DIR"
echo ""
echo "Restart Claude Code or start a new session to pick them up."
