# OpenAI Codex CLI (`codex`)

Headless delegation from Grok Bot child bots.

## Install

```bash
npm install -g @openai/codex
# or see https://github.com/openai/codex
export PATH="$HOME/.local/bin:$PATH"
codex --version
```

## Auth

- `codex login` / OAuth → `~/.codex/auth.json`
- Or `OPENAI_API_KEY` in environment

## Headless (multiBot children)

```bash
export PATH="$HOME/.local/bin:$PATH"
codex exec --sandbox workspace-write "<full task prompt>"
```

Fully unattended (no approval prompts):

```bash
codex exec --sandbox danger-full-access "<full task prompt>"
```

With model:

```bash
codex exec -m "<model-id>" --sandbox workspace-write "<task>"
```

- `codex exec` (alias `codex e`) — non-interactive, exits when done
- **Requires a git repo** in `workdir` (or `git init` in a temp dir for scratch work)
- `-o /tmp/codex-last.txt` — write final message to file for parsing

## Default models (verify with `codex exec -c model=…` / account)

| Intent | Suggested |
|--------|-----------|
| default | account default / latest Codex model |
| smartest | higher-tier reasoning model on your plan |
| easy | faster/cheaper Codex variant |

Run `codex doctor` if auth or sandbox fails.
