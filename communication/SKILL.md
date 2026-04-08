---
name: communication
description: "Communication framework for drafting messages, docs, and verbal prep. Applies three techniques automatically: BLUF (lead with the point), Just-In-Time Context (give only what the audience needs right now), and Zoom In (explain depth by starting from shared understanding). Always active when drafting Slack messages, technical docs, RFCs, exec updates, or verbal talking points. Explicit trigger phrases: 'use BLUF', 'apply communication framework', 'draft this', 'help me write this', 'how should I explain this'."
license: MIT
metadata:
  visibility: public
  origin: self
  tags: communication
---

# Communication Framework

## Hard rule

**NEVER use em dashes (—) or double dashes (--).** Not in drafts, not in examples, not in headers, not anywhere. If you are about to write one, stop and rewrite the sentence. No exceptions.

---

Apply these three techniques whenever drafting or helping you communicate — Slack messages, technical docs, RFCs, exec/leadership updates, and verbal prep. They stack. Use all three by default, not just one.

---

## Technique 1: BLUF — Bottom Line Up Front

**The rule:** Lead with the point. Everything else supports it.

Most people build up to their conclusion (context → investigation → recommendation). The audience is holding all of that in their head without knowing where it's going. By the time the point lands, they've lost the thread.

**Flip it:** State the conclusion or ask first. Then provide supporting context only if needed.

**Test:** If the draft contains the phrase "so basically what I'm trying to say is..." anywhere, it went bottom-up. Rewrite from the top.

### BLUF in practice

| Context | Over-explained | BLUF |
|---|---|---|
| Slack ask | "Hey, I've been looking at the auth service and noticed some issues, and given the sprint timeline... could we maybe discuss?" | "Can we block 30 min this week to talk about the auth service? It's blocking two sprint items." |
| Exec update | "So we've been dealing with tech debt for a while, and the auth module is the worst offender, and that's why features are taking longer..." | "Feature velocity is down this quarter because of tech debt in the auth module. We need 6 weeks of cleanup and I want to propose pausing one feature track to make that happen." |
| RFC opening | Background → problem → options → recommendation | Recommendation → problem → options → rationale |

---

## Technique 2: Just-In-Time Context

**The rule:** Don't give a complete explanation. Give enough for what the person needs to do right now.

The instinct is to include all caveats, edge cases, and background because leaving things out feels sloppy. But a complete explanation and a useful explanation are almost never the same thing.

**Ask before drafting:** "What does this person need to do with this information?" Let that question filter every sentence. If a detail doesn't serve that need, cut it.

### Just-In-Time in practice

**Scenario:** A PM needs to talk about technical debt in a planning meeting.

Wrong version (complete explanation):
> Technical debt comes in a few forms — deliberate debt, accidental debt, bit rot. For our team, the auth module is deliberate debt, the payment system has accidental debt from the vendor integration, and notification is bit rot from bolting on four channels...

Right version (just-in-time):
> For our team, technical debt basically means we took shortcuts to ship faster and now those shortcuts are slowing us down. The main thing worth bringing up in planning is the auth module — features that should take a few weeks are taking months because of how it was built.

**The filter:** The thing this person needs to do with this information is ___. Only include what serves that blank.

---

## Technique 3: Zoom In

**The rule:** When depth is needed, start from shared understanding and go one layer at a time. Don't start from the beginning of the problem.

This isn't about dumbing things down — it's about sequencing correctly. Precision comes after understanding, not before.

Start from what they already know, go one layer deeper into the most relevant category, and stop when they have enough to act.

### Zoom In in practice

**Scenario:** New EM knows velocity is down, doesn't know why.

- Zoom 1: "Velocity dropped because of accumulated tech debt."
- Zoom 2: "The debt sits in three systems. Auth is the one that's hurting us."
- Zoom 3: "Auth was a temporary prototype. Six services depend on it now — changes that should take a week take three."

Three sentences. Enough to make decisions.

**Not the same as bottom-up.** Bottom-up builds the whole picture from the start. Zoom In starts from shared understanding and only goes deeper where it matters.

---

## How to apply by context

### Slack messages
- First sentence = the point or the ask (BLUF)
- One paragraph max unless thread warrants more
- No preamble ("Hey just wanted to flag that...", "Hope this finds you well...")
- Cut everything the person doesn't need to act or respond
- Tone: clear and factual. No unnecessary enthusiasm, exclamation points, or CTA-style phrases. Collegial, not marketer.

**Contrast example:**

| Avoid | Use instead |
|---|---|
| "Hey team! Really excited to share this brief — drop your comments directly in the doc!" | "Hey team, put together a brief on X. Would love your feedback before we move forward. [link]" |
| "Would love to connect and pick your brain!" | "Are you free for 30 min this week to talk through X?" |

### Technical docs / RFCs
- Open with the recommendation or decision, not the background
- Background section exists to support the recommendation, not lead to it
- Each section answers: "what does the reader need to do with this?" — cut the rest
- Use Zoom In structure when explaining complex systems: shared starting point, then layers

### Exec / leadership updates
- BLUF always — state the ask, risk, or decision needed in the first sentence
- Follow with the minimum context needed to evaluate it
- Save the full story for questions (they'll ask if they want it)
- Frame in terms of impact and decision, not technical detail

### Verbal prep / talking points
- Write the headline first — the one sentence you'd say if you had 10 seconds
- Add 2-3 supporting points, not a full narrative
- Anticipate one pushback and prep the Zoom In response for it
- If you find yourself explaining chronologically ("first I did X, then Y, then Z"), restart from the conclusion

---

## Formatting rules

These apply to all written output, always. No exceptions.

- **No em dashes or double dashes.** Never use `—` or `--`. Rewrite the sentence instead.
- **No AI-sounding filler.** Avoid "certainly", "absolutely", "great question", "it's worth noting that", "it's important to remember", "I hope this helps", "feel free to reach out", "don't hesitate to ask".
- **Short bullets when listing.** One idea per line. No nested sub-bullets unless truly necessary.
- **Conversational tone.** Write like a person, not a document. Avoid overly formal phrasing.

---

## Quick checklist before sending

- [ ] Does the first sentence contain the point or the ask?
- [ ] Is there any context in here the audience doesn't need right now?
- [ ] If explaining something complex, did I start from where they are, not where the problem started?
- [ ] Any em dashes or double dashes? Remove them.
- [ ] For Slack: any exclamation points, CTA phrases, or enthusiasm that doesn't belong? Remove them.
