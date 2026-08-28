#!/usr/bin/env bash
set -euo pipefail

VERSION="0.7"
APKTOOL="${APKTOOL:-apktool}"
ZIPALIGN="${ZIPALIGN:-zipalign}"
APKSIGNER="${APKSIGNER:-apksigner}"
KEYSTORE="${TCL_POWERMENU_KEYSTORE:-}"
STOREPASS="${TCL_POWERMENU_STOREPASS:-}"
KEY_ALIAS="${TCL_POWERMENU_KEY_ALIAS:-tclpowermenu}"

mkdir -p dist
"$APKTOOL" b src-apktool -o "dist/TclPowerMenu-v${VERSION}-unsigned.apk"

if command -v "$ZIPALIGN" >/dev/null 2>&1; then
  "$ZIPALIGN" -f -p 4 "dist/TclPowerMenu-v${VERSION}-unsigned.apk" "dist/TclPowerMenu-v${VERSION}-aligned.apk"
else
  cp "dist/TclPowerMenu-v${VERSION}-unsigned.apk" "dist/TclPowerMenu-v${VERSION}-aligned.apk"
fi

if [ -n "$KEYSTORE" ] && [ -n "$STOREPASS" ]; then
  if command -v "$APKSIGNER" >/dev/null 2>&1; then
    "$APKSIGNER" sign \
      --ks "$KEYSTORE" \
      --ks-key-alias "$KEY_ALIAS" \
      --ks-pass "pass:$STOREPASS" \
      --key-pass "pass:$STOREPASS" \
      --out "dist/TclPowerMenu-v${VERSION}.apk" \
      "dist/TclPowerMenu-v${VERSION}-aligned.apk"
    "$APKSIGNER" verify --verbose "dist/TclPowerMenu-v${VERSION}.apk"
  else
    python3 scripts/sign-apk-v1.py \
      "dist/TclPowerMenu-v${VERSION}-aligned.apk" \
      "dist/TclPowerMenu-v${VERSION}.apk" \
      "$KEYSTORE" \
      "$KEY_ALIAS"
  fi
else
  echo "APK aligne non signe: dist/TclPowerMenu-v${VERSION}-aligned.apk"
  echo "Pour signer, definir TCL_POWERMENU_KEYSTORE et TCL_POWERMENU_STOREPASS."
fi
