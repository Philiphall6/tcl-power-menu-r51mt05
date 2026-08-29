#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0"
APK="dist/TclPowerMenu-v${VERSION}.apk"

if [ ! -f "$APK" ]; then
  echo "APK signe manquant: $APK" >&2
  exit 1
fi

cp "$APK" module/system/app/TclPowerMenu/TclPowerMenu.apk
mkdir -p dist
(
  cd module
  if command -v zip >/dev/null 2>&1; then
    zip -r -9 "../dist/tcl-power-menu-v${VERSION}-magisk.zip" .
  else
    jar --create --file "../dist/tcl-power-menu-v${VERSION}-magisk.zip" -C . .
  fi
)
sha256sum "dist/TclPowerMenu-v${VERSION}.apk" "dist/tcl-power-menu-v${VERSION}-magisk.zip" > dist/SHA256SUMS
