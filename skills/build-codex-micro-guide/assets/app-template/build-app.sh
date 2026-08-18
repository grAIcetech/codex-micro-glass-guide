#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=${0:A:h}
APP_DIR="$SCRIPT_DIR/Codex Micro Glass Guide.app"
MACOS_DIR="$APP_DIR/Contents/MacOS"
MODULE_CACHE_DIR="/private/tmp/codex-micro-glass-guide-module-cache"

mkdir -p "$MACOS_DIR" "$MODULE_CACHE_DIR"
cp "$SCRIPT_DIR/Info.plist" "$APP_DIR/Contents/Info.plist"

swiftc \
  -O \
  -module-cache-path "$MODULE_CACHE_DIR" \
  -framework AppKit \
  "$SCRIPT_DIR/CodexMicroGlassGuide.swift" \
  -o "$MACOS_DIR/CodexMicroGlassGuide"

codesign --force --sign - "$APP_DIR"
echo "$APP_DIR"
