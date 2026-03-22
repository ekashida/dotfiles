# ─── Claude Code + Ollama ──────────────────────────────────────────────
# All env vars are scoped to the subshell — your global ANTHROPIC_API_KEY
# and any existing Anthropic credentials are unaffected.
# ───────────────────────────────────────────────────────────────────────


function run_claude() {
  # Verify Ollama is actually running before handing off to Claude Code.
  # Avoids cryptic "model not found" errors when the daemon is down.
  if ! curl -sf http://localhost:11434 > /dev/null 2>&1; then
    echo "✗ Ollama is not running. Start it with: ollama serve" >&2
    return 1
  fi

  (
    # Route Claude Code to the local Ollama Anthropic-compatible endpoint.
    # Ollama v0.14+ implements the Anthropic Messages API natively — no proxy needed.
    export ANTHROPIC_BASE_URL="http://localhost:11434"

    # ANTHROPIC_AUTH_TOKEN is required by the Anthropic SDK but ignored by Ollama.
    # Any non-empty string works; "ollama" is the conventional placeholder.
    export ANTHROPIC_AUTH_TOKEN="ollama"

    # Explicitly clear the real API key so Claude Code cannot fall back to
    # Anthropic's cloud if Ollama returns an unexpected error or model-not-found.
    export ANTHROPIC_API_KEY=""

    # Suppresses telemetry, update checks, and — critically — the cloud MCP
    # server discovery fetch against api.anthropic.com/v1/mcp_servers.
    # Without this, Claude Code hangs indefinitely on startup when offline or
    # when no real API key is present, because the fetch has no timeout.
    export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1

    # Disable prompt caching. Ollama does not implement Anthropic's cache-control
    # headers and will return errors if Claude Code sends them.
    export DISABLE_PROMPT_CACHING=1

    # Without this, Ollama unloads the model from memory after each response and
    # you pay a cold-start penalty (~5–15s) on every single turn. -1 = indefinite.
    export OLLAMA_KEEP_ALIVE=-1

    # Allow Ollama to handle two concurrent requests. Required for Claude Code's
    # sub-agent spawning — without this, parent and child requests queue behind
    # each other and deadlock. Set higher if you run multiple Zed windows.
    export OLLAMA_NUM_PARALLEL=2

    # Small/fast model used for background tasks: file triage, context
    # summarization, lightweight lookups.
    export ANTHROPIC_SMALL_FAST_MODEL="qwen2.5-coder:7b"

    claude "$@"
  )
}

function claude-devstral() {
  (
    # Primary model: your 64k-context devstral variant.
    export ANTHROPIC_MODEL="devstral-24b-64k-claude:latest"

    run_claude "$@"
  )
}

function claude-qwen() {
  (
    export ANTHROPIC_MODEL="qwen3.5-35b-64k-claude:latest"

    run_claude "$@"
  )
}

