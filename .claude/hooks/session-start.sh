#!/bin/bash
# Sets up REA (rea-agents) for Claude Code cloud sessions:
#   - Ghidra 12.1.4 (official release, else this repo's release mirror)
#   - Hopper 6.4.2 demo (optional, skipped if the download fails)
#   - REA MCP server registration + REA skill for Claude Code
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

REA_VERSION="6.4.0"
GHIDRA_TAG="Ghidra_12.1.4_build"
GHIDRA_ROOT="/opt/ghidra"
# Fixed path; .mcp.json points REA at it.
GHIDRA_INSTALL_DIR="$GHIDRA_ROOT/ghidra_12.1.4"

# Fallback when the official release is not reachable: cloud sessions only get
# GitHub access to this repository, so a Ghidra 12.1.4 build (from the
# official source tag, without the optional Z3 extension) is kept as a
# release asset here. It is pinned by SHA-256.
MIRROR_REPO="ali231667/rea_insta"
MIRROR_TAG="ghidra-12.1.4"
MIRROR_SHA256="@MIRROR_SHA256@"

log() { echo "[rea-setup] $*" >&2; }

# Prints "<download url> <sha256 or ->" for the first .zip asset of a release.
release_zip_asset() {
  local meta
  meta=$(curl -fsS --max-time 30 "https://api.github.com/repos/$1/releases/tags/$2" 2>/dev/null) || return 1
  python3 -c '
import json, sys
d = json.load(sys.stdin)
a = next(a for a in d["assets"] if a["name"].endswith(".zip"))
print(a["url"], (a.get("digest") or "").removeprefix("sha256:") or "-")
' <<< "$meta"
}

# Downloads a release asset by API url, checks SHA-256, unpacks it into
# $GHIDRA_INSTALL_DIR.
fetch_ghidra_zip() {
  local url=$1 digest=$2 tmp dir
  tmp=$(mktemp -d)
  if ! curl -fsSL --max-time 900 -H "Accept: application/octet-stream" -o "$tmp/ghidra.zip" "$url"; then
    log "Ghidra download failed ($url)."
    rm -rf "$tmp"
    return 1
  fi
  if [ "$digest" != "-" ] && ! echo "$digest  $tmp/ghidra.zip" | sha256sum -c --quiet -; then
    log "Ghidra SHA-256 mismatch ($url)."
    rm -rf "$tmp"
    return 1
  fi
  mkdir -p "$tmp/x"
  unzip -q "$tmp/ghidra.zip" -d "$tmp/x"
  dir=$(find "$tmp/x" -mindepth 1 -maxdepth 1 -type d -name 'ghidra_12.1*' | head -1)
  if [ -z "$dir" ] || [ ! -x "$dir/support/analyzeHeadless" ]; then
    log "Ghidra zip has no ghidra_12.1* install ($url)."
    rm -rf "$tmp"
    return 1
  fi
  mkdir -p "$GHIDRA_ROOT"
  mv "$dir" "$GHIDRA_INSTALL_DIR"
  rm -rf "$tmp"
}

install_ghidra() {
  if [ -x "$GHIDRA_INSTALL_DIR/support/analyzeHeadless" ]; then
    return 0
  fi
  local url digest
  if read -r url digest < <(release_zip_asset NationalSecurityAgency/ghidra "$GHIDRA_TAG") &&
    fetch_ghidra_zip "$url" "$digest"; then
    log "Ghidra installed at $GHIDRA_INSTALL_DIR (official release)"
    return 0
  fi
  if read -r url digest < <(release_zip_asset "$MIRROR_REPO" "$MIRROR_TAG") &&
    fetch_ghidra_zip "$url" "$MIRROR_SHA256"; then
    log "Ghidra installed at $GHIDRA_INSTALL_DIR (from $MIRROR_REPO release $MIRROR_TAG)"
    return 0
  fi
  log "Ghidra skipped: no reachable release (check network policy / GitHub access)."
  return 1
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
