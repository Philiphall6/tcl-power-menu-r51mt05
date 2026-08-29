#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0"
APKTOOL="${APKTOOL:-apktool}"
ZIPALIGN="${ZIPALIGN:-zipalign}"
APKSIGNER="${APKSIGNER:-apksigner}"
APKSIGNER_JAR="${APKSIGNER_JAR:-}"
JAVA_BIN="${JAVA_BIN:-java}"
KEYSTORE="${TCL_POWERMENU_KEYSTORE:-}"
STOREPASS="${TCL_POWERMENU_STOREPASS:-}"
KEY_ALIAS="${TCL_POWERMENU_KEY_ALIAS:-tclpowermenu}"

mkdir -p dist
"$APKTOOL" b src-apktool -o "dist/TclPowerMenu-v${VERSION}-unsigned.apk"

if ! command -v "$ZIPALIGN" >/dev/null 2>&1; then
  echo "zipalign manquant: definir ZIPALIGN ou l'installer." >&2
  exit 1
fi
"$ZIPALIGN" -f -p 4 "dist/TclPowerMenu-v${VERSION}-unsigned.apk" "dist/TclPowerMenu-v${VERSION}-aligned.apk"

if [ -n "$KEYSTORE" ] && [ -n "$STOREPASS" ]; then
  if command -v "$APKSIGNER" >/dev/null 2>&1; then
    SIGNER=("$APKSIGNER")
  elif [ -n "$APKSIGNER_JAR" ]; then
    SIGNER=("$JAVA_BIN" -jar "$APKSIGNER_JAR")
  else
    echo "apksigner manquant: definir APKSIGNER ou APKSIGNER_JAR." >&2
    exit 1
  fi
  "${SIGNER[@]}" sign \
    --ks "$KEYSTORE" \
    --ks-key-alias "$KEY_ALIAS" \
    --ks-pass "pass:$STOREPASS" \
    --key-pass "pass:$STOREPASS" \
    --out "dist/TclPowerMenu-v${VERSION}.apk" \
    "dist/TclPowerMenu-v${VERSION}-aligned.apk"
  "${SIGNER[@]}" verify --verbose "dist/TclPowerMenu-v${VERSION}.apk"
else
  echo "APK aligne non signe: dist/TclPowerMenu-v${VERSION}-aligned.apk"
  echo "Pour signer, definir TCL_POWERMENU_KEYSTORE et TCL_POWERMENU_STOREPASS."
fi
