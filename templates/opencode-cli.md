# OpenCode CLI (`opencode`)

Terminal AI coding agent for headless delegation from Grok Bot child bots. Provider-agnostic — configure any supported model via `opencode auth login` (Anthropic, OpenAI, Google, **Z.AI GLM**, etc.).

## Install

```bash
curl -fsSL https://opencode.ai/install | bash
# or: npm install -g opencode-ai
export PATH="$HOME/.local/bin:$PATH"
opencode --version
```

## Auth

Login per provider (stored in `~/.local/share/opencode/auth.json`):

```bash
opencode auth login
# pick provider (Anthropic, OpenAI, Z.AI, Z.AI Coding Plan, …)
# paste API key when prompted
```

List credentials: `opencode auth list` · logout: `opencode auth logout`

OpenCode also loads keys from project `.env` or environment when configured.

### GLM / Z.AI (optional provider)

For GLM Coding Plan, pick **Z.AI Coding Plan** (global) or **Zhipu AI Coding Plan** (China) at login. Uses the Coding API endpoint (`/api/coding/paas/v4`). See https://docs.z.ai/devpack/quick-start

Helper: `npx @z_ai/coding-helper`

## Headless (multiBot children)

```bash
export PATH="$HOME/.local/bin:$PATH"
opencode run --auto -m "<provider>/<model>" "<full task prompt>"
```

Examples:

```bash
opencode run --auto "<task>"
opencode run --auto -m anthropic/claude-sonnet-4 "<task>"
opencode run --auto -m zai-coding-plan/glm-5.3-flash "<task>"
```

- `opencode run` — non-interactive; prints result and exits
- `--auto` — auto-approve permissions (like `agent --trust`)
- `-m provider/model` — from `opencode models`
- `-f path` — attach file(s) to the prompt
- `--format json` — raw JSON events for parsing

Long jobs / avoid cold start:

```bash
opencode serve --port 4096 &
opencode run --attach http://localhost:4096 --auto "<task>"
```

## Discover models

```bash
opencode models              # all configured providers
opencode models anthropic    # filter by provider
opencode models --refresh    # refresh cache
```

Model ids are always `provider/model`.

## Other useful commands

| Command | Use |
|---------|-----|
| `opencode agent list` | List agents |
| `opencode agent create` | Custom agent + permissions |
| `opencode mcp list` | MCP servers |
| `opencode session list` | Past sessions |
| `opencode stats` | Token / cost stats |

Interactive TUI (debug only — child bots use `run`):

```bash
opencode
# /models — switch model in session
```

## Default models (set per child in memory; verify with `opencode models`)

Pick `provider/model` for the auth you configured. Examples:

| Intent | Example (if using Z.AI GLM) | Example (if using Anthropic) |
|--------|----------------------------|------------------------------|
| default | `zai-coding-plan/glm-5.3-flash` | `anthropic/claude-sonnet-4` |
| smartest | `zai-coding-plan/glm-5.3` | `anthropic/claude-opus-4` |
| easy | `zai-coding-plan/glm-5.3-flash` | `anthropic/claude-haiku` |

## Config paths

- Auth: `~/.local/share/opencode/auth.json`
- Config: `~/.config/opencode/` or project `.opencode/`

Docs: https://opencode.ai/docs/cli
