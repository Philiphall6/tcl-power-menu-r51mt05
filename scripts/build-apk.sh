#!/usr/bin/env bash
set -euo pipefail

VERSION="0.6"
APKTOOL="${APKTOOL:-apktool}"
ZIPALIGN="${ZIPALIGN:-zipalign}"
APKSIGNER="${APKSIGNER:-apksigner}"
KEYSTORE="${TCL_POWERMENU_KEYSTORE:-}"
STOREPASS="${TCL_POWERMENU_STOREPASS:-}"
KEY_ALIAS="${TCL_POWERMENU_KEY_ALIAS:-tclpowermenu}"

mkdir -p dist
"$APKTOOL" b src-apktool -o "dist/TclPowerMenu-v${VERSION}-unsigned.apk"
"$ZIPALIGN" -f -p 4 "dist/TclPowerMenu-v${VERSION}-unsigned.apk" "dist/TclPowerMenu-v${VERSION}-aligned.apk"

if [ -n "$KEYSTORE" ] && [ -n "$STOREPASS" ]; then
  "$APKSIGNER" sign \
    --ks "$KEYSTORE" \
    --ks-key-alias "$KEY_ALIAS" \
    --ks-pass "pass:$STOREPASS" \
    --key-pass "pass:$STOREPASS" \
    --out "dist/TclPowerMenu-v${VERSION}.apk" \
    "dist/TclPowerMenu-v${VERSION}-aligned.apk"
  "$APKSIGNER" verify --verbose "dist/TclPowerMenu-v${VERSION}.apk"
else
  echo "APK aligne non signe: dist/TclPowerMenu-v${VERSION}-aligned.apk"
  echo "Pour signer, definir TCL_POWERMENU_KEYSTORE et TCL_POWERMENU_STOREPASS."
fi
