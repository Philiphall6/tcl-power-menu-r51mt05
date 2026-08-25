# TCL Power Menu v0.6

## Assets

- `tcl-power-menu-v0.6-magisk.zip` : module Magisk pret a installer.
- `TclPowerMenu-v0.6.apk` : APK seul, utile pour test ou installation manuelle.
- `SHA256SUMS` : empreintes des deux fichiers.

## Changement principal

Le bouton Power/F11 ouvre uniquement le menu. Il ne tente plus de sortir du mode `Ecran off`.

Raison : sur la TV testee, les autres touches de la telecommande sortent deja correctement du mode AudioOnly. Le comportement precedent pouvait empecher Power d'ouvrir le menu apres un `Ecran off`.

## Mode Ecran off pour garder ADB actif

Le choix `Ecran off` utilise le service TCL officiel AudioOnly :

```text
com.tcl.settings.ShowWindowService
Type=AudioOnly
```

Ce mode coupe le retroeclairage mais laisse Android actif. ADB et le reseau peuvent donc rester disponibles, contrairement a une vraie veille profonde.

Verification :

```sh
adb shell service call TVKitService 61
adb shell dumpsys power | grep -E 'Display Power|mWakefulness'
```

`TVKitService 61 => 00000001` indique que le flag AudioOnly est actif.

## Installation ADB

```sh
adb push tcl-power-menu-v0.6-magisk.zip /data/local/tmp/
adb shell su -c 'magisk --install-module /data/local/tmp/tcl-power-menu-v0.6-magisk.zip'
adb reboot
```

Magisk/root est obligatoire.
