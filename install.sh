#!/usr/bin/env bash
# Install multiBot workflows + templates onto a Grok Bot sand box.
#   curl -fsSL https://raw.githubusercontent.com/simo255/multiBot/main/install.sh | bash
set -euo pipefail

REPO="${MULTIBOT_REPO:-https://github.com/simo255/multiBot.git}"
REF="${MULTIBOT_REF:-main}"
INSTALL_ROOT="${MULTIBOT_ROOT:-/workspace/multiBot}"
SAND_WORKFLOWS="${SAND_DATA:-/home/box/sand-data}/workflows"

log() { printf 'multibot: %s\n' "$*"; }

if [[ -f "${BASH_SOURCE[0]:-}" && -d "$(dirname "${BASH_SOURCE[0]}")/workflows" ]]; then
  SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  log "Installing from local checkout: $SRC"
else
  log "Cloning $REPO @ $REF -> $INSTALL_ROOT"
  rm -rf "$INSTALL_ROOT"
  git clone --depth 1 --branch "$REF" "$REPO" "$INSTALL_ROOT"
  SRC="$INSTALL_ROOT"
fi

mkdir -p "$SAND_WORKFLOWS/create-bot" "$SAND_WORKFLOWS/setup-multibot"
cp -f "$SRC/workflows/create-bot/SKILL.md" "$SAND_WORKFLOWS/create-bot/SKILL.md"
cp -f "$SRC/workflows/setup-multibot/SKILL.md" "$SAND_WORKFLOWS/setup-multibot/SKILL.md"

log "Workflows -> $SAND_WORKFLOWS/{create-bot,setup-multibot}/"
log ""
log "Next:"
log "  1. Create a Grok Bot named multiBot (see import/profile.json)"
log "  2. In chat run: /setup-multibot"
log "  3. Say: create a cursor CLI bot that manages my calendar"
log ""
log "Templates: $SRC/templates/"
