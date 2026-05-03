#!/usr/bin/env bash
set -euo pipefail

# 用法:
#   ./build_trollstore_dylib.sh /path/to/iPhoneOS.sdk
# 产物:
#   ./build/libTGMarkerCleaner.dylib

SDK_PATH="${1:-}"
if [[ -z "$SDK_PATH" ]]; then
  echo "Usage: $0 /path/to/iPhoneOS.sdk"
  exit 1
fi

if [[ ! -d "$SDK_PATH" ]]; then
  echo "SDK not found: $SDK_PATH"
  exit 1
fi

OUT_DIR="$(pwd)/build"
mkdir -p "$OUT_DIR"

SRC="$(pwd)/substrate_replace_tg_marked.xm"
OUT="$OUT_DIR/libTGMarkerCleaner.dylib"

clang++ -fobjc-arc -ObjC++ \
  -dynamiclib \
  -isysroot "$SDK_PATH" \
  -arch arm64 \
  -miphoneos-version-min=14.0 \
  -framework Foundation \
  -Wl,-undefined,dynamic_lookup \
  "$SRC" \
  -o "$OUT"

echo "Built: $OUT"
echo "Next: sign with ldid for TrollStore injection, e.g.:"
echo "  ldid -S $OUT"
