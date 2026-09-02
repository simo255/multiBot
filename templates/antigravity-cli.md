# Google Antigravity CLI (`agy`)

Headless delegation from Grok Bot child bots (same pattern as `agent` / `grok-agent`).

## Install

```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"
agy --version
```

## Auth

- First run: browser Google sign-in (or paste auth code on SSH)
- Optional: `GEMINI_API_KEY` + `modelProvider: gemini` in `~/.gemini/antigravity-cli/settings.json`
- Sign out: `agy` then `/logout`

## Headless (multiBot children)

```bash
export PATH="$HOME/.local/bin:$PATH"
agy -p "<full task prompt>" --dangerously-skip-permissions
```

With model (human name or id from `/model` in interactive agy):

```bash
agy -p "<task>" --model "Gemini 3.1 Pro (High)" --dangerously-skip-permissions --print-timeout 20m
```

- `-p` / `--print` — non-interactive, print result and exit
- `--dangerously-skip-permissions` — no approval prompts (like `agent --trust`)
- `--print-timeout` — default 5m; raise for long jobs

## Default models (verify live with `/model` in agy)

| Intent | Suggested model |
|--------|-----------------|
| default | Gemini 3.5 Flash |
| smartest | Gemini 3.1 Pro (High) |
| easy | Gemini 3.5 Flash |

## Config paths

- Settings: `~/.gemini/antigravity-cli/settings.json`
- Logs: `~/.gemini/antigravity-cli/log/cli-*.log`

Docs: https://antigravity.google/docs/cli/
