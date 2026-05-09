# Personal Working Preferences

These apply to all my Claude Code sessions. Project-level `CLAUDE.md` files can override or extend anything below.

## Collaboration style

- Engage as a peer. Push back when you disagree with my reasoning, and expect me to push back on yours. When I push back, engage with the substance — don't just capitulate.
- If you're not sure about something, say so explicitly rather than guessing confidently.
- Be concise. Explanations alongside edits are welcome; filler and excessive caveats are not.

## Before acting

- For implementation tasks, if I haven't named a target file, ask before launching broad codebase searches or sub-agent calls. Don't default to deep context-gathering on small, scoped requests.
- Don't create plan, notes, or scratch files (e.g., `PLAN.md`, `NOTES.md`, `TODO.md`) unless I explicitly ask. Keep planning in the conversation, and use plan mode when you want me to approve a plan before you act on it.
- For changes that touch more than one concern, propose a plan with clean, independently-mergeable PR boundaries before editing.

## Verifying claims about frameworks

When asserting how a framework or tool behaves (Lit, Fastify, AI SDK, oxfmt, Shoelace, etc.), verify against the docs or source for the *installed* version rather than relying on memory or analogy. Don't infer config from similar tools — e.g., don't assume oxfmt's defaults match Prettier's. When in doubt, read from `node_modules/` or the lockfile to confirm.

## Git

- Before first-pushing a branch, if the local branch name isn't already prefixed with `ekashida/` (and isn't `master`/`main`), rename it: `git branch -m ekashida/<name>`. Push the renamed branch — don't push under one name and rewrite to another, since the local/remote mismatch confuses tooling.
- A global `pre-push` hook (`~/repos/dotfiles/git/hooks/pre-push`) enforces the `ekashida/` prefix. If a push fails the hook, fix the branch name rather than bypassing — don't use `--no-verify` without asking.

## Before declaring a change done

Self-review against the original request:

- Did the change actually address what was asked, end-to-end?
- Are there obvious correctness issues (wrong identifiers, missing states, lost focus, leftover artifacts, dangling listeners)?
- Does it match project conventions (formatting, error handling, logging)?
- Does typecheck and lint still pass for the affected files?

This is meant to catch the kinds of small bugs that show up in iterative UI work — wrong icon names, modal focus loss, lingering states — before I have to.
