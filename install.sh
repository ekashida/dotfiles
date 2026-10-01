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

# Add a command hook to ~/.claude/settings.json unless one already runs a
# script with the same path suffix. settings.json is merged, not linked,
# because Claude Code rewrites it on /model, /config, etc.
claude_hook() {
    local event="$1" script="$2"
    local settings="$HOME/.claude/settings.json"

    if ! command -v jq >/dev/null; then
        echo "skip:    $event hook $script (jq not installed)"
        return
    fi

    mkdir -p "$(dirname "$settings")"
    [ -e "$settings" ] || echo '{}' > "$settings"

    local suffix="${script#"$DOTFILES"}"
    if jq -e --arg ev "$event" --arg sfx "$suffix" \
        '[.hooks[$ev][]?.hooks[]?.command | select(endswith($sfx))] | length > 0' \
        "$settings" >/dev/null; then
        echo "ok:      $event hook $script"
        return
    fi

    local tmp
    tmp="$(mktemp)"
    jq --arg ev "$event" --arg cmd "$script" \
        '.hooks[$ev] = ((.hooks[$ev] // []) + [{hooks: [{type: "command", command: $cmd}]}])' \
        "$settings" > "$tmp"
    cat "$tmp" > "$settings"   # keeps the file's permissions, unlike mv from mktemp
    rm "$tmp"
    echo "hook:    $event -> $script"
}

# Claude Code config
link "$DOTFILES/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link "$DOTFILES/claude/agents"    "$HOME/.claude/agents"
link "$DOTFILES/claude/commands"  "$HOME/.claude/commands"
claude_hook SessionStart "$DOTFILES/claude/hooks/trebellar-context.sh"

# Scripts
link "$DOTFILES/bin/codex-review"     "$HOME/.local/bin/codex-review"

# Zsh
link "$DOTFILES/zsh/zshrc"            "$HOME/.zshrc"
link "$DOTFILES/zsh/zprofile"         "$HOME/.zprofile"

# Git (gitconfig pulls in core.hooksPath itself)
link "$DOTFILES/git/gitconfig"        "$HOME/.gitconfig"

# SSH (ssh expects ~/.ssh to be 0700; link()'s bare mkdir would leave it 0755)
mkdir -p -m 700 "$HOME/.ssh"
link "$DOTFILES/ssh/config"           "$HOME/.ssh/config"

echo "done."
