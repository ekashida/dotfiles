# dotfiles

Personal config repo. Layout:

- `claude/` — Claude Code config. Symlinked into `~/.claude/`. Editing files here is the same as editing in `~/.claude/`.
- `git/gitconfig` — Symlinked to `~/.gitconfig`. Sets `core.hooksPath` to `git/hooks/` (so pulling new hooks is enough — no extra wiring) and includes `git/gitconfig.delta` (delta pager config).
- `git/hooks/` — Global git hooks. The `pre-push` hook enforces the `ekashida/` branch prefix.
- `ssh/config` — Symlinked to `~/.ssh/config`.
- `zsh/` — `zshrc` and `zprofile`, symlinked to `~/.zshrc` and `~/.zprofile`. PATH/env mutations go in `zprofile`; interactive-shell config goes in `zshrc`.
- `modelfiles/` — Ollama modelfiles.
- `install.sh` — Idempotent setup for a new machine. Re-run after pulling. Backs up real files in the way with a timestamped `.bak` suffix.

## Conventions

- New shell helpers go in `zsh/zshrc` (interactive config) or `zsh/zprofile` (PATH/env).
- New global git hooks go in `git/hooks/`.
- New Claude agents/commands go under `claude/agents/` or `claude/commands/` — the symlink means they're live immediately, no install step.
- If you add a new top-level config that needs symlinking, add a `link` line to `install.sh`.
