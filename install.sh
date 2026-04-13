#!/bin/bash
# Install skills from the garden via symlinks.
#
# Skills are symlinked (not copied) so that pulling updates in the garden
# repo automatically updates installed skills. No re-install needed.
#
# Usage:
#   ./install.sh --all                         # install all skills
#   ./install.sh morning-briefing follow-up    # install specific skills
#   ./install.sh --list                        # list available skills
#
# Options:
#   --skills-dir <path>     where to symlink skills (default: ~/claude/skills)
#   --commands-dir <path>   where to install commands (default: ~/claude/.claude/commands)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GARDEN_DIR="$SCRIPT_DIR"

SKILLS_INSTALL_DIR=""
COMMANDS_INSTALL_DIR=""

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
    *)
      args+=("$1")
      shift
      ;;
  esac
done
set -- "${args[@]}"

# Auto-detect directories
if [ -z "$SKILLS_INSTALL_DIR" ]; then
  SKILLS_INSTALL_DIR="$HOME/claude/skills"
fi

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
  echo "  --skills-dir <path>     Skills directory (default: ~/claude/skills)"
  echo "  --commands-dir <path>   Commands directory (default: ~/claude/.claude/commands)"
  echo ""
  echo "Skills are symlinked, not copied. Run 'git pull' in the garden to update."
  exit 1
fi

is_skill() {
  [ -f "$1/SKILL.md" ]
}

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

for skill_path in "${skills[@]}"; do
  name=$(basename "$skill_path")
  target="$SKILLS_INSTALL_DIR/$name"

  # Safety check: don't destroy non-symlink directories (could be private skills)
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "  SKIP: $name (existing directory at $target is not a symlink)"
    echo "        Remove it manually if you want to replace it with the garden version."
    continue
  fi

  # Remove existing symlink and create new one
  rm -f "$target"
  ln -sf "$skill_path" "$target"

  # Install bundled commands (symlink each command file)
  if [ -d "$skill_path/commands" ]; then
    for cmd in "$skill_path"/commands/*.md; do
      [ -f "$cmd" ] || continue
      cmd_name=$(basename "$cmd" .md)
      cmd_target="$COMMANDS_INSTALL_DIR/$cmd_name.md"
      # Same safety check for commands
      if [ -e "$cmd_target" ] && [ ! -L "$cmd_target" ]; then
        echo "  SKIP command: /$cmd_name (existing file is not a symlink)"
        continue
      fi
      rm -f "$cmd_target"
      ln -sf "$cmd" "$cmd_target"
      echo "  + command: /$cmd_name"
    done
  fi

  echo "Installed: $name -> $target (symlink)"
  installed=$((installed + 1))
done

# Set up .claude/skills auto-discovery symlink if not already present
CLAUDE_SKILLS_DIR="$(dirname "$SKILLS_INSTALL_DIR")/.claude/skills"
if [ ! -L "$CLAUDE_SKILLS_DIR" ]; then
  mkdir -p "$(dirname "$CLAUDE_SKILLS_DIR")"
  # Compute relative path from .claude/ to skills/
  ln -sf ../skills "$CLAUDE_SKILLS_DIR"
  echo ""
  echo "Created .claude/skills -> skills/ (auto-discovery symlink)"
fi

echo "---"
echo "$installed skill(s) installed via symlinks"
echo "  Skills:   $SKILLS_INSTALL_DIR"
echo "  Commands: $COMMANDS_INSTALL_DIR"
echo ""
echo "To update: cd $(basename "$GARDEN_DIR") && git pull"
echo "Restart Claude Code or start a new session to pick up changes."
