---
name: copy-to-clipboard
description: >
  Copy content to the system clipboard, bypassing terminal line wrapping.
license: MIT
argument-hint: "[prompt or 'last']"
metadata:
  visibility: public
  origin: self
  tags: productivity
---

# Copy to Clipboard

Terminal-rendered text gets hard-wrapped with newline characters. This skill bypasses that by piping content directly to the system clipboard.

## Process

1. Determine the content to copy (see modes below)
2. Strip markdown formatting (backticks, headers, bold, bullet markers) so it pastes as clean plain text
3. Detect the platform and copy to clipboard using a heredoc to avoid escaping issues:

Detect which clipboard tool is available: `command -v pbcopy || command -v wl-copy || command -v xclip || command -v xsel`

**macOS:**
```
pbcopy <<'CLIPBOARD'
<content here>
CLIPBOARD
```

**Linux (Wayland):**
```
wl-copy <<'CLIPBOARD'
<content here>
CLIPBOARD
```

**Linux (X11):**
```
xclip -selection clipboard <<'CLIPBOARD'
<content here>
CLIPBOARD
```

If no clipboard tool is found, tell the user to install one (`sudo apt install xclip` or `sudo apt install wl-clipboard`).

4. Confirm what was copied in a single short sentence. Do NOT display the full content in the terminal.

## Modes

**No arguments or "last"**: Copy the most recent assistant text output from this conversation.

**With a prompt**: Generate the requested content, then copy it. Do not display it in the terminal.
