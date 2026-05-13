---
description: Walk through each concern from a prior /review, one at a time — classify, explain, discuss, fix, verify
---

Triage the concerns from the most recent `/review` output in this conversation.

If there is no prior `/review` output in the conversation, say so and stop.

## Step 0 — Classify all concerns up front

Before touching any concern in depth, read each one and tag it:

- **real-bug** — code is wrong; behavior diverges from intent.
- **design-question** — code works, but the reviewer is questioning an approach, tradeoff, or convention.
- **nit** — minor (naming, formatting, doc wording, dead code) with no behavioral impact.
- **likely-wrong-reading** — the reviewer appears to have misread the code; the concern doesn't reflect what the code actually does.

Classification is not free-form guessing. For each concern, open the cited file, read the relevant lines, and skim enough surrounding context to be confident in the tag. If you cannot locate what the reviewer is pointing at, tag it `likely-wrong-reading` and note that.

Report classifications as a compact list (one line each: tag + one-sentence justification). Do not yet explain or fix anything. End the turn after the classification list and wait for my acknowledgement or corrections — I may re-tag.

## Per-concern flow

Process concerns in order. The flow depends on the tag.

### real-bug and design-question — full ceremony

1. **Explain** the issue. Required: cite the specific file and line(s), and trace the code path that triggers the issue (what calls into it, under what conditions). A concrete snippet, scenario, or analogy is welcome on top of the trace, but the trace is mandatory — it's what catches reviewer hallucinations. Avoid jargon unless you define it.
2. **Discuss.** End your turn after step 1 and wait for my response. Do not propose a fix, start applying one, or move to step 3 in the same turn — even if the issue seems obvious or you've already decided how to fix it. Once I respond, engage with the substance — don't capitulate just because I disagree.
3. **Decide and fix.** Once I'm satisfied I understand the issue, propose a fix and iterate with me until I approve. Then apply it.
4. **Verify the fix** (step 3.5). Immediately after applying the fix, spawn a fresh general-purpose subagent with the original concern text, the file(s) changed, and the diff. Ask it two questions: (a) does the change fully address the concern? (b) does the change introduce any new issues (regressions, broken invariants, missed call sites, lint/type problems)? The subagent must be fresh — do not reuse one that already saw the discussion, since we want an independent read. Report the subagent's findings in one short paragraph. If it surfaces problems, return to step 3 to iterate.
5. **Move on** only after the current concern is resolved (fixed-and-verified, deferred, or dismissed).

### nit — short loop

1. State the nit, cite file:line, propose the fix in the same turn.
2. Apply on my approval (or skip on my rejection). No separate discuss step.
3. Skip the subagent verification — nits don't carry regression risk worth a fresh subagent. If the nit turns out to be load-bearing during the fix, re-tag it and run the full ceremony instead.

### likely-wrong-reading — dismiss with evidence

1. Explain why the reviewer's reading appears wrong: cite the lines, trace what the code actually does, and contrast with what the reviewer claimed.
2. End the turn and wait. If I agree, dismiss the concern. If I disagree or you've convinced yourself the reviewer was right after all, re-tag (likely to real-bug or design-question) and run that flow.

## Rules

- Do not batch concerns across tags. Do not summarize all of them up front beyond the Step 0 classification list — we already have the `/review` output for that.
- Start with Step 0. After classification, the first concern to process is the first non-dismissed one in the original `/review` order, regardless of tag.
- "Verify with a fresh subagent" means a new `Agent` invocation with no prior context, briefed via a self-contained prompt — not a continuation of an existing agent.
