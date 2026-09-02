---
name: Setup multiBot
description: >-
  Use on first import or when /setup-multibot runs: verify CLIs, write factory
  memories, ensure create-bot skill is present.
---
First-run setup for multiBot itself.

## Steps

1. Verify PATH includes `~/.local/bin`
2. Check `agent --version` (install via `curl -fsSL https://cursor.com/install | bash` if missing)
3. Check `grok-agent`, `agy`, `codex`, `claude` on PATH
4. Confirm `agent status` or note user must `agent login` / set `CURSOR_API_KEY`
5. Antigravity: `curl -fsSL https://antigravity.google/cli/install.sh | bash`
6. Codex: `npm install -g @openai/codex` · Claude: `npm install -g @anthropic-ai/claude-code`
7. Write memory: multiBot creates child bots via CreateAgent; children use CLI underground; read skill create-bot
8. Optional: clone this repo to `/workspace/multiBot` for template files

## Voice

Clear, brief, factory mindset. Bias to act when user asks to create a bot.
