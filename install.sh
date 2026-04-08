#!/bin/bash
# Install skills from the garden into ~/.claude/commands/
# Usage:
#   ./install.sh morning-briefing follow-up    # install specific skills
#   ./install.sh --all                         # install all skills
#   ./install.sh --list                        # list available skills

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR"
INSTALL_DIR="$HOME/.claude/commands"

if [ $# -eq 0 ]; then
  echo "Usage: ./install.sh [--all | --list | skill-name ...]"
  exit 1
fi

is_skill() {
  [ -f "$1/SKILL.md" ]
}

if [ "$1" = "--list" ]; then
  echo "Available skills:"
  for dir in "$SKILLS_DIR"/*/; do
    is_skill "$dir" || continue
    name=$(basename "$dir")
    desc=$(sed -n '/^description:/,/^[a-z]/p' "$dir/SKILL.md" | head -2 | tail -1 | sed 's/^ *//')
    printf "  %-25s %s\n" "$name" "$desc"
  done
  exit 0
fi

mkdir -p "$INSTALL_DIR"

if [ "$1" = "--all" ]; then
  skills=()
  for dir in "$SKILLS_DIR"/*/; do
    is_skill "$dir" && skills+=("$dir")
  done
else
  skills=()
  for name in "$@"; do
    if [ -d "$SKILLS_DIR/$name" ]; then
      skills+=("$SKILLS_DIR/$name/")
    else
      echo "Skill not found: $name"
      exit 1
    fi
  done
fi

installed=0
for skill_path in "${skills[@]}"; do
  name=$(basename "$skill_path")
  # Copy skill directory
  rm -rf "$INSTALL_DIR/$name"
  cp -r "$skill_path" "$INSTALL_DIR/$name"

  # If skill has bundled commands, install them as top-level slash commands
  if [ -d "$INSTALL_DIR/$name/commands" ]; then
    for cmd in "$INSTALL_DIR/$name"/commands/*.md; do
      [ -f "$cmd" ] || continue
      cmd_name=$(basename "$cmd" .md)
      cp "$cmd" "$INSTALL_DIR/$cmd_name.md"
      echo "  + command: /$cmd_name"
    done
    rm -rf "$INSTALL_DIR/$name/commands"
  fi

  echo "Installed: $name"
  installed=$((installed + 1))
done

echo "---"
echo "$installed skill(s) installed to $INSTALL_DIR"
echo "Restart Claude Code or start a new session to pick them up."
