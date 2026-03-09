#!/usr/bin/env bash
# Terminal Triage launcher for Linux/macOS
#
# Set CORSIXTH_EXE to the full path of your CorsixTH executable
# Example: CORSIXTH_EXE=/usr/local/bin/corsix-th
CORSIXTH_EXE=${CORSIXTH_EXE:-corsix-th}

# Resolve the directory this script lives in
MOD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

exec "$CORSIXTH_EXE" \
  --lua-dir="$MOD_DIR/Lua" \
  --config-file="$MOD_DIR/config.txt" \
  --campaign=terminal_triage
