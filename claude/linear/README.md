# Linear workflow (Trebellar)

How my Trebellar work stays visible in Linear. The goal: anyone at Trebellar, including a PM,
can see from Linear what I'm working on, and issues close roughly daily.

## Pieces

| Piece | Where | What it does |
|---|---|---|
| Rules | `rules.md` (this dir) | What Claude follows in Trebellar sessions: when to create an issue, how to write it, which properties to set, when to move it to In Progress. |
| Rules loader | `../hooks/trebellar-context.sh`, registered by `install.sh` | SessionStart hook that prints `rules.md` into the session when the repo's `origin` is under `github.com/trebellar/`. Stays silent everywhere else. |
| Branch-name guard | `../../git/hooks/pre-push` | Rejects a push of a new branch to a trebellar remote unless the name has a `prd-`/`gtm-` issue ID, which is what links the PR to the issue. |
| Git automations | Linear → Product team settings → Issue statuses & automations | Moves a linked issue to In Review when its PR opens and to Done when it merges. **Lives only in the Linear UI; configured per team.** |

## Who moves each status

| Transition | Owner |
|---|---|
| → Queued / Backlog | Set when the issue is created (rules) |
| → In Progress | Claude, when implementation starts (rules) |
| → In Review, → Done | Linear git automations |
| → Deployed | Manual. Automating it needs a reliable "what's in prod" signal: the app release in Cloud Deploy, and the worker, which ships separately through `trebellar/workflows`. |

Moves only go forward. Nothing here moves an issue backwards.

## Linking

Linear links a PR to an issue when the issue ID is in the branch name (`ekashida/fix/prd-813-…`
works), or when a magic word precedes the ID in the PR title or body. A closing word (`Fixes
PRD-123`) makes the merge close the issue. A contributing word (`Part of PRD-123`) links the PR
without closing the issue.

## When something doesn't move

1. Check that the issue has the PR attached in Linear. If not, the branch name or magic word
   didn't match.
2. Check the team's git automations in Linear settings.
