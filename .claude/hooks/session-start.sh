#!/bin/bash
# Sets up REA (rea-agents) for Claude Code cloud sessions:
#   - Ghidra 12.1.x (optional, skipped if github.com is blocked)
#   - Hopper demo (optional, skipped if www.hopperapp.com is blocked)
#   - REA MCP server registration + REA skill for Claude Code
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

REA_VERSION="6.4.0"
GHIDRA_TAG="Ghidra_12.1.4_build"
GHIDRA_ROOT="/opt/ghidra"

log() { echo "[rea-setup] $*" >&2; }

can_reach() {
  curl -sS -o /dev/null --max-time 15 -r 0-0 "$1" 2>/dev/null
}

install_ghidra() {
  local existing
  existing=$(find "$GHIDRA_ROOT" -maxdepth 1 -type d -name 'ghidra_12.1*' 2>/dev/null | sort -V | tail -1)
  if [ -n "$existing" ]; then
    GHIDRA_INSTALL_DIR="$existing"
    return 0
  fi

  local meta url digest tmp
  if ! meta=$(curl -fsS --max-time 30 "https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/tags/$GHIDRA_TAG" 2>/dev/null); then
    log "Ghidra skipped: cannot reach api.github.com (check network policy)."
    return 1
  fi
  read -r url digest < <(python3 -c '
import json, sys
d = json.load(sys.stdin)
a = next(a for a in d["assets"] if a["name"].endswith(".zip"))
print(a["browser_download_url"], (a.get("digest") or "").removeprefix("sha256:") or "-")
' <<< "$meta") || { log "Ghidra skipped: no zip asset in $GHIDRA_TAG."; return 1; }

  tmp=$(mktemp -d)
  if ! curl -fsSL --max-time 900 -o "$tmp/ghidra.zip" "$url"; then
    log "Ghidra skipped: download failed ($url)."
    rm -rf "$tmp"
    return 1
  fi
  if [ "$digest" != "-" ] && ! echo "$digest  $tmp/ghidra.zip" | sha256sum -c --quiet -; then
    log "Ghidra skipped: SHA-256 mismatch."
    rm -rf "$tmp"
    return 1
  fi
  mkdir -p "$GHIDRA_ROOT"
  unzip -q "$tmp/ghidra.zip" -d "$GHIDRA_ROOT"
  rm -rf "$tmp"
  GHIDRA_INSTALL_DIR=$(find "$GHIDRA_ROOT" -maxdepth 1 -type d -name 'ghidra_12.1*' | sort -V | tail -1)
  log "Ghidra installed at $GHIDRA_INSTALL_DIR"
}

if install_ghidra; then
  export GHIDRA_INSTALL_DIR
  if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
    echo "export GHIDRA_INSTALL_DIR=\"$GHIDRA_INSTALL_DIR\"" >> "$CLAUDE_ENV_FILE"
  fi
fi

SETUP=(npx -y "rea-agents@$REA_VERSION" setup --yes --client claude_code)

if command -v Hopper >/dev/null 2>&1 || [ -n "${HOPPER_LAUNCHER_PATH:-}" ]; then
  "${SETUP[@]}" >/dev/null
elif can_reach "https://www.hopperapp.com/"; then
  if ! "${SETUP[@]}" --install-hopper >/dev/null; then
    log "Hopper install failed; configuring REA without it."
    "${SETUP[@]}" >/dev/null
  fi
else
  log "Hopper skipped: cannot reach www.hopperapp.com (check network policy)."
  "${SETUP[@]}" >/dev/null
fi

log "REA setup done."
