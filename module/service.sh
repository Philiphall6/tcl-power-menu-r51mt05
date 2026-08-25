#!/system/bin/sh

MODDIR=${0%/*}
LOG=/data/local/tmp/tcl_power_menu.log
SERVICE="com.philphall.tclpowermenu/.PowerAccessibilityService"
PKG="com.philphall.tclpowermenu"

log_msg() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG"
}

trim_log() {
  size="$(wc -c < "$LOG" 2>/dev/null)"
  if [ -n "$size" ] && [ "$size" -gt 131072 ]; then
    tail -n 200 "$LOG" > "$LOG.tmp" 2>/dev/null && mv "$LOG.tmp" "$LOG"
  fi
}

enable_accessibility_service() {
  cur="$(settings get secure enabled_accessibility_services 2>/dev/null)"
  [ "$cur" = "null" ] && cur=""

  case ":$cur:" in
    *":$SERVICE:"*)
      log_msg "accessibility already enabled"
      ;;
    *)
      if [ -n "$cur" ]; then
        settings put secure enabled_accessibility_services "$cur:$SERVICE"
      else
        settings put secure enabled_accessibility_services "$SERVICE"
      fi
      log_msg "accessibility added"
      ;;
  esac

  settings put secure accessibility_enabled 1
}

check_state() {
  path="$(pm path "$PKG" 2>/dev/null)"
  key116="$(grep -m 1 '^key[[:space:]]*116' /system/usr/keylayout/mtkinp.kl 2>/dev/null)"
  log_msg "package=${path:-missing} mtkinp=${key116:-missing}"
}

(
  for _ in $(seq 1 90); do
    [ "$(getprop sys.boot_completed)" = "1" ] && break
    sleep 1
  done

  trim_log
  log_msg "service start v0.6 moddir=$MODDIR"
  check_state
  if pm path "$PKG" >/dev/null 2>&1; then
    enable_accessibility_service
  else
    log_msg "package missing; accessibility not enabled"
  fi
  log_msg "service ready"
) >/dev/null 2>&1 &
