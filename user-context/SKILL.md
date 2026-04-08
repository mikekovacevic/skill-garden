---
name: user-context
description: >
  User identity and tool configuration that skills read for personalization.
  Defines the expected fields in user-context/SKILL.md: name, role, timezone,
  connected tools, and signal rules. Loaded automatically by scheduled skills
  and any skill that needs to know who the user is.
license: MIT
user-invocable: false
metadata:
  visibility: public
  origin: self
  tags: convention
---

# User Context

The user context file stores identity and tool configuration that other skills reference. Located at `user-context/SKILL.md`.

## Expected fields

### Identity

| Field | Purpose | Example |
|---|---|---|
| Name | Used in outputs and references | Jane Smith |
| Email | For tool lookups | jane@company.com |
| Role | Tailors skill behavior to seniority/domain | Engineering Manager at Acme |
| Timezone | All times converted from UTC | Toronto / Eastern Time (ET) |

### Connected tools

| Tool type | Options | Used by |
|---|---|---|
| Calendar | Outlook, Google Calendar | morning-briefing, eod-wrap-up, weekly-digest, 1on1-prep |
| Email | Outlook, Gmail | morning-briefing, eod-wrap-up |
| Chat | Slack, Teams | morning-briefing, eod-wrap-up, weekly-digest |
| Meeting notes | Granola, Otter, manual | morning-briefing, eod-wrap-up, 1on1-prep |
| Project tracking | Jira, Linear, GitHub Issues | weekly-digest |
| Notes | Obsidian | all vault-based skills |
| ATS | Lever, Greenhouse, Ashby, none | hiring-feedback |

### Signal rules

Customize how skills filter noise from connected tools:
- Which automated messages to skip (bot alerts, CI pings, etc.)
- What counts as time-sensitive
- Default communication channel for drafts

## Setup

Run `/user-context` to create or update the config file interactively.
