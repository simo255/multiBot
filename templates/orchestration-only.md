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

**Google Antigravity CLI:**
```bash
export PATH="$HOME/.local/bin:$PATH"
agy -p "<full task prompt>" --model "<model-name>" --dangerously-skip-permissions --print-timeout 20m
```
Install: `curl -fsSL https://antigravity.google/cli/install.sh | bash`. See `templates/antigravity-cli.md`.

Pass the **entire** job in the CLI prompt. Do not split reasoning across Grok and CLI.

## Default models (override in memory; verify live)

**Cursor** (`agent models`):

| Intent | Model |
|--------|-------|
| default | cursor-grok-4.6-high |
| smartest | claude-fable-5-1-thinking-high |
| easy | composer-2.5-fast |

**Antigravity** (`/model` in interactive agy):

| Intent | Model |
|--------|-------|
| default | Gemini 3.5 Flash |
| smartest | Gemini 3.1 Pro (High) |
| easy | Gemini 3.5 Flash |
