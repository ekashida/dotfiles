# Personal Working Preferences

These apply to all my Claude Code sessions. Project-level `CLAUDE.md` files can override or extend anything below.

## Collaboration style

- Engage as a peer. Push back when you disagree with my reasoning, and expect me to push back on yours. When I push back, engage with the substance — don't just capitulate.
- If you're not sure about something, say so explicitly rather than guessing confidently.
- Be concise. Explanations alongside edits are welcome; filler and excessive caveats are not.

## Before acting

- For implementation tasks, if I haven't named a target file, ask before launching broad codebase searches or sub-agent calls — or, when running autonomously and asking would block the work, use the narrowest search that answers the question. Don't default to deep context-gathering on small, scoped requests.
- Don't create plan, notes, or scratch files (e.g., `PLAN.md`, `NOTES.md`, `TODO.md`) unless I explicitly ask. Keep planning in the conversation, and use plan mode when you want me to approve a plan before you act on it.
- For changes that bundle independently shippable work (refactor + feature, fix + unrelated cleanup), propose a plan with clean, independently-mergeable PR boundaries before editing.

## Verifying claims about frameworks

When asserting how a framework or tool behaves (Lit, Fastify, AI SDK, oxfmt, Shoelace, etc.), verify against the docs or source for the *installed* version rather than relying on memory or analogy. Don't infer config from similar tools — e.g., don't assume oxfmt's defaults match Prettier's. When in doubt, read the installed version's source or docs to confirm (e.g., `node_modules/` or the lockfile in JS projects).

## Git

- Before first-pushing a branch, if the local branch name isn't already prefixed with `ekashida/` (and isn't `master`/`main`), rename it: `git branch -m ekashida/<name>`. (Branches created via `claude --worktree` are named after the worktree, which can't contain slashes — so the prefix has to be added at push time.) Push the renamed branch — don't push under one name and rewrite to another, since the local/remote mismatch confuses tooling.
- A global `pre-push` hook (`~/repos/dotfiles/git/hooks/pre-push`) enforces the `ekashida/` prefix. If a push fails the hook, fix the branch name rather than bypassing — don't use `--no-verify` without asking.
- Commit messages: terse, matching the existing log style. No Co-Authored-By trailers.
- No AI attribution in PR descriptions either — no "Generated with Claude Code" footers or session links. Using Claude is implicit; attribution only adds noise.

## Agent definitions

Before editing anything in `~/.claude/agents/`, read the `README.md` there — it documents
verified (but undocumented) harness behavior around model resolution and how to re-verify it.

## Delegating context-heavy reads

Reading a file into context is one-way — it never leaves, even if only one detail from it was needed. Before reading multiple files or doing open-ended exploration/search yourself:

- If you don't need the raw file contents afterward, only a conclusion, delegate to a `fork` (research/analysis you don't need to re-derive) or `general-purpose` subagent (self-contained mechanical search) instead of `Read`-ing directly.
- Skip delegation for a single targeted read you already know you'll act on directly (e.g., you're about to edit that file), or a trivial one-grep/one-read lookup — the delegation overhead isn't worth it there.
- This mirrors the Figma rule below: push bulk/exploratory reads through a subagent so only the filtered answer lands in the main context.

## Figma

- Route Figma reads (`get_design_context`, `get_metadata`, `get_screenshot`, `get_variable_defs`, `get_code_connect_map`) through the `figma-reader` subagent instead of calling them directly or via a skill that fetches inline (e.g. `figma-design-to-code`'s own `get_design_context` call). MCP tool results stay in context for the rest of the session, so an inline fetch is much more expensive than one filtered through a subagent. Pass the filtered summary it returns into whatever design-to-code or Code Connect workflow needs it, rather than letting that workflow fetch for itself.

## Code comments

Write comments for a reader who arrives at the line cold — no session history, no PR context, no memory of what just changed. If a comment only makes sense to someone who watched the change happen, rewrite it or delete it.

Concretely, avoid:

- References to the change itself ("now we also…", "this used to…", "added to fix…", "previously this returned X").
- References to callers or callsites ("used by the chat flow", "called from the new onboarding path") — those rot the moment the calling code moves.
- References to tickets, PRs, or incidents without enough standalone explanation to be useful if the link 404s.
- Restating what the code obviously does. Comments should explain *why* — a non-obvious constraint, invariant, or gotcha — not narrate *what*.

If the "why" is genuinely about history (a workaround for a specific bug, an intentional deviation from an API's documented behavior), state the underlying constraint directly so the comment stands on its own.

## Before declaring a change done

Self-review against the original request:

- Did the change actually address what was asked, end-to-end?
- Are there obvious correctness issues (wrong identifiers, missing states, lost focus, leftover artifacts, dangling listeners)?
- Does it match project conventions (formatting, error handling, logging)?
- Does typecheck and lint still pass for the affected files?

This is meant to catch the kinds of small bugs that show up in iterative UI work — wrong icon names, modal focus loss, lingering states — before I have to.
