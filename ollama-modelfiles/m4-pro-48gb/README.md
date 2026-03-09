# Ollama Models — MacBook Pro M4 Pro 48GB

## Hardware Budget

48GB unified memory, ~38–40GB usable after macOS overhead. Ollama swaps models on demand — only one is loaded at a time.

## Models

### qwen3-coder:30b — Coding (Cursor)

- **Use case:** Local coding assistant via Cursor (free tier, OpenAI-compatible API at `localhost:11434/v1`).
- **Why this model:** Best-in-class coding model that fits this hardware. MoE architecture (30B total, 3.3B active) keeps it efficient at ~19GB. Trained with execution-driven RL on SWE-bench for agentic coding workflows. Supports tool calling, which Cursor relies on.
- **Context window (32K):** Cursor sends focused context — current file, a few references, and conversation history — which typically fits within 10–20K tokens. 32K provides headroom without excessive memory use (~25GB total). The model supports 256K natively, but going higher adds KV cache pressure with little practical benefit for Cursor interactions.

### gpt-oss:20b — Brainstorming & Research (Open WebUI)

- **Use case:** General-purpose chat for quick brainstorming, comparison shopping, and research via Open WebUI with web search tools. Best for rapid idea generation and casual exploration.
- **Why this model:** At ~14GB, it's the lightest of the three, leaving the most headroom for macOS and other apps. MoE architecture (21B total, 3.6B active) means faster responses than Qwen3 32B. Benchmarks higher on aggregate scores despite being smaller (OpenAI RL training from o3 lineage). Supports tool calling for Open WebUI web search integration. Configurable reasoning effort (low/medium/high) lets you trade speed for depth per-question. For deeper research and complex multi-step analysis, consider swapping to Qwen3 32B — its dense architecture (32.8B active vs 3.6B) produces more nuanced, thorough responses on harder questions.
- **Context window (64K):** The model's light weight leaves ~24GB free, enough to support a larger KV cache. 64K takes advantage of this — useful for longer research conversations and document analysis. The model's native context is 128K, so 64K is well within its trained range.
- **Limitation:** Weaker on multilingual tasks. For conversations in Japanese or tasks requiring Japanese language production, use Qwen3 32B instead.

## Runtime Tips

- **KV cache quantization:** Set `OLLAMA_KV_CACHE_TYPE=q8_0` (requires `OLLAMA_FLASH_ATTENTION=1`) before starting Ollama to roughly halve KV cache memory with minimal quality loss. This allows pushing context windows higher if needed (e.g., qwen3-coder to 64K, gpt-oss to 128K).
- **Model swapping:** Ollama loads one model at a time and swaps on demand. Expect a few seconds of delay when switching between models.
