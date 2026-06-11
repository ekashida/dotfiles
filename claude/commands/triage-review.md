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

Report classifications as a compact list (one line each: tag + one-sentence justification), sorted: likely-wrong-reading first (cheapest to clear out), then real-bug, then design-question, then nit. Within a tag, keep the original `/review` order. This is also the processing order. Do not yet explain or fix anything. Then wait for my acknowledgement with options: **proceed** (tags accepted, start triage) / **re-tag** (I'll say which tags to change).

## Per-concern flow

Process concerns in order. The flow depends on the tag.

### real-bug and design-question — full ceremony

1. **Explain** the issue. Two required parts:
   - **Plain-language summary.** What's wrong, when it manifests, and who notices (user-visible symptom, silent data corruption, dev-only papercut, etc.). Avoid jargon unless you define it. This is what lets me judge severity and decide whether to defer.
   - **Code-path trace.** Cite the specific file and line(s), and trace what calls into the affected code and under what conditions. This is what catches reviewer hallucinations — a concern that can't be traced is probably a misread. For a design-question with no meaningful call path (naming, conventions, structure), cite the relevant code instead — don't manufacture a trace.

   A concrete snippet, scenario, or analogy on top of these is welcome. Stop here and wait for my decision with options: **fix** (go to step 3) / **clarify** (keep discussing the issue) / **defer** (real but not worth fixing now) / **dismiss** (not actually an issue). Do not propose a fix, start applying one, or move ahead in the same turn — even if the issue seems obvious or you've already decided how to fix it.
2. **Discuss.** Once I respond, engage with the substance — don't capitulate just because I disagree. If I **defer**, note it and move to the next concern — skip steps 3–4. If I **dismiss**, move on directly.
3. **Decide and fix.** Propose a fix, then wait with options: **apply** / **revise** (I'll say what to change) / **defer**. Iterate until I pick apply, then apply it.
4. **Verify the fix.** Immediately after applying the fix, spawn a fresh general-purpose subagent with the original concern text, the file(s) changed, and the diff. Ask it two questions: (a) does the change fully address the concern? (b) does the change introduce any new issues (regressions, broken invariants, missed call sites, lint/type problems)? The subagent must be fresh — do not reuse one that already saw the discussion, since we want an independent read. Report the subagent's findings in one short paragraph. If it surfaces problems, return to step 3 to iterate.
5. **Move on** only after the current concern is resolved (fixed-and-verified, deferred, or dismissed). If a fix was applied, first wait with options: **commit** (commit this fix on its own) / **next concern** (leave it uncommitted and continue). If nothing changed, continue directly.

### nit — short loop

1. State the nit, cite file:line, propose the fix in the same turn, and wait with options: **apply** / **skip** / **escalate** (re-tag and run the full ceremony).
2. Apply or skip per my choice. No separate discuss step. If applied, offer the same **commit** / **next concern** choice before moving on.
3. Skip the subagent verification — nits don't carry regression risk worth a fresh subagent. If the nit turns out to be load-bearing during the fix, re-tag it and run the full ceremony instead.

### likely-wrong-reading — dismiss with evidence

1. Explain why the reviewer's reading appears wrong: cite the lines, trace what the code actually does, and contrast with what the reviewer claimed.
2. Wait with options: **dismiss** / **re-tag** (the reviewer was right — pick the new tag and run that flow) / **discuss**. If you've convinced yourself the reviewer was right after all, say so and recommend re-tag.

## Wrap-up

After the last concern is resolved, post a closing summary: one line per concern in the order processed, each with its final disposition (fixed-and-verified, deferred, or dismissed). If any applied fixes are still uncommitted, list them and wait with options: **commit** (one commit per fix) / **commit together** (a single commit for all of them) / **leave uncommitted**.

## Rules

- Whenever the flow waits for my decision, present the listed options as selectable choices via the AskUserQuestion tool — don't make me type them out. The option labels above are the canonical set for each step, but order them by your recommendation for the concern at hand: the option you'd pick goes first, marked "(Recommended)" when you have a clear lean. I can always answer free-form instead, and a free-form reply that doesn't match an option is a normal discussion turn, not an error.
- Do not batch concerns across tags. Do not summarize all of them up front beyond the Step 0 classification list — we already have the `/review` output for that.
- Start with Step 0. After classification, process concerns in the sorted order from the classification list, skipping any already dismissed.
- "Verify with a fresh subagent" means a new `Agent` invocation with no prior context, briefed via a self-contained prompt — not a continuation of an existing agent.
