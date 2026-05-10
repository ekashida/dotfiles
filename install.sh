#!/usr/bin/env bash
# Idempotent setup for a new machine. Re-runnable; backs up real files
# that would be overwritten and replaces stale symlinks in place.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$1" dst="$2"

    if [ -L "$dst" ]; then
        if [ "$(readlink "$dst")" = "$src" ]; then
            echo "ok:      $dst"
            return
        fi
        echo "replace: $dst (was -> $(readlink "$dst"))"
        rm "$dst"
    elif [ -e "$dst" ]; then
        local backup="$dst.bak.$(date +%s)"
        echo "backup:  $dst -> $backup"
        mv "$dst" "$backup"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "link:    $dst -> $src"
}

# Claude Code config
link "$DOTFILES/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link "$DOTFILES/claude/agents"    "$HOME/.claude/agents"
link "$DOTFILES/claude/commands"  "$HOME/.claude/commands"

# Git (gitconfig pulls in core.hooksPath itself)
link "$DOTFILES/git/gitconfig"        "$HOME/.gitconfig"

# SSH
link "$DOTFILES/ssh/config"           "$HOME/.ssh/config"

echo "done."
