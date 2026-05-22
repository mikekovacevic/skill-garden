---
name: tend-garden
description: >
  Validate and commit changes to the skill garden repo. Use when you've edited
  a public skill, want to promote a private skill to public, or need to push
  skill changes to the garden. Trigger on "tend the garden", "publish skills",
  "sync garden", "push to garden", or "validate skills".
license: MIT
metadata:
  visibility: public
  origin: self
  tags: tooling
---

# Tend the Garden

Validate skills in the garden repo, check for sensitive content, and commit.

- **Garden**: `${WORKSPACE_ROOT}/skill-garden` (the published repo)

Public skills in `${WORKSPACE_ROOT}/skills/` are symlinked from the garden. Editing them edits the garden directly. This skill validates and commits those changes.

## Step 1: Check for new skills to promote

Check `${WORKSPACE_ROOT}/skills/` for any skill directories that are NOT symlinks (these are local/private skills). For each one, check its `visibility` frontmatter.

If any non-symlinked skill has `visibility: public`, it's a candidate for promotion:
1. Show the user which skills qualify
2. Ask which ones to promote
3. For each confirmed skill, move it into `${WORKSPACE_ROOT}/skill-garden/`, then replace the original with a symlink: `ln -sf ../skill-garden/<name> ${WORKSPACE_ROOT}/skills/<name>`
4. If the skill has bundled commands, symlink those too

If no skills need promoting, skip to Step 2.

## Step 2: Validate

Run the validation script against the garden repo.

```python
import re, sys
from pathlib import Path

class Colors:
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    RESET = "\033[0m"

def red(msg): print(f"{Colors.RED}{msg}{Colors.RESET}")
def green(msg): print(f"{Colors.GREEN}{msg}{Colors.RESET}")
def yellow(msg): print(f"{Colors.YELLOW}{msg}{Colors.RESET}")

EXAMPLE_PATHS = re.compile(r"/Users/(jane|you|YOUR|<username>)")
REAL_USER_PATH = re.compile(r"/Users/[a-z]")
PERSONAL_NAME = re.compile(r"\bMike\b")
SLACK_ID = re.compile(r"\b[DUC][0-9][A-Z0-9]{7,9}\b")
# Customize this pattern for your company's internal URLs
COMPANY_URL = re.compile(r"textnow\.atlassian|tn-data-catalog|enflick", re.IGNORECASE)

RULES = {
    "public": ["user_path", "personal_name", "slack_id", "company_url"],
    "internal": ["user_path", "slack_id"],
    "private": [],
}

def check_file(path, visibility):
    errors = []
    lines = path.read_text().splitlines()
    checks = RULES.get(visibility, [])
    for i, line in enumerate(lines, 1):
        if "user_path" in checks and REAL_USER_PATH.search(line) and not EXAMPLE_PATHS.search(line):
            errors.append((i, "absolute path with username", line.strip()))
        if "personal_name" in checks and PERSONAL_NAME.search(line):
            errors.append((i, "personal name reference", line.strip()))
        if "slack_id" in checks and SLACK_ID.search(line):
            errors.append((i, "raw Slack ID", line.strip()))
        if "company_url" in checks and COMPANY_URL.search(line):
            errors.append((i, "company-internal URL", line.strip()))
    return errors

def extract_visibility(text):
    match = re.search(r"^\s+visibility:\s*(\w+)", text, re.MULTILINE)
    return match.group(1) if match else None

def validate(skills_dir):
    skills_dir = Path(skills_dir)
    total_errors = 0
    checked = 0
    print(f"Validating skills in: {skills_dir}")
    print("---")
    for skill_dir in sorted(skills_dir.iterdir()):
        if not skill_dir.is_dir():
            continue
        skill_file = skill_dir / "SKILL.md"
        if not skill_file.exists():
            continue
        checked += 1
        name = skill_dir.name
        visibility = extract_visibility(skill_file.read_text())
        if not visibility:
            yellow(f"[{name}] WARN: no visibility field set")
            continue
        files_to_check = [skill_file]
        ref = skill_dir / "REFERENCE.md"
        if ref.exists():
            files_to_check.append(ref)
        commands_dir = skill_dir / "commands"
        if commands_dir.exists():
            files_to_check.extend(commands_dir.glob("*.md"))
        templates_dir = skill_dir / "templates"
        if templates_dir.exists():
            files_to_check.extend(templates_dir.glob("*"))
        errors = []
        for f in files_to_check:
            if f.is_file():
                errors.extend(check_file(f, visibility))
        if errors:
            red(f"[{name}] ({visibility}) FAIL")
            for line_num, rule, text in errors[:3]:
                red(f"  L{line_num}: {rule}")
            total_errors += len(errors)
        else:
            green(f"[{name}] ({visibility}) PASS")
    print("---")
    print(f"Checked: {checked} skills")
    if total_errors == 0:
        green("All skills passed validation.")
    else:
        red(f"{total_errors} error(s) found.")
    return total_errors == 0

if __name__ == "__main__":
    skills_dir = sys.argv[1] if len(sys.argv) > 1 else "."
    sys.exit(0 if validate(skills_dir) else 1)
```

If validation fails, stop and fix the issues. Do not proceed to Step 3.

## Step 3: Full repo sweep

Before committing, scan **every file staged for commit** in the garden repo for sensitive content.

Use `git diff --cached --name-only` to get the list of files to scan. Read and check every one, regardless of file type.

Scan for:

| Pattern | What to catch |
|---|---|
| Absolute user paths | `/Users/<real-username>`, `/home/<real-username>` (skip placeholders like `/Users/you`) |
| Personal names | Real first/last names of the repo owner or contributors |
| Slack IDs | Real channel, user, or DM IDs (e.g. `D0*`, `U0*`, `C0*` patterns) |
| Company names/URLs | Employer name, internal domains, Atlassian instances, org-specific URLs |
| Email addresses | Real emails (skip obvious placeholders like `jane@company.com`) |
| API keys/tokens | Any `key=`, `token=`, `secret=`, `password=` patterns with real values |
| Internal hostnames | `*.internal`, `*.corp`, internal service names |
| Internal tool references | References to company-specific tools, databases, or infrastructure |

Skip lines that are **defining** validation regex patterns (the tend-garden skill itself). Use judgment on placeholder values in documentation.

If real sensitive content is found, stop and fix before proceeding. Report all findings and let the user confirm before committing.

## Step 4: Commit

```bash
cd ${WORKSPACE_ROOT}/skill-garden
git add -A
git diff --cached --stat
```

Show the diff summary and ask before committing. Do not push automatically.
