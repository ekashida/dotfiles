#!/bin/bash
# Reconciles my Linear issue statuses against GitHub PRs and local branches, and
# appends a "## Linear" section to the summary file given as $1.
# Linear's git automations own In Review/Done; this is the backstop for missed
# webhooks and manual drift, plus a report of issues that need a human decision.
set -uo pipefail

OUT_FILE="$1"
CLAUDE_BIN="$HOME/.local/bin/claude"
GH=/opt/homebrew/bin/gh
FRONTEND_REPO="$HOME/repos/frontend"
SINCE=$(date -v-7d +%Y-%m-%d)
# LINEAR_DRY_RUN=1 withholds the write tool and reports moves as "Would move".
TOOLS="mcp__claude_ai_Linear__list_issues mcp__claude_ai_Linear__get_issue mcp__claude_ai_Linear__save_issue"
DRY_RUN_NOTE=""
DENY="none"
if [ "${LINEAR_DRY_RUN:-0}" = 1 ]; then
    TOOLS="mcp__claude_ai_Linear__list_issues mcp__claude_ai_Linear__get_issue"
    # Global settings may allow save_issue, so deny it explicitly.
    DENY="mcp__claude_ai_Linear__save_issue"
    DRY_RUN_NOTE=" DRY RUN: do not call save_issue; title the moves subsection \"### Would move\" instead."
fi

DATA=$(mktemp)
trap 'rm -f "$DATA"' EXIT

{
    echo "TODAY: $(date +%Y-%m-%d)"
    echo
    echo "MY PULL REQUESTS (open, or updated since $SINCE), per repo:"
    REPOS=$("$GH" search prs --author @me --owner trebellar --updated ">=$SINCE" \
        --json repository --jq '.[].repository.nameWithOwner' --limit 200 | sort -u)
    for repo in $REPOS; do
        echo "--- $repo"
        "$GH" pr list --repo "$repo" --author @me --state all --search "updated:>=$SINCE" \
            --json number,title,state,isDraft,headRefName,createdAt,mergedAt,updatedAt,body,url --limit 100
    done
    echo
    echo "LOCAL BRANCHES in trebellar/frontend naming an issue (branch, last commit date):"
    git -C "$FRONTEND_REPO" for-each-ref --format='%(refname:short) %(committerdate:short)' refs/heads \
        | grep -iE '(prd|gtm)-[0-9]+'
} > "$DATA" 2>&1

PROMPT='You reconcile my Linear issue statuses. Stdin has TODAY, my recent GitHub pull requests (JSON per repo) and my local branches.

1. Call mcp__claude_ai_Linear__list_issues with assignee "me", updatedAt "-P60D", limit 100, fields [id, title, status, statusType, team, updatedAt]. Keep issues whose status is Backlog, Queued, In Progress or In Review. For each, call mcp__claude_ai_Linear__get_issue to read its description and attachments.

2. An issue'"'"'s linked PRs are its GitHub PR attachments. A linked PR is "closing" if its branch names the issue, or its title or body has the issue ID right after close(s/d), fix(es/ed), resolve(s/d), complete(s/d) or implement(s/ed). It is "contributing" if the ID appears only after ref, references, part of, related to, contributes to, towards or updates. Otherwise (attached by hand, or the ID appears with no keyword) it is "unclassified". A branch names an issue if it contains the ID case-insensitively with no digit after it (prd-81 does not match prd-813).

3. Apply these moves with mcp__claude_ai_Linear__save_issue, changing only the state, only for team Product, and never moving an issue backwards (order: Backlog, Queued, In Progress, In Review, Done):
   - Done: it has at least one closing PR, every linked PR is closing and merged, and its description has no unchecked "- [ ]" box.
   - In Review: a linked PR is open and not a draft.
   - In Progress: status is Backlog or Queued, it has no merged or open non-draft linked PR, and it has an open draft PR or a local branch naming it with a commit in the last 7 days.

4. Report without changing anything:
   - Issues whose closing PRs are all merged but which still have unchecked boxes (quote the boxes).
   - Issues whose linked PRs are all merged but some are contributing or unclassified: done, or more work coming?
   - In Progress or In Review issues with no PR update and no branch commit in the last 3 days.
   - My PRs created since yesterday that link to no issue (no issue ID in the branch name, title or body).
   - Issues outside team Product that qualify for a move in step 3 (their statuses differ; do not move them).

Output only markdown, starting with the heading "## Linear". Under "### Moved", list each move as "ID title: old → new (reason)". Under "### Needs attention", list the step 4 findings with the issue ID or PR URL. Omit an empty subsection; if both are empty, write "Nothing to reconcile." Do not modify anything other than issue state.'"$DRY_RUN_NOTE"

if ! "$CLAUDE_BIN" -p "$PROMPT" --model opus \
    --allowedTools "$TOOLS" --disallowedTools "$DENY" \
    < "$DATA" > "$OUT_FILE.linear.tmp" 2>>"$(dirname "$OUT_FILE")/.launchd.err.log"; then
    printf '\n## Linear\n\nReconciliation failed; see .launchd.err.log in this directory.\n' >> "$OUT_FILE"
    rm -f "$OUT_FILE.linear.tmp"
    exit 1
fi
printf '\n' >> "$OUT_FILE"
cat "$OUT_FILE.linear.tmp" >> "$OUT_FILE"
rm -f "$OUT_FILE.linear.tmp"
