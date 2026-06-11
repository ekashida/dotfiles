---
description: Walk through a file (or symbol) section by section, pausing for questions and confirmation between each
---

Walk through the file or symbol named in the argument, one section at a time, in dialog.

Argument forms:
- `/walkthrough path/to/file.ts` — walk through the whole file.
- `/walkthrough path/to/file.ts::symbolName` — walk through one function/class/type in that file (plus the imports and helpers it depends on).
- `/walkthrough path/to/dir/` — treat the directory as a small module; walk through it file-by-file at the file level, then optionally drill into one of them.
- `/walkthrough <commit-ish, range, or PR number>` — walk the diff as a series of logical changes.

If the argument is missing or doesn't resolve to a file, directory, or diff, say so and stop.

## Diff targets

When the target is a diff, sections are logical changes, not files or hunks — one conceptual change may span files, and one file may contain unrelated changes. Before explaining a hunk, read the surrounding code in the post-change file; the diff alone rarely shows the contracts the change participates in. Quote the resulting code (enough to read cold), noting briefly what it replaced — not raw `+`/`-` hunks. The "why it's shaped that way" step becomes "why this change, and why this shape rather than the alternatives."

## Step 0 — Read the file and propose sections

Before writing any walkthrough prose, read the target end-to-end. Then post a numbered list of the sections you plan to cover, with a one-line description each. Order sections so each one only depends on things already covered — usually data-flow or dependency order, not file order. Keep section count proportional to file size — 3 sections for a 50-line file, 5–8 for a typical file, more only when the file genuinely splits into more concerns. Group trivial setup (imports, constants used in one place) with the section that consumes it rather than giving it its own section.

End the turn after the section list. Wait for the user to confirm or renegotiate scope. They may:
- Accept the list as-is.
- Ask you to merge or split sections.
- Ask you to skip sections they already understand.
- Reorder them.
- Replace the list with a focus area you missed.

Do not start section 1 in the same turn as posting the list.

## Per-section flow

Process sections in the agreed order. For each section:

1. **Quote the relevant code.** A fenced block with just the lines this section covers — enough that the reader can follow without scrolling another window.
2. **Explain what it does.** Briefly. Well-named code doesn't need restating.
3. **Explain why it's shaped that way.** This is the load-bearing part. Trade-offs, alternatives considered, constraints from the framework or wire format, things that look weird but exist for a reason. If you don't have anything to say here beyond "it does X," the section is probably too small — fold it into a neighbor.
4. **Flag non-obvious quirks.** Defensive code, comments-that-should-be-there-but-aren't, gotchas that would bite a future maintainer, places where the type system can't catch a mistake. One or two per section, not an audit.
5. **Stop.** End the turn. Wait for "next" / "yes" / "go on" / a question. Do not continue to the next section in the same turn, even if the next one is short.

## Handling questions

The user will ask questions. Treat them as first-class — that's half the value of this format.

- A question *about the current section* gets answered fully before moving on. Don't truncate.
- A question *about a future section* — answer it, then note "we'll see this again in section N."
- A question that goes beyond the file — answer it on its own terms. Don't force the answer back into the walkthrough structure.
- A question that reveals the section was confusing — restate the section more clearly before moving on, even if the user didn't ask you to.
- Push-back: engage with the substance. Don't capitulate just because the user disagrees. If they're right, say so and adjust; if you still think you're right, explain why.

## Closing

At the last section, add a short synthesis after the usual content: 2–4 sentences naming the patterns you saw across the file — recurring shapes, intentional duplications, conventions a future reader should keep using. This is the only retrospective step; don't summarize each section, just the across-file observations.

After the closer, end the turn and ask if they have questions on any specific section or the file overall.

## Rules

- Skip trivial sections rather than padding them. "Imports" is rarely worth its own section; bundle with the first place those imports are used.
- Don't restate what well-named code already says. If the section is just `function add(a, b) { return a + b; }`, you have nothing to add — say so and move on.
- Don't propose changes to the code during the walkthrough unless the user asks. The skill is explanation, not refactoring. (If you spot a real bug, flag it briefly and note "worth a separate look" — but don't derail the walkthrough.)
- Don't batch sections. One per turn, always.
- If the file is small enough that the whole thing fits in one section, this skill is overkill — say so and just explain the file in one shot.
