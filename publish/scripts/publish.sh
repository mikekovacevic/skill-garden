#!/bin/bash
# Publish public skills from a source repo to the garden
#
# Usage:
#   ./publish.sh /path/to/source/skills /path/to/garden
#   ./publish.sh ~/claude/skills ~/claude/skill-garden
#
# What it does:
#   1. Validates all source skills
#   2. Finds skills with visibility: public
#   3. Copies them to the garden (SKILL.md + commands/ + REFERENCE.md)
#   4. Removes garden skills that are no longer public in source
#   5. Commits and pushes the garden repo

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="${1:?Usage: publish.sh <source-skills-dir> <garden-dir>}"
GARDEN_DIR="${2:?Usage: publish.sh <source-skills-dir> <garden-dir>}"

red() { printf "\033[31m%s\033[0m\n" "$1"; }
green() { printf "\033[32m%s\033[0m\n" "$1"; }

# Step 1: Validate source skills
echo "=== Validating source skills ==="
if ! bash "$SCRIPT_DIR/validate.sh" --source "$SOURCE_DIR"; then
  red "Validation failed. Fix errors before publishing."
  exit 1
fi
echo ""

# Step 2: Find public skills and copy to garden
echo "=== Publishing public skills ==="
published=0
public_skills=()

for category in "$SOURCE_DIR"/*/; do
  [ -d "$category" ] || continue
  basename_cat=$(basename "$category")
  [ "$basename_cat" = "config" ] && continue
  [ "$basename_cat" = "lint" ] && continue

  for skill_dir in "$category"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_file="$skill_dir/SKILL.md"
    [ -f "$skill_file" ] || continue

    visibility=$(sed -n '/^---$/,/^---$/p' "$skill_file" | grep -E '^\s+visibility:' | awk '{print $2}')
    [ "$visibility" = "public" ] || continue

    skill_name=$(basename "$skill_dir")
    public_skills+=("$skill_name")
    dest="$GARDEN_DIR/$skill_name"

    # Clean destination and copy fresh
    rm -rf "$dest"
    mkdir -p "$dest"
    cp "$skill_file" "$dest/"

    # Copy optional files
    [ -f "$skill_dir/REFERENCE.md" ] && cp "$skill_dir/REFERENCE.md" "$dest/"
    if [ -d "$skill_dir/commands" ]; then
      cp -r "$skill_dir/commands" "$dest/"
    fi

    green "  Published: $skill_name"
    published=$((published + 1))
  done
done

# Step 3: Remove garden skills no longer in source
echo ""
echo "=== Cleaning stale skills ==="
for garden_skill in "$GARDEN_DIR"/*/; do
  [ -d "$garden_skill" ] || continue
  name=$(basename "$garden_skill")

  # Skip non-skill directories
  [ "$name" = "publish" ] && continue
  [ -f "$garden_skill/SKILL.md" ] || continue

  found=false
  for pub in "${public_skills[@]}"; do
    [ "$pub" = "$name" ] && found=true && break
  done

  if [ "$found" = false ]; then
    rm -rf "$garden_skill"
    yellow "  Removed: $name (no longer public)"
  fi
done

# Step 4: Validate garden
echo ""
echo "=== Validating garden ==="
bash "$SCRIPT_DIR/validate.sh" "$GARDEN_DIR"

# Step 5: Commit and push
echo ""
echo "=== Committing ==="
cd "$GARDEN_DIR"
git add -A

if git diff --cached --quiet; then
  echo "No changes to publish."
  exit 0
fi

git commit -m "Publish: update $published skill(s)"
echo ""
echo "Ready to push. Run:"
echo "  cd $GARDEN_DIR && git push"
