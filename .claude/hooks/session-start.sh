#!/bin/bash
# Sets up REA (rea-agents) for Claude Code cloud sessions:
#   - Ghidra 12.1.x (optional, skipped if GitHub release access is blocked)
#   - Hopper 6.4.2 demo (optional, skipped if the download fails)
#   - REA MCP server registration + REA skill for Claude Code
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

REA_VERSION="6.4.0"
GHIDRA_TAG="Ghidra_12.1.4_build"
GHIDRA_ROOT="/opt/ghidra"

log() { echo "[rea-setup] $*" >&2; }

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

# Hopper demo for Linux. REA's built-in downloader gets HTTP 403 from
# hopperapp.com, so fetch the same package with a browser user agent and
# check it against the size and SHA-1 that rea-agents expects.
HOPPER_URL="https://www.hopperapp.com/downloader/public/Hopper-6.4.2-Linux-demo.deb"
HOPPER_SIZE="35755772"
HOPPER_SHA1="e4f79dff602648a8ff4a88b773875b6bfac0dc65"

install_hopper() {
  if [ -x /opt/hopper/bin/Hopper ]; then
    return 0
  fi
  local tmp
  tmp=$(mktemp -d)
  if ! curl -fsSL --max-time 600 -A "Mozilla/5.0 (X11; Linux x86_64)" -o "$tmp/hopper.deb" "$HOPPER_URL"; then
    log "Hopper skipped: download failed ($HOPPER_URL)."
    rm -rf "$tmp"
    return 1
  fi
  if [ "$(stat -c %s "$tmp/hopper.deb")" != "$HOPPER_SIZE" ] ||
    ! echo "$HOPPER_SHA1  $tmp/hopper.deb" | sha1sum -c --quiet -; then
    log "Hopper skipped: package size or SHA-1 mismatch."
    rm -rf "$tmp"
    return 1
  fi
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -qq >/dev/null 2>&1 || true
  if ! apt-get install -y -qq "$tmp/hopper.deb" xvfb xauth python3 libx11-6 libxtst6 >/dev/null 2>&1; then
    log "Hopper skipped: apt-get install failed."
    rm -rf "$tmp"
    return 1
  fi
  rm -rf "$tmp"
  log "Hopper installed at /opt/hopper/bin/Hopper"
}

install_hopper || true

npx -y "rea-agents@$REA_VERSION" setup --yes --client claude_code >/dev/null

log "REA setup done."
