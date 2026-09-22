#!/bin/sh
# SessionStart hook: print the Linear rules into the session context, but only
# when the session's repo has a trebellar origin. Stdout from a SessionStart
# hook is added to Claude's context; printing nothing adds nothing.

origin=$(git -C "${CLAUDE_PROJECT_DIR:-.}" remote get-url origin 2>/dev/null) || exit 0

case "$origin" in
    *github.com[:/]trebellar/*) cat "$(dirname "$0")/../linear.md" ;;
esac
exit 0
