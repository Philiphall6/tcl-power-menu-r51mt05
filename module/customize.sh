#!/system/bin/sh

ui_print "TCL Power Menu v0.7"
ui_print "- Remappe mtkinp key 116 POWER vers F11"
ui_print "- Evite F10 car ce firmware l'utilise comme mute"
ui_print "- Veille normale en premier"
ui_print "- Ecran off direct sans compte a rebours TCL"
ui_print "- Redemarrage plus doux avec ecran coupe avant reboot"
ui_print "- Active le service Accessibilite au boot"

set_perm_recursive "$MODPATH/system" 0 0 0755 0644
set_perm "$MODPATH/service.sh" 0 0 0755
set_perm "$MODPATH/system/app/TclPowerMenu/TclPowerMenu.apk" 0 0 0644
set_perm "$MODPATH/system/usr/keylayout/mtkinp.kl" 0 0 0644
