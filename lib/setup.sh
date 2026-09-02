#!/usr/bin/env bash
# multiBot setup: Cursor CLI + Intent→Model routes.
set -euo pipefail

CONFIG_DIR="${MULTIBOT_CONFIG_DIR:-$HOME/.config/multibot}"
ROUTES_FILE="$CONFIG_DIR/routes.json"
AGENT_BIN="${CURSOR_AGENT_BIN:-}"

usage() {
  cat <<'EOF'
Usage: multibot setup (or multibot --setup)

Install / verify Cursor CLI, check auth, write Intent → Model routes.

Environment:
  MULTIBOT_CONFIG_DIR   Config dir (default: ~/.config/multibot)
  CURSOR_API_KEY        Optional API key auth
EOF
}

log() { printf 'multibot: %s\n' "$*"; }
die() { printf 'multibot: error: %s\n' "$*" >&2; exit 1; }

NON_INTERACTIVE=0
API_KEY=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --config-dir) CONFIG_DIR="$2"; ROUTES_FILE="$CONFIG_DIR/routes.json"; shift 2 ;;
    --non-interactive) NON_INTERACTIVE=1; shift ;;
    --api-key) API_KEY="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown option: $1" ;;
  esac
done

find_agent() {
  if [[ -n "$AGENT_BIN" && -x "$AGENT_BIN" ]]; then return 0; fi
  if command -v agent >/dev/null 2>&1; then AGENT_BIN="$(command -v agent)"; return 0; fi
  if [[ -x "$HOME/.local/bin/agent" ]]; then
    AGENT_BIN="$HOME/.local/bin/agent"
    export PATH="$HOME/.local/bin:$PATH"
    return 0
  fi
  return 1
}

install_cli() {
  log "Installing Cursor CLI..."
  curl -fsSL https://cursor.com/install | bash
  export PATH="$HOME/.local/bin:$PATH"
  find_agent || die "install finished but agent binary not found"
}

ensure_cli() {
  if find_agent; then
    log "Cursor CLI: $AGENT_BIN"
    return 0
  fi
  if [[ "$NON_INTERACTIVE" -eq 1 ]]; then
    die "agent not found; run install.sh without --non-interactive"
  fi
  read -r -p "Cursor CLI not found. Install now? [Y/n] " ans
  ans="${ans:-Y}"
  case "${ans,,}" in
    y|yes) install_cli ;;
    *) die "agent not installed" ;;
  esac
}

ensure_auth() {
  if [[ -n "$API_KEY" ]]; then export CURSOR_API_KEY="$API_KEY"; fi
  if "$AGENT_BIN" status >/dev/null 2>&1; then
    log "Auth: ok ($("$AGENT_BIN" status 2>&1 | head -1))"
    return 0
  fi
  if [[ -n "${CURSOR_API_KEY:-}" ]]; then
    "$AGENT_BIN" status >/dev/null 2>&1 || die "CURSOR_API_KEY set but agent status failed"
    log "Auth: ok (API key)"
    return 0
  fi
  if [[ "$NON_INTERACTIVE" -eq 1 ]]; then
    die "not logged in; run agent login or set CURSOR_API_KEY"
  fi
  log "Not logged in."
  echo "  1) Browser login (agent login)"
  echo "  2) API key (CURSOR_API_KEY)"
  read -r -p "Choose [1/2]: " choice
  case "$choice" in
    1)
      NO_OPEN_BROWSER="${NO_OPEN_BROWSER:-1}" "$AGENT_BIN" login
      "$AGENT_BIN" status >/dev/null 2>&1 || die "login failed"
      ;;
    2)
      read -r -s -p "Paste API key (hidden): " key
      echo
      export CURSOR_API_KEY="$key"
      "$AGENT_BIN" status >/dev/null 2>&1 || die "API key rejected"
      log "Tip: export CURSOR_API_KEY in your shell profile."
      ;;
    *) die "invalid choice" ;;
  esac
}

pick_model() {
  local label="$1"
  local default_model="$2"
  local picked="$default_model"
  if [[ "$NON_INTERACTIVE" -eq 1 ]]; then printf '%s' "$default_model"; return 0; fi
  read -r -p "$label [$default_model]: " picked
  printf '%s' "${picked:-$default_model}"
}

write_routes() {
  mkdir -p "$CONFIG_DIR"
  local default_id smartest_id easy_id
  default_id="$(pick_model "Default intent model id" "cursor-grok-4.6-high")"
  smartest_id="$(pick_model "Smartest intent model id" "claude-fable-5-1-thinking-high")"
  easy_id="$(pick_model "Easy intent model id" "composer-2.5-fast")"
  python3 - <<PY
import json
from pathlib import Path
out = {
    "_comment": "Intent -> Cursor CLI model id. Edit or run: multibot --setup",
    "routes": {
        "default": "$default_id",
        "smartest": "$smartest_id",
        "easy": "$easy_id",
    },
    "default_intent": "default",
}
Path("$ROUTES_FILE").write_text(json.dumps(out, indent=2) + "\n")
print("wrote", "$ROUTES_FILE")
PY
}

ensure_cli
ensure_auth
log ""
log "Available models:"
("$AGENT_BIN" --list-models 2>/dev/null || "$AGENT_BIN" models 2>/dev/null || true) | sed 's/^/  /'
log ""
if [[ -f "$ROUTES_FILE" && "$NON_INTERACTIVE" -eq 1 ]]; then
  log "Routes exist; keeping $ROUTES_FILE"
else
  write_routes
fi
log "Done."
