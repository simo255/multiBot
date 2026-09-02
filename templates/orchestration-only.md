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

**OpenAI Codex CLI:**
```bash
export PATH="$HOME/.local/bin:$PATH"
codex exec --sandbox workspace-write "<full task prompt>"
```
Unattended: `--sandbox danger-full-access`. Requires git repo in cwd. See `templates/codex-cli.md`.

**Claude Code CLI:**
```bash
export PATH="$HOME/.local/bin:$PATH"
claude -p "<full task prompt>" --dangerously-skip-permissions --max-turns 25
```
See `templates/claude-code-cli.md`.

**OpenCode CLI:**
```bash
export PATH="$HOME/.local/bin:$PATH"
opencode run --auto -m <provider>/<model> "<full task prompt>"
```
Install: `curl -fsSL https://opencode.ai/install | bash`. Auth: `opencode auth login`. List models: `opencode models`. Can use GLM via Z.AI provider. See `templates/opencode-cli.md`.

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

**Codex** (account / `-m` flag):

| Intent | Model |
|--------|-------|
| default | latest Codex on plan |
| smartest | strongest Codex reasoning tier |
| easy | faster Codex variant |

**Claude Code** (`claude --model` / plan):

| Intent | Model |
|--------|-------|
| default | claude-sonnet (latest) |
| smartest | claude-opus / opus thinking |
| easy | haiku / fast tier |

**OpenCode** (`opencode models`; depends on configured provider):

| Intent | Example (Z.AI GLM) | Example (Anthropic) |
|--------|--------------------|---------------------|
| default | zai-coding-plan/glm-5.3-flash | anthropic/claude-sonnet-4 |
| smartest | zai-coding-plan/glm-5.3 | anthropic/claude-opus-4 |
| easy | zai-coding-plan/glm-5.3-flash | anthropic/claude-haiku |
