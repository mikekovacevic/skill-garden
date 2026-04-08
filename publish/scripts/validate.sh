#!/bin/bash
# Validate skills against visibility-tier rules
# Works with both flat structure (garden) and nested structure (source repo)
#
# Usage:
#   ./validate.sh                          # validate current directory
#   ./validate.sh /path/to/skills          # validate specific directory
#   ./validate.sh --source /path/to/skills # validate nested source repo structure

set -euo pipefail

SOURCE_MODE=false
if [ "${1:-}" = "--source" ]; then
  SOURCE_MODE=true
  shift
fi

SKILLS_DIR="${1:-.}"
ERRORS=0
CHECKED=0

red() { printf "\033[31m%s\033[0m\n" "$1"; }
green() { printf "\033[32m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }

check_file() {
  local file="$1"
  local visibility="$2"
  local file_errors=0

  [ "$visibility" = "private" ] && return 0

  # Absolute paths with real username (skip examples)
  if grep -E '/Users/[a-z]' "$file" | grep -vE '/Users/(jane|you|YOUR|<username>)' | grep -qE '/Users/[a-z]'; then
    red "  FAIL: absolute path with username"
    grep -nE '/Users/[a-z]' "$file" | grep -vE '/Users/(jane|you|YOUR|<username>)' | head -3
    file_errors=$((file_errors + 1))
  fi

  # Public only: personal names
  if [ "$visibility" = "public" ]; then
    if grep -qwE '\bMike\b' "$file"; then
      red "  FAIL: personal name reference"
      grep -nwE '\bMike\b' "$file" | head -3
      file_errors=$((file_errors + 1))
    fi
  fi

  # Raw Slack channel/user IDs
  if grep -qE '\b[DUC][0-9][A-Z0-9]{7,9}\b' "$file"; then
    red "  FAIL: raw Slack ID detected"
    grep -nE '\b[DUC][0-9][A-Z0-9]{7,9}\b' "$file" | head -3
    file_errors=$((file_errors + 1))
  fi

  # Public only: company-internal URLs
  if [ "$visibility" = "public" ]; then
    if grep -qiE 'textnow\.atlassian|tn-data-catalog|enflick' "$file"; then
      red "  FAIL: company-internal URL in public skill"
      grep -niE 'textnow\.atlassian|tn-data-catalog|enflick' "$file" | head -3
      file_errors=$((file_errors + 1))
    fi
  fi

  ERRORS=$((ERRORS + file_errors))
  return $file_errors
}

validate_skill() {
  local skill_dir="$1"
  local skill_file="$skill_dir/SKILL.md"
  [ -f "$skill_file" ] || return 0

  CHECKED=$((CHECKED + 1))
  local skill_name
  skill_name=$(basename "$skill_dir")

  local visibility
  visibility=$(sed -n '/^---$/,/^---$/p' "$skill_file" | grep -E '^\s+visibility:' | awk '{print $2}')

  if [ -z "$visibility" ]; then
    yellow "[$skill_name] WARN: no visibility field set"
    return 0
  fi

  local before=$ERRORS
  check_file "$skill_file" "$visibility"

  # Check REFERENCE.md and commands/ too
  [ -f "$skill_dir/REFERENCE.md" ] && check_file "$skill_dir/REFERENCE.md" "$visibility"
  if [ -d "$skill_dir/commands" ]; then
    for cmd in "$skill_dir"/commands/*.md; do
      [ -f "$cmd" ] && check_file "$cmd" "$visibility"
    done
  fi

  if [ $ERRORS -eq $before ]; then
    green "[$skill_name] ($visibility) PASS"
  else
    red "[$skill_name] ($visibility) FAIL"
  fi
}

echo "Validating skills in: $SKILLS_DIR"
echo "---"

if [ "$SOURCE_MODE" = true ]; then
  # Nested: skills/category/skill-name/SKILL.md
  for category in "$SKILLS_DIR"/*/; do
    [ -d "$category" ] || continue
    basename_dir=$(basename "$category")
    [ "$basename_dir" = "config" ] && continue
    [ "$basename_dir" = "lint" ] && continue
    for skill_dir in "$category"/*/; do
      [ -d "$skill_dir" ] || continue
      validate_skill "$skill_dir"
    done
  done
else
  # Flat: skill-name/SKILL.md (garden layout)
  for skill_dir in "$SKILLS_DIR"/*/; do
    [ -d "$skill_dir" ] || continue
    validate_skill "$skill_dir"
  done
fi

echo "---"
echo "Checked: $CHECKED skills"
if [ $ERRORS -eq 0 ]; then
  green "All skills passed validation."
  exit 0
else
  red "$ERRORS error(s) found."
  exit 1
fi
