# Orchestration-only rules (embed in every child bot)

Grok native is a **thin coordinator**. The CLI subprocess does **all** reasoning, tools, and deep work.

## Grok turn (host) — allowed

- Acknowledge the user (one short SendToUser)
- Pick CLI intent / model if needed
- **One** shell invocation to the configured CLI with the full task prompt
- Read CLI stdout and relay a concise result to the user

## Grok turn — forbidden

- Long tool chains (Read, grep, Task, MCP) for work the CLI should do
- Inline analysis, coding, email/calendar actions without CLI
- Task subagents for jobs that belong in the CLI
- More than ~3 host tool rounds before CLI delegation

## CLI delegation (required for real work)

**Cursor CLI:**
```bash
export PATH="$HOME/.local/bin:$PATH"
agent -p --trust --model <model-id> "<full task prompt including context>"
```

**grok-build CLI:**
```bash
export PATH="$HOME/.local/bin:$PATH"
grok-agent -p --trust --model <model-id> "<full task prompt>"
```
(Use `grok-agent` or the grok-build binary installed on the box; verify with `command -v grok-agent agent`.)

Pass the **entire** job in the CLI prompt. Do not split reasoning across Grok and CLI.

## Default Cursor routes (override in memory after setup)

| Intent | Model |
|--------|-------|
| default | cursor-grok-4.6-high |
| smartest | claude-fable-5-1-thinking-high |
| easy | composer-2.5-fast |

Run `agent models` live before hardcoding ids.
