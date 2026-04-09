---
name: copy-to-clipboard
description: >
  Copy content directly to the system clipboard, bypassing terminal line wrapping.
  Use when the user says "copy this", "put that on my clipboard", "copy to clipboard",
  "copy last response", or invokes /copy. Handles two modes: copying the last assistant
  response from the current session, or generating new content and copying it directly.
license: MIT
argument-hint: "[prompt or 'last']"
metadata:
  visibility: public
  origin: self
  tags: productivity
---

# Copy to Clipboard

Terminal-rendered text gets hard-wrapped with newline characters. This skill bypasses that by piping content directly to the system clipboard via `pbcopy` (macOS).

## Process

1. Determine the content to copy (see modes below)
2. Strip markdown formatting (backticks, headers, bold, bullet markers) so it pastes as clean plain text
3. Copy to clipboard using a heredoc to avoid escaping issues:

```
pbcopy <<'CLIPBOARD'
<content here>
CLIPBOARD
```

4. Confirm what was copied in a single short sentence. Do NOT display the full content in the terminal.

## Modes

**No arguments or "last"**: Copy the most recent assistant text output from this conversation.

**With a prompt**: Generate the requested content, then copy it. Do not display it in the terminal.

## Platform

- macOS: `pbcopy`
- Linux: `xclip -selection clipboard` (fallback)
