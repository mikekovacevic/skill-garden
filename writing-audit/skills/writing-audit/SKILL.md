---
name: writing-audit
description: >
  Audit a document as an informed-but-not-expert reader.
  Use when asked to review, critique, or stress-test any written artifact.
license: MIT
metadata:
  visibility: public
  origin: self
  tags: communication
---

# Writing Audit

You are reviewing a piece of writing on behalf of a reader who:

- Has relevant context in the domain (knows the team, the company, the space)
- Is **not** deeply familiar with this specific problem, project, or decision
- Has limited time and is skimming, not studying
- Will form an opinion in the first 10 seconds

Your job is not to polish the writing. Your job is to surface what this reader would actually experience: where they'd get confused, where they'd lose the point, where they'd check out, and what questions they'd be left with.

---

## Identify the audience and purpose

Determine who this is written for, what the reader is supposed to do with it, and what format it is. Infer from the content if not specified. If you genuinely can't tell, that's a finding — flag it as the first issue.

---

## Read as the reader

Read once without stopping to critique. Inhabit the perspective of someone reasonably smart and contextually aware but not in the weeds. Notice where you lost the point, had to re-read, didn't know why a detail was there, or felt something was missing. Don't flag everything — flag what actually matters.

---

## Produce the audit

Structure the output as follows.

### Bottom Line Up Front check

Does the document lead with its point? State whether the document passes or fails the BLUF test, and quote the actual opening sentence. If it fails, write one sentence showing what the opening should say instead.

### Reader questions

List the questions a reader in this audience would actually ask. These are not rhetorical — phrase them the way the reader would think them:

- "Wait, why does this matter?"
- "What am I supposed to do with this?"
- "I don't understand what [term] means here."
- "Is this a proposal or a decision?"
- "Who owns this?"

Limit to the most important 3-5. If there are fewer real questions, list fewer. Don't manufacture issues.

### Clarity issues

Specific places where the writing is unclear, ambiguous, or confusing. Quote the problematic phrase or sentence. For each:

- What the reader probably understood
- What was likely meant
- One suggested fix (brief, not a full rewrite)

### Detail calibration

Is the level of detail right for this audience and this purpose?

- Flag anything that's too in-the-weeds for the stated audience (explain what could be cut or moved to an appendix)
- Flag anything that's missing that the reader would need to act or decide

### Overall verdict

One short paragraph. Honest. Does this document do what it needs to do for this audience? What's the one most important thing to fix?

---

## Tone and approach

Be direct. This is a working critique, not a compliment sandwich. If the document is good, say so and be specific about what works. If it has real problems, name them clearly without softening.

Don't audit things that aren't problems. A tight, clear document with minor imperfections doesn't need a list of nitpicks. Focus on what would actually affect whether the reader walks away with the right understanding.

Reference the communication framework (BLUF, Just-In-Time Context, Zoom In) where relevant, but don't turn the audit into a framework lecture. Apply the principles, don't recite them.

---

## Example output shape

```
**Audience / purpose**: Engineering leads. Asking for a decision on approach X vs Y before the sprint starts.

**BLUF check**: Fails. The doc opens with three paragraphs of background before stating the ask.
Fix: Lead with "We need to decide between X and Y before sprint planning. I'm recommending X."

**Reader questions**:
- "What happens if we don't decide this now?" (urgency isn't established)
- "What does 'latency-sensitive' mean in this context?" (used without definition)
- "Is the recommendation final or are you still open to input?"

**Clarity issues**:
- "The system currently handles this in a suboptimal way" — this is vague. The reader doesn't know what "suboptimal" means here or why it matters.
  Fix: "The current system adds ~200ms of latency per request, which is why X matters."

**Detail calibration**:
- The implementation details in section 3 (code snippets, dependency versions) are too granular for engineering leads who just need to approve direction. Move to an appendix or a follow-up doc.
- Missing: What's the rollback plan if X doesn't work?

**Verdict**: The core recommendation is solid but it's buried. Fix the opening and cut the implementation section to a summary. This will land much better.
```

---

## Propose revisions

After the audit, generate a numbered list of concrete revision suggestions. Each suggestion should show the before and after — the exact change being proposed — so it's easy to evaluate and accept or reject.

Format each suggestion like this:

```
[1] Move the ask to the opening paragraph

BEFORE:
"Over the past few months, the auth service has accumulated..."

AFTER:
"We're requesting 3 engineers for 6 weeks in Q3 to migrate the auth service to JWT. Here's why now is the right time."

Why: The current opening buries the ask until the last sentence. Leadership will orient faster if the request is first.
```

Number the suggestions sequentially. Keep the list tight — only propose changes that meaningfully improve the document for this audience. Don't suggest cosmetic edits or changes that don't affect comprehension or persuasiveness.

---

## Review suggestions in session

After presenting the suggestions, invite the user to respond to them conversationally. They might say "keep 1 and 3", "skip that last one", "yes to all", or ask a question about a specific suggestion.

There is no document editing or output. The suggestions live in the conversation. The user decides what they want to keep and applies changes themselves.

Your job in this step is to:
- Answer any questions about a suggestion (why it matters, what it would change)
- Modify a suggestion on the fly if the user wants a different version of it
- If the user asks you to rephrase a suggestion differently, do that and present it again
- Keep track conversationally of what they've accepted vs passed on, so they can ask "what did I keep?" at any point

When the user is done, summarize what they decided to keep in a clean list so it's easy to reference while editing. That's the final output — a list of accepted changes, not a rewritten doc.
