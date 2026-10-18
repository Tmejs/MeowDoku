#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

FLUTTER_BIN="${FLUTTER_BIN:-flutter}"
SDK_BIN="$(dirname "$(command -v "$FLUTTER_BIN")")"
DART_BIN="${DART_BIN:-$SDK_BIN/dart}"

"$DART_BIN" format --output=none --set-exit-if-changed lib test
"$FLUTTER_BIN" analyze --no-pub
"$FLUTTER_BIN" test --no-pub
