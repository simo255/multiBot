---
name: Create Bot
description: >-
  Use when the user asks multiBot to create, spawn, or design a new Grok Bot
  with Cursor CLI, grok-build CLI, or Google Antigravity CLI underground plus a custom purpose.
---
Create a focused Grok Bot teammate. Grok native orchestrates only; **all deep work** runs in a CLI subprocess.

## Before creating

Ask (question widget in 1:1; plain numbered options in a group):

1. **CLI backend:** `cursor` (`agent`), `grok-build` (`grok-agent`), or `antigravity` (`agy`)
2. **Purpose:** one sentence (e.g. calendar + email, code review, research)
3. **Name:** short bot name
4. **Extra constraints** (optional): MCP/plugins, tone, anti-jobs

Verify CLI on box:
```bash
export PATH="$HOME/.local/bin:$PATH"
command -v agent grok-agent agy
agent status 2>/dev/null || true
agy --version 2>/dev/null || true
```
Install if missing:
- Cursor: `curl -fsSL https://cursor.com/install | bash`
- Antigravity: `curl -fsSL https://antigravity.google/cli/install.sh | bash`

## Build the child description

Merge into `description` for CreateAgent:

1. **Purpose block** — user's job in 2–4 sentences
2. **Orchestration rules** — read `templates/orchestration-only.md` from multiBot repo if cloned at `/workspace/multiBot`; otherwise embed these rules:
   - Grok: ack → one CLI shell → relay
   - Never deep-dive on host (no long Read/Task chains)
   - All reasoning inside CLI subprocess
3. **CLI block** — cursor, grok-build, or antigravity command template + default models
4. **Anti-jobs** — what this bot must not do

Keep description under ~12k chars; put long reference paths in memory after create.

## CreateAgent

Use cursor namespace **CreateAgent**:
- `name`: user's chosen name
- `description`: merged blocks above

Save returned `agent_id`.

## After create — bootstrap the child

**SendToAgent** to the new id (priority if urgent):

```text
[t0u] First-run setup. Write CLI Worker skill from /workspace/multiBot/templates/cli-worker-skill.md (or embed orchestration-only rules). Confirm CLI auth. Reply: ready + default model id.
```

If multiBot repo is on box at `/workspace/multiBot`, tell child to read:
- `templates/orchestration-only.md`
- `templates/cli-worker-skill.md`

## Confirm to user

SendToUser: new bot name, id, CLI backend, purpose, and "open its chat to start."

## Examples

| User asks | CLI | Notes |
|-----------|-----|-------|
| "cursor bot for my calendar" | cursor | purpose = calendar; suggest Gmail/Calendar MCP in follow-up |
| "grok-build email assistant" | grok-build | purpose = email triage |
| "antigravity coding bot" | antigravity | `agy -p` + `--dangerously-skip-permissions` |
| "coding bot, composer fast" | cursor | easy intent = composer-2.5-fast in description |

Do not create bots without a clear purpose. Do not create duplicate bots for the same job.
