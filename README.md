# multiBot

**Grok Bot factory** — spawn teammates with **CLI underground** (Cursor `agent`, grok-build `grok-agent`, or Google **Antigravity `agy`**) + a custom purpose. Grok native **orchestrates only**; all deep work runs in the CLI subprocess.

Inspired by the eggbot + Cursor-CLI-delegation pattern.

## Quick start (Grok Bot box)

```bash
git clone https://github.com/simo255/multiBot.git
cd multiBot && ./install.sh
```

1. Create a new Grok Bot named **multiBot** (copy description from [`import/profile.json`](import/profile.json))
2. Chat: **`/setup-multibot`**
3. Chat: *"Create a Cursor CLI bot that manages my calendar and email"*

multiBot asks CLI type + purpose → **CreateAgent** → bootstraps the child.

## Architecture

```text
You → multiBot (Grok orchestration)
         → CreateAgent
         → child bot (purpose + CLI rules in description)
              → Grok: ack → shell agent | grok-agent | agy → relay
              → CLI: all reasoning & tools
```

| Layer | Role |
|-------|------|
| Grok native | Thin coordinator only |
| Cursor `agent` | Cursor subscription / API key |
| grok-build `grok-agent` | Grok build CLI quota |
| Google Antigravity `agy` | Google / Gemini (see agy `/usage`) |

## Child bot rules

See [`templates/orchestration-only.md`](templates/orchestration-only.md) — embedded in every created bot.

## Repo layout

| Path | Purpose |
|------|---------|
| `import/profile.json` | multiBot profile stub |
| `workflows/create-bot/` | `/create-bot` skill |
| `workflows/setup-multibot/` | `/setup-multibot` first-run |
| `templates/orchestration-only.md` | Grok-thin / CLI-heavy rules |
| `templates/cli-worker-skill.md` | Default child bot skill |
| `templates/antigravity-cli.md` | Antigravity install + headless flags |
| `install.sh` | Copy workflows to `sand-data/workflows/` |

## Requirements

- Grok Bot with **CreateAgent** (cursor namespace)
- Cursor CLI: `curl -fsSL https://cursor.com/install | bash`
- Antigravity CLI: `curl -fsSL https://antigravity.google/cli/install.sh | bash`
- grok-build: `grok-agent` on PATH

## Contributing

PRs welcome — [CONTRIBUTING.md](CONTRIBUTING.md)

## License

MIT
