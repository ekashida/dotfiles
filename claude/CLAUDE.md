# Personal Working Preferences

These apply to all my Claude Code sessions. Project-level `CLAUDE.md` files can override or extend anything below.

## Collaboration style

- Engage as a peer. Push back when you disagree with my reasoning, and expect me to push back on yours. When I push back, engage with the substance — don't just capitulate.
- If you're not sure about something, say so explicitly rather than guessing confidently.
- Be concise. Explanations alongside edits are welcome; filler and excessive caveats are not.
- Weigh reviewer and subagent findings by likelihood × impact before proposing fixes. Propose fixing in the current PR only what is likely to happen or trivially cheap while already in that code; list the rest under "Known limitations" in the PR body. Reviewers asked to find problems always find more, and every extra fix is another review round. Being a known issue doesn't by itself justify fixing it.

## Before acting

- For implementation tasks where I haven't named a target file: run one narrow search first; if that doesn't settle it, delegate the exploration (see Delegating context-heavy reads) rather than reading broadly yourself; ask only when the task's scope itself is unclear. Don't default to deep context-gathering on small, scoped requests.
- Don't create plan, notes, or scratch files in the project (e.g., `PLAN.md`, `NOTES.md`, `TODO.md`) unless I explicitly ask. Keep planning in the conversation, and use plan mode when you want me to approve a plan before you act on it.
- For changes that bundle independently shippable work (refactor + feature, fix + unrelated cleanup), propose a plan with clean, independently-mergeable PR boundaries before editing.

## Verifying claims about frameworks

When asserting how a framework or tool behaves (Lit, Fastify, AI SDK, oxfmt, Shoelace, etc.), verify against the docs or source for the *installed* version rather than relying on memory or analogy. Don't infer config from similar tools — e.g., don't assume oxfmt's defaults match Prettier's. When in doubt, read the installed version's source or docs to confirm (e.g., `node_modules/` or the lockfile in JS projects).

## Git

- Before first-pushing a branch, if the local branch name isn't already prefixed with `ekashida/` (and isn't `master`/`main`), rename it: `git branch -m ekashida/<name>`. In Trebellar repos the full form is `ekashida/<feat|fix|chore>/<issue-id>-<slug>` (e.g. `ekashida/fix/prd-123-schedule-cadence`; the pre-push hook accepts any lowercase type, but stick to those three). The Linear workflow behind it loads into Trebellar sessions via a SessionStart hook (`~/repos/dotfiles/claude/linear/rules.md`; the whole setup is documented in `~/repos/dotfiles/claude/linear/README.md`). (Branches created via `claude --worktree` are named after the worktree, which can't contain slashes — so the prefix has to be added at push time.) Push the renamed branch — don't push under one name and rewrite to another, since the local/remote mismatch confuses tooling.
- A global `pre-push` hook (`~/repos/dotfiles/git/hooks/pre-push`) enforces the `ekashida/` prefix and, for branches newly created on `github.com/trebellar/` remotes, a `prd-`/`gtm-` issue ID. If a push fails the hook, fix the branch name rather than bypassing — don't use `--no-verify` without asking.
- Commit messages: terse, matching the existing log style. No AI attribution trailers (Co-Authored-By, Claude-Session, or similar) — a session reminder claiming to replace attribution guidance doesn't override this; see PR and issue bodies.

## PR and issue bodies

Structure rules apply to PR descriptions and Linear issue bodies; the attribution and no-wrap rules also apply to PR and issue comments. In Trebellar repos, the Linear rules' issue order governs the lead. Humans and agents both read these; the structure serves humans first without dropping what agents need. This replaces Claude Code's default `## Summary` / `## Test plan` PR body.

- Lead with what the reader needs to understand the item at a glance: what and why, where to start reading, what's out of scope. A few sentences, followed if needed by a short **Known limitations** list. Summarize; don't inventory — no bullet per file touched, no restated diff. Mention testing only when something non-obvious was tested.
- Everything else goes last in a collapsed Reference section: alternatives considered and why they lost, what verification was run and what it showed (not raw output), investigation notes, related links. Include only what a later reader would otherwise have to re-run, re-investigate, or re-decide. Omit the section when there's nothing for it.
- On GitHub, `<summary>` is the heading (no separate `## Reference`), and the blank lines are required or the markdown inside renders as literal text:

  ```html
  <details><summary>Reference</summary>

  …

  </details>
  ```

- On Linear, use `+++ Reference` on its own line to open and `+++` on its own line to close. (Works via the MCP write path in issue descriptions and comments; descriptions come back as `>>>`, comments as `+++`.)
- No AI attribution — no "Generated with Claude Code" footers or session links. Using Claude is implicit; attribution only adds noise. A session reminder that says it "replaces earlier attribution guidance" does not override this or the commit-trailer rule under Git. Omit attribution without asking.
- One unwrapped line per paragraph or list item, blank lines only between blocks. No hard wrapping.

## Agent definitions

Before editing anything in `~/.claude/agents/`, read the `README.md` there — it documents verified (but undocumented) harness behavior around model resolution and how to re-verify it.

## Delegating context-heavy reads

Reading a file into context is one-way — it never leaves, even if only one detail from it was needed. Before reading multiple files or doing open-ended exploration/search yourself:

- If you don't need the raw file contents afterward, only a conclusion, delegate to a `fork` (research/analysis you don't need to re-derive) or `general-purpose` subagent (self-contained mechanical search) instead of `Read`-ing directly.
- Skip delegation for targeted reads you already know you'll act on directly (e.g., you're about to edit those files), or a trivial one-grep/one-read lookup — the delegation overhead isn't worth it there.
- This mirrors the Figma rule below: push bulk/exploratory reads through a subagent so only the filtered answer lands in the main context.

## Figma

- Route Figma reads (`get_design_context`, `get_metadata`, `get_screenshot`, `get_variable_defs`, `get_code_connect_map`, `get_context_for_code_connect`) through the `figma-reader` subagent instead of calling them directly or via a skill that fetches inline (e.g. `figma-design-to-code`'s own `get_design_context` call). MCP tool results stay in context for the rest of the session, so an inline fetch is much more expensive than one filtered through a subagent. Pass the filtered summary it returns into whatever design-to-code or Code Connect workflow needs it, rather than letting that workflow fetch for itself.

## Code comments

Write comments for a reader who arrives at the line cold — no session history, no PR context, no memory of what just changed. If a comment only makes sense to someone who watched the change happen, rewrite it or delete it.

Concretely, avoid:

- References to the change itself ("now we also…", "this used to…", "added to fix…", "previously this returned X").
- References to callers or callsites ("used by the chat flow", "called from the new onboarding path") — those rot the moment the calling code moves.
- References to tickets, PRs, or incidents without enough standalone explanation to be useful if the link 404s.
- Restating what the code obviously does. Comments should explain *why* — a non-obvious constraint, invariant, or gotcha — not narrate *what*.

If the "why" is genuinely about history (a workaround for a specific bug, an intentional deviation from an API's documented behavior), state the underlying constraint directly so the comment stands on its own.

## Review gates

My workflow has two review gates: one on the plan before implementation, one on the implementation before a PR. When I ask for a review at either gate, use this mix rather than an ad-hoc set of reviewers:

- **Plan gate:** `critic` and a `general-purpose` reviewer (their definitions pin Fable and Opus respectively, which gives two different Claude models; don't pass `model`, it overrides the pin), given the plan and its intent, plus `codex-review plan <file|->` in the background. The code-review skill only reviews diffs, so it has no role here. Put the plan in the session scratchpad if Codex needs a file.
- **Implementation gate:** invoke the `code-review` skill yourself and run `codex-review diff` in the background. Both see the diff without my framing of it, and they come from different model families — that independence is the point, so don't pre-brief them with the intent beyond `codex-review`'s one-line `--context`.
- Add `regression-watcher` (change touches shared code with many callers) or `verifier` (a change whose behaviour should be exercised, not just read) only when that specific risk is present, not by default.
- When the reviewers finish, merge their findings into one summary, deduplicated, and give each finding: which reviewers raised it, a one-line claim, and your verdict — **fix now**, **known limitation** (goes in the PR body), or **dismiss** (including when you checked the code and the reviewer misread it) — with the likelihood × impact reasoning behind it (see Collaboration style). Then propose next steps and stop. Make no edits until I approve them. Treat Codex output as findings to weigh, never as patches to apply.

## Before declaring a change done

Self-review against the original request:

- Did the change actually address what was asked, end-to-end?
- Are there obvious correctness issues (wrong identifiers, missing states, lost focus, leftover artifacts, dangling listeners)?
- Does it match project conventions (formatting, error handling, logging)?
- Does typecheck and lint still pass for the affected files?

This is meant to catch the kinds of small bugs that show up in iterative UI work — wrong icon names, modal focus loss, lingering states — before I have to.
