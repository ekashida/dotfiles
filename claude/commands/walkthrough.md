---
description: Walk through a file, symbol, directory, or diff section by section, pausing for questions and confirmation between each
argument-hint: <path | path::symbol | dir/ | commit-ish or PR number> [--depth low|high]
---

Walk through the target named in the argument, one section at a time, in dialog.

Argument forms:
- `/walkthrough path/to/file.ts` — walk through the whole file.
- `/walkthrough path/to/file.ts::symbolName` — walk through one function/class/type in that file (plus the imports and helpers it depends on).
- `/walkthrough path/to/dir/` — treat the directory as a small module; sections are files. Quote each file's load-bearing parts (exports, signatures, the central function) rather than whole files. Offer to drill into one of them afterward.
- `/walkthrough <commit-ish, range, or PR number>` — walk the diff as a series of logical changes.
- Any form takes an optional `--depth low|high`. `high` means: research harder before step 0, give every mechanism its own section rather than merging, and carry a full failure trace even for the supporting ones. `low` means: keep sections tight and reserve traces for the invariant-bearing parts. Default sits between them.

If the argument is missing or doesn't resolve to a file, directory, or diff, say so and stop. If it resolves to more than one of those (e.g. a number that is both a file and a PR), prefer the path and say which reading you chose. If the file in a `::symbol` form exists but the symbol doesn't, list the file's top-level symbols and stop.

## Diff targets

When the target is a diff, read the full diff first (`gh pr diff <number>` for PR numbers), and size the section count to the change rather than the number of files touched. Sections are logical changes, not files or hunks — one conceptual change may span files, and one file may contain unrelated changes. Before explaining a hunk, read the surrounding code in the post-change file; the diff alone rarely shows the contracts the change participates in. Then go outside the touched files before proposing sections: read the motivating PR or issue when the body references one (`gh pr view <n>`), find every caller of each changed function, and check who reads the state it writes. Most of a diff's "why" lives outside the diff — a two-line fix usually exists because of a contract established elsewhere, and a walkthrough built only from the hunks can say what changed but not why it was wrong. Quote the resulting code (enough to read cold), noting briefly what it replaced — not raw `+`/`-` hunks. The "why it's shaped that way" step becomes "why this change, and why this shape rather than the alternatives."

## Step 0 — Read the file and propose sections

Before writing any walkthrough prose, read the target end-to-end. Size the walkthrough by how many distinct mechanisms the reader has to hold at once — never by the size of the target. Line count, file count, and diff size are all bad proxies: a five-line diff can carry four mechanisms (a shared invariant, an API whose failure mode is non-obvious, a caller contract, some dead bookkeeping), while a 300-line file of CRUD wrappers carries one. Bail to a single-shot explanation only when the target genuinely holds one mechanism — say so, explain it in one shot, and skip the rest of these steps. Otherwise, open with a short high-level grounding before the section list: what the target implements in domain terms (the problem, not the code), the end-to-end data or control flow, and the one or two constraints that explain its overall shape. Sections should then slot into that frame — a reader who skipped the grounding should feel it. Then post a numbered list of the sections you plan to cover, with a one-line description each. Order sections so each one only depends on things already covered — usually data-flow or dependency order, not file order. Keep section count proportional to the mechanism count — typically 3–8, roughly one per mechanism, folding in any that can't stand on its own. Group trivial setup (imports, constants used in one place) with the section that consumes it rather than giving it its own section.

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
3. **Explain why it's shaped that way.** This is the load-bearing part. Trade-offs, alternatives considered, constraints from the framework or wire format, things that look weird but exist for a reason. If you don't have anything to say here beyond "it does X," the section is probably too small — fold it into a neighbor. Follow the explanation method below — especially for invariants and defensive code.
4. **Flag non-obvious quirks.** Defensive code, comments-that-should-be-there-but-aren't, gotchas that would bite a future maintainer, places where the type system can't catch a mistake. One or two per section, not an audit.
5. **Stop.** End the turn. Wait for "next" / "yes" / "go on" / a question. Do not continue to the next section in the same turn, even if the next one is short.

## Explanation method

Explain mechanisms, not conclusions. Any claim that something is "critical", "load-bearing", or "the whole point" must carry its mechanism in the same breath — never as a compressed jargon clause the reader is expected to unpack themselves.

- **Lead in plain register.** Concrete actor-verb sentences first: name what a specific piece of code does to a specific value. Introduce the compact term afterward, as a label for what you just described — never as the description itself. "The controller keeps a Set of ids it has already asked for, and never removes them" teaches; "a read-through cache keyed by presence" only confirms it for a reader who already knew. Dense register is for review contexts, not for building someone's model of unfamiliar code.
- **Structure each mechanism as: setup → mechanism → concrete failure trace → how the code prevents it.** The failure trace is the core move: walk what actually goes wrong without this code, using invented-but-specific values (an employee id, two sensor names, a date, real counts through the real formula) rather than abstract nouns. "Dedupe is on (sensor, timestamp)" doesn't land; "last week stored (S1, 09:00:01), this week emits (S2, 09:00:01), no collision, the day double-loads" does.
- **One claim per sentence.** Don't lump several mechanisms under one "hence" — if two protections exist for different reasons, present them as two mechanisms, even when the code puts them side by side.
- **Default to the counterfactual lens for defensive code and invariants**: answer "what breaks without this?" before the reader has to ask.
- **Surface shared invariants.** When several mechanisms in a section reduce to one underlying invariant, name it explicitly — that's the highest-value sentence in the section, and it's invisible if each claim is summarized independently.
- **Calibrate depth.** Full failure-trace depth is for the invariant-bearing parts; plumbing and conventions stay tight. Unpacking everything triples the length and buries the traces that matter.

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
