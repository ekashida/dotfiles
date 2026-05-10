---
description: Group outstanding changes into atomic commits, push, and open a PR
---

Wrap up outstanding work on the current branch into a clean PR.

## 1. Survey

Run these in parallel:

- `git status`
- `git diff` and `git diff --staged`
- `git log --oneline @{upstream}..HEAD 2>/dev/null || git log --oneline master..HEAD` — commits already made on this branch but not yet on master.
- `git branch --show-current`
- `gh pr list --head "$(git branch --show-current)" --json number,url --jq '.[]' 2>/dev/null` — does a PR already exist for this branch?

Stop early and report if:

- No uncommitted changes **and** no unpushed commits → "nothing to do".
- Current branch is `master` or `main` → refuse; tell me to create a feature branch first.
- A PR already exists → show me the URL and ask whether to push additional commits onto it or stop.

## 2. Propose a plan

Group the uncommitted changes into one or more **atomic** commits — one concern per commit, not one file per commit. If existing unpushed commits already look clean, leave them alone (mention them, don't reorganize unless they're clearly wrong).

For each proposed commit, list:

- The files / hunks it covers.
- A draft message — **terse**, lowercase, imperative or short noun phrase, matching the project's existing `git log --oneline` style. Look at the recent log for cues. **Never include a `Co-Authored-By` trailer.**

Also propose:

- A renamed branch if the current name isn't prefixed with `ekashida/` (and isn't `master` / `main`). Pick a descriptive slug.
- A PR title under 70 chars.
- A PR body with a `## Summary` section, plus a `## Test plan` section if the change warrants one.

Show me the full plan as a numbered checklist. **Pause and wait for me to approve or edit it. Do not proceed until I say go.**

## 3. Execute

Once approved, in order:

1. Rename the branch if needed: `git branch -m ekashida/<name>`.
2. Stage and create each commit. Use a HEREDOC for multi-line messages so the formatting survives.
3. Push with `git push -u origin HEAD`.
4. Create the PR with `gh pr create --title "..." --body "$(cat <<'EOF' ... EOF)"`.
5. Return the PR URL.

If the pre-push hook rejects the push, fix the branch name and retry. **Don't bypass with `--no-verify`.**
