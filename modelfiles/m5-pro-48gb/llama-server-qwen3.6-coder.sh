#!/bin/zsh
# ============================================================
# llama-server launcher — Qwen3.6-35B-A3B (Unsloth UD-Q6_K_XL)
# M5 Pro, 48GB unified memory — primary agentic coding driver
#
# Serves an OpenAI-compatible API on http://127.0.0.1:8080.
# Pairs with Modelfile.qwen3.6-35b-a3b-q6-128k in this directory
# (that Modelfile is how the GGUF gets *downloaded*; this script
# is how it gets *served*).
#
# Usage:
#   ./llama-server-qwen3.6-coder.sh          # blocks; ^C to stop
#   pi --offline --provider llamacpp --model qwen3.6-coder-llamacpp
#
# Stop:  pkill -f "llama-server -m"
# ============================================================

# ── Why llama-server and not Ollama ─────────────────────────
#
# Both runtimes can serve this exact GGUF, so a head-to-head is
# a pure runtime comparison. Measured 2026-08-26 on this machine,
# same blob, same task:
#
#                                 llama-server   Ollama
#   3-turn edit task (~2.5k ctx)         65s      105s
#   cold prefill @43k tokens            183s      225s
#   warm follow-up @45k tokens          5.8s       19s
#
# The last row decides an agentic loop — it's what most turns
# actually are — and it's a 3.3x gap. This is also the runtime
# the proven 37.8% Terminal-Bench 2.0 config used (pim-agent,
# github.com/AaronCQL/pim-agent), so the flags below are that
# config verbatim rather than a local invention.
#
# Ollama is NOT retired: qwen3.8-thinker exists only as nvfp4,
# an Ollama-only format, so the second-opinion model still lives
# there. Ollama lost as the primary driver, not as part of the stack.

# ── Prerequisite: GPU wired-memory limit ────────────────────
#
# This model loads to ~33GB, which exceeds macOS's default Metal
# wired limit (~75% of RAM). Without the raise it spills off the
# GPU and generation crawls. NOT persistent — re-run after every
# reboot:
#
#   sudo sysctl iogpu.wired_limit_mb=45056
#
# Verify you got it: `ollama ps` (or Activity Monitor) should show
# 100% GPU, not a CPU split. Note sudo cannot read a password
# through Claude Code's `!` prefix — use a real terminal, or:
#   osascript -e 'do shell script "/usr/sbin/sysctl iogpu.wired_limit_mb=45056" \
#     with administrator privileges'

set -e

# Resolve the GGUF from Ollama's blob store rather than hardcoding a
# sha256 path, which would rot on any re-pull. llama-server reads the
# blob directly — Ollama is just the delivery mechanism and does not
# need to be running to serve it.
BLOB=$(ollama show qwen3.6-coder --modelfile 2>/dev/null | grep -E '^FROM' | head -1 | awk '{print $2}')
[ -f "$BLOB" ] || {
    echo "GGUF blob not found. Expected it via: ollama show qwen3.6-coder --modelfile"
    echo "Got: '$BLOB'"
    echo "If the model is missing, rebuild it:"
    echo "  ollama pull hf.co/unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q6_K_XL"
    echo "  ollama create qwen3.6-coder -f Modelfile.qwen3.6-35b-a3b-q6-128k"
    exit 1
}
echo "model: $BLOB"

# Slot save/restore directory. NOTE: --slot-save-path only *exposes* the
# save/restore endpoints; it does not persist anything on its own. A
# harness has to call them, and pi does not. So the KV reuse below is
# llama-server's in-memory prefix cache: it survives turns within one
# server lifetime, but NOT a restart. Practical consequence — budget one
# ~180s cold prefill per server start, not per prompt. Start it once and
# keep the session alive rather than restarting between tasks.
mkdir -p /tmp/llama-slots

# 30GB will not fit twice in 48GB. If Ollama still holds this model,
# you measure swap pressure instead of the runtime. Harmless if not loaded.
ollama stop qwen3.6-coder 2>/dev/null || true

# Flags are the pim-agent Terminal-Bench config verbatim. Notes:
#   -c 131072       proven agentic sweet spot; native is 262144 but
#                   prefill cost grows with what you actually fill.
#                   Measured: prefill decays 450 tok/s @2.5k → 241 @43k,
#                   generation 27 → 16.5 tok/s. Depth is the cost, not tok/s.
#   --cache-type-*  q8_0 both halves. Do NOT go lower.
#   --temp 0.6 ...  Qwen's published thinking-mode coding preset. Not greedy:
#                   Qwen advises against temp 0 (repetition loops). Expect real
#                   run-to-run variance as a result — a differing rerun is not
#                   a regression.
#   --repeat-penalty 1.0  neutral on purpose; penalising repeats hurts
#                   legitimate identifier reuse in code. Qwen pins this
#                   at 1.0 in every published preset — leave it.
#   --presence-penalty 1.5  Qwen's coding preset says 0.0, but its docs
#                   name presence_penalty (range 0-2) as the control for
#                   endless repetitions, and its other two presets ship
#                   1.5. Raised here against circular reasoning loops.
#                   Qwen warns high values can cause occasional language
#                   mixing and slightly weaker output; drop toward 1.0 if
#                   that shows up.
#   --jinja         already the default in llama.cpp 0.3.0; kept for parity
#                   with the reference config.
#   --reasoning-budget 4096  caps thinking so it commits to a tool call.
#                   The reference config uses 16384. Lowered here against
#                   a thinking-loop failure that it did NOT resolve, so the
#                   loop has some other cause — don't read 4096 as a fix.
#   -np 1           single slot, so the whole KV cache serves one session.
exec llama-server -m "$BLOB" \
    -c 131072 -ngl 99 --slot-save-path /tmp/llama-slots \
    --flash-attn on --cache-type-k q8_0 --cache-type-v q8_0 \
    --jinja --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.0 \
    --presence-penalty 1.5 --repeat-penalty 1.0 \
    --reasoning-budget 4096 \
    --reasoning-budget-message "Alright, I've thought enough. Let me take the next concrete step now — either a tool call or a final answer — and refine based on what I learn." \
    -np 1 \
    --host 127.0.0.1 --port 8080
