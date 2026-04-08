---
name: youtube-transcript
description: >
  Download a YouTube video transcript, persist it, and analyze it. Transcripts are saved
  to TRANSCRIPT_DIR/{video-id}.md so they can be referenced in future sessions. If a transcript
  already exists for a video ID, it is loaded from disk instead of re-downloaded.
  Default output is a summary plus actionable recommendations relevant to the user's context.
  Trigger: user pastes a YouTube URL, says "run this skill", "analyze this video",
  "summarize this", or asks a follow-up about a previously saved video.
license: MIT
argument-hint: "[youtube URL]"
metadata:
  visibility: public
  origin: self
---

# YouTube Transcript Skill

```!
dep_cache="$HOME/.cache/skill-deps/youtube-transcript"
if [ ! -f "$dep_cache" ]; then
  missing=""
  command -v yt-dlp >/dev/null 2>&1 || missing="$missing yt-dlp"
  python -c "import youtube_transcript_api" 2>/dev/null || missing="$missing youtube-transcript-api"
  if [ -z "$missing" ]; then
    mkdir -p "$HOME/.cache/skill-deps"
    touch "$dep_cache"
  else
    echo "MISSING DEPENDENCIES:$missing"
    echo "Install: brew install yt-dlp && pip install youtube-transcript-api"
  fi
fi
```

Given a YouTube URL (or a previously saved video ID), load the transcript and analyze it.

## Configuration

Set `TRANSCRIPT_DIR` once. All subsequent steps reference this variable.

```bash
TRANSCRIPT_DIR="${VAULT_ROOT}/youtube"
```

> **To share this skill**: change `TRANSCRIPT_DIR` to wherever you want transcripts saved.

---

## Step 0 — Extract the video ID

Parse the video ID from the URL. Supported formats:
- `youtube.com/watch?v=VIDEO_ID`
- `youtu.be/VIDEO_ID`
- `youtube.com/live/VIDEO_ID`

Store the ID in a variable for all subsequent steps.

```bash
VIDEO_ID="<extracted-id>"
```

---

## Step 1 — Check for existing transcript

Look for a saved transcript at:

```
${TRANSCRIPT_DIR}/${VIDEO_ID}.md
```

If it does not exist, continue to Step 2.

If it does exist, validate that it's properly paragraphed before skipping to Step 4. Run a quick check:

```bash
BODY_LINES=$(tail -n +8 "${TRANSCRIPT_DIR}/${VIDEO_ID}.md" | wc -l)
BODY_CHARS=$(tail -n +8 "${TRANSCRIPT_DIR}/${VIDEO_ID}.md" | wc -c)
echo "lines=$BODY_LINES chars=$BODY_CHARS"
```

If the body is large (>5000 chars) but has fewer than ~10 lines, the transcript was saved as a single long line and needs to be re-paragraphed. Run this in-place fix:

```bash
python -c "
with open('${TRANSCRIPT_DIR}/${VIDEO_ID}.md', 'r') as f:
    content = f.read()

parts = content.split('---', 2)
frontmatter = '---' + parts[1] + '---'

body_start = content.index('\n# ') + 1
heading_end = content.index('\n', body_start)
heading = content[body_start:heading_end]
body_text = content[heading_end:].strip()

words = body_text.split()
paragraphs = []
for i in range(0, len(words), 100):
    paragraphs.append(' '.join(words[i:i+100]))

with open('${TRANSCRIPT_DIR}/${VIDEO_ID}.md', 'w') as f:
    f.write(frontmatter + '\n\n' + heading + '\n\n' + '\n\n'.join(paragraphs) + '\n')
"
```

Once validated (or re-paragraphed), skip to **Step 4** (Analyze).

---

## Step 2 — Download and persist the transcript

All files are written directly to `${TRANSCRIPT_DIR}/`. No temp directory needed.

First, ensure the directory exists:

```bash
mkdir -p ${TRANSCRIPT_DIR}
```

Download the subtitle file directly into the vault:

```bash
yt-dlp --write-auto-sub --sub-lang en --skip-download \
  --output "${TRANSCRIPT_DIR}/${VIDEO_ID}" \
  "<URL>"
```

This writes `${TRANSCRIPT_DIR}/${VIDEO_ID}.en.vtt`.

If that fails (geo-block, no auto-captions), fall back to:

```bash
python -c "
from youtube_transcript_api import YouTubeTranscriptApi
video_id = '${VIDEO_ID}'
t = YouTubeTranscriptApi.get_transcript(video_id)
print('\n'.join([x['text'] for x in t]))
" > "${TRANSCRIPT_DIR}/${VIDEO_ID}.raw.txt"
```

If `youtube_transcript_api` is not installed: `pip install youtube-transcript-api` then retry.

Also grab the video title:

```bash
VIDEO_TITLE=$(yt-dlp --get-title "<URL>" 2>/dev/null || echo "Unknown Title")
```

---

## Step 3 — Clean and save final transcript

### Clean

The VTT file contains timing tags and duplicated lines. Strip them and split into readable paragraphs (one paragraph per ~100 words). This ensures the final `.md` file can be read in chunks with `Read` using `offset/limit` without hitting token limits.

```bash
python -c "
import re, textwrap

with open('${TRANSCRIPT_DIR}/${VIDEO_ID}.en.vtt', 'r') as f:
    raw = f.read()

lines = raw.split('\n')
cleaned = []
seen = set()
for line in lines:
    line = line.strip()
    if re.match(r'^\d{2}:\d{2}', line) or line.startswith('NOTE') or line == 'WEBVTT' or not line:
        continue
    line = re.sub(r'<[^>]+>', '', line).strip()
    if line and line not in seen:
        seen.add(line)
        cleaned.append(line)

full = ' '.join(cleaned)
words = full.split()
paragraphs = []
for i in range(0, len(words), 100):
    paragraphs.append(' '.join(words[i:i+100]))

print('\n\n'.join(paragraphs))
"
```

If the source file is `.raw.txt` (fallback path), read it directly and apply the same paragraph splitting.

### Save as final markdown

Write the cleaned transcript to `${TRANSCRIPT_DIR}/${VIDEO_ID}.md` using the Write tool:

```markdown
---
video_id: <VIDEO_ID>
title: "<VIDEO_TITLE>"
url: <ORIGINAL_URL>
saved: YYYY-MM-DD
---

# <VIDEO_TITLE>

<cleaned transcript text>
```

Then delete the intermediate `.en.vtt` (or `.raw.txt`) file since the final `.md` is the canonical copy:

```bash
rm -f ${TRANSCRIPT_DIR}/${VIDEO_ID}.en.vtt \
      ${TRANSCRIPT_DIR}/${VIDEO_ID}.raw.txt
```

### Update the index

Update `${TRANSCRIPT_DIR}/_index.md`. Append a row to the table (create the file with headers if it doesn't exist).

Write a one-sentence summary of the video based on the cleaned transcript. Keep it under ~30 words, focused on the core thesis or topic.

```markdown
# YouTube Transcripts

| date | video_id | title | summary |
|---|---|---|---|
| YYYY-MM-DD | VIDEO_ID | Title | One-sentence summary of the video's core topic. |
```

Sort by date descending (newest first, after the header row).

---

## Step 4 — Analyze

Read the cleaned transcript from the persisted `.md` file. Long transcripts will exceed the `Read` tool's 10k token limit. Handle this automatically:

1. First attempt: `Read` the full file (no offset/limit).
2. If it fails with a token limit error, read in sequential chunks using `offset` and `limit` (e.g., 150 lines at a time) until the entire file is consumed. Do NOT fall back to ad-hoc Python scripts or Bash workarounds.
3. Analyze based on the combined content from all chunks.

Then apply the analysis prompt.

**Default analysis** (when no custom prompt is given):

Produce two sections:

### Summary
Concise overview of what the video covers in 2-3 sentences, followed by a short bulleted breakdown of the key topics. Lead with the main takeaway, then list supporting points.

### Recommendations for Me
Actionable takeaways personalized to the user. Before writing this section, build context by reading:
- `config/user-context.md` for role, tools, and working style
- The vault's `CLAUDE.md` (at the vault root) for org structure, projects, and preferences
- The project `CLAUDE.md` (workspace root) for current workflows and directory layout

Use what you learn to connect the video's ideas to what the user is actually working on, the tools they use, and the challenges they face. Flag things they're already doing well. Focus recommendations on gaps or improvements. Do not hardcode specific topics here; let the context files drive relevance.

---

**Custom analysis** (when user provides a prompt):

Apply the user's prompt directly to the transcript. Override the default structure entirely.

---

**Follow-up questions**: If the user asks a follow-up about a video that was already analyzed in this session, or references a video ID, load the transcript from `${TRANSCRIPT_DIR}/{video-id}.md` and answer using that context. No need to re-run the full skill.

---

## Output routing

- Analysis output: respond inline in the conversation (default)
- Transcript persistence: always saved to `${TRANSCRIPT_DIR}/{video-id}.md` (automatic, no user prompt needed)
- If the user asks to save the analysis too: append an `## Analysis` section to the saved transcript file
