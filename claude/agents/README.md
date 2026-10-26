# Agent definitions — model resolution

Facts verified by probe (July 2026; re-verified 2026-09-22), for anyone editing the agent
files in this directory:

- **Definitions are snapshotted at session start.** Editing a file here does not affect
  the running session — pins and prompt changes apply from the next session.
- **Model resolution order** for a spawned agent: per-call `model` param (ignored for
  `fork`, which always inherits) → the definition's `model:` frontmatter → inherit the
  session model. A user-level file here shadows a built-in agent of the same name,
  frontmatter and system prompt both.
- **Built-in defaults** (no shadow present): `Explore` pins Opus fast, `statusline-setup`
  pins Sonnet; `general-purpose`, `Plan`, and `claude` inherit the session model. Exact
  IDs move with each model release (the Sept probe saw `claude-opus-5[1m]` for the
  `general-purpose` shadow; on 2026-10-24 it reported `claude-opus-5-5`), so record the
  alias each agent resolves to and re-probe when the exact ID matters. The ID is identical
  with and without fast output, so a probe confirms the model but never the "fast" half of
  the `Explore` pin. Tell a pin from inheritance by keeping the orchestrator model distinct
  from the expected pin (see pitfalls), not by an ID suffix: the `[1m]` suffix that
  separated them in the Sept probe was absent on 2026-10-24.
- `general-purpose.md` exists here to pin opus — without it, general-purpose subagents
  run the session model (e.g. Fable). An `Explore` shadow was tried and deleted: the
  built-in already avoids the session model, and shadowing replaces its tuned prompt
  and broader toolset.

To verify a pin, run a headless probe with the orchestrator model set to something
distinct from the expected pin:

```sh
claude --model claude-fable-5-1 -p 'Spawn a subagent with subagent_type "<name>" and this
exact prompt: "Report the exact model ID you are running as, per the environment info in
your system prompt. Reply with only the model ID string. Do not run any tools." Then
reply with only what it returned.'
```

Probe pitfalls — each of these produces a confident wrong answer, not an error:

- Keep the orchestrator model distinct from the expected pin, or inheritance and the
  pin are indistinguishable in the result.
- Probe from a fresh session after any edit here — an in-session probe reflects the
  session-start snapshot and will "disprove" a pin that works.
- Headless (`claude -p`) sessions can't read outside their cwd without permission
  flags; a probe whose trigger depends on such a read fails silently and reports the
  no-op result as if it ran.
- Prefer observing your own context directly over asking a probe model to self-report
  what's in its context; treat a single surprising self-report as unconfirmed.
- All of this is undocumented harness behavior — re-verify after major Claude Code
  updates before relying on it.
