# Claude Code CLI (`claude`)

Headless delegation from Grok Bot child bots.

## Install

```bash
npm install -g @anthropic-ai/claude-code
export PATH="$HOME/.local/bin:$PATH"
claude --version
```

## Auth

- Interactive once: `claude` → browser OAuth (Pro/Max)
- API key: `export ANTHROPIC_API_KEY=…` or `claude auth login --console`
- Check: `claude auth status`

## Headless (multiBot children) — preferred

```bash
export PATH="$HOME/.local/bin:$PATH"
claude -p "<full task prompt>" --max-turns 25
```

Unattended tools (like `agent --trust`):

```bash
claude -p "<task>" --dangerously-skip-permissions --max-turns 25
```

Scoped tools:

```bash
claude -p "<task>" --allowedTools "Read,Edit,Bash" --max-turns 15
```

- `-p` / `--print` — non-interactive; skips trust/permission dialogs
- `--max-turns` — cap agent loop (required for automation)

## Default models (verify with `claude --model` / plan)

| Intent | Suggested |
|--------|-----------|
| default | claude-sonnet (latest on plan) |
| smartest | claude-opus or opus thinking |
| easy | claude-haiku / fast variant |

Docs: https://code.claude.com/docs/en/cli-reference
