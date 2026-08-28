# TCL Power Menu v0.7

Module Magisk pour TCL Android TV / Google TV Android 11 qui remplace le comportement du bouton Power par un menu simple :

- `Veille normale` : met la TV en veille Android normale via `KEYCODE_SLEEP`.
- `Ecran off` : coupe le retroeclairage sans endormir Android, sans fenetre TCL ni compte a rebours.
- `Redemarrer` : coupe d'abord l'image, synchronise les ecritures, puis reboot Android.
- `Eteindre` : extinction complete.

Cette version est prevue pour une TCL plateforme R51MT05 / Android 11, testee sur firmware V8-R51MT05-LF1V652.

## Pourquoi ce module

Sur certaines TCL, l'appui Power met la TV dans une veille profonde ou un etat ou ADB/reseau devient instable. Le mode `Ecran off` utilise au contraire le flag TCL `AudioOnly` : l'image est coupee, mais Android reste actif.

Resultat attendu :

- ADB reste joignable.
- Le reseau reste actif.
- Les services Android continuent de tourner.
- La TV consomme plus qu'en vraie veille, car ce n'est pas un arret complet.

## Comportement v0.7

Le bouton Power physique/Bluetooth est remappe via Magisk :

```text
key 116 F11
```

Le service d'accessibilite intercepte `F11` et ouvre toujours le menu d'alimentation.

Le menu affiche maintenant la veille normale en premier :

1. `Veille normale` pour retrouver le comportement de veille classique ;
2. `Ecran off` pour couper l'image tout en gardant ADB actif ;
3. `Redemarrer` pour lancer un reboot plus doux ;
4. `Eteindre` pour une extinction complete.

Le bouton Power ne tente pas de sortir lui-meme du mode `Ecran off`. Sur cette TV, les autres boutons sortent deja correctement du mode AudioOnly. En pratique :

1. choisir `Ecran off` pour couper l'image tout en gardant ADB actif, sans compte a rebours ;
2. appuyer sur une autre touche de la telecommande pour rallumer l'image ;
3. appuyer sur Power pour rouvrir le menu.

Ce comportement evite le cas ou Power essayait de reveiller le retroeclairage au lieu d'ouvrir le menu.

## Fichiers

- `dist/tcl-power-menu-v0.7-magisk.zip` : module Magisk pret a installer.
- `dist/TclPowerMenu-v0.7.apk` : APK seul, utile pour test ou installation manuelle.
- `module/` : contenu exact du module Magisk.
- `src-apktool/` : source apktool/smali de l'APK.

Empreintes SHA256 : voir `dist/SHA256SUMS`.

## Installation avec Magisk

Depuis l'application Magisk :

1. copier `dist/tcl-power-menu-v0.7-magisk.zip` sur la TV ;
2. ouvrir Magisk ;
3. Modules ;
4. Installer depuis le stockage ;
5. selectionner le zip ;
6. redemarrer la TV.

Depuis ADB root :

```sh
adb push dist/tcl-power-menu-v0.7-magisk.zip /data/local/tmp/
adb shell su -c 'magisk --install-module /data/local/tmp/tcl-power-menu-v0.7-magisk.zip'
adb reboot
```

## Accessibilite

Le module tente d'activer automatiquement le service :

```text
com.philphall.tclpowermenu/.PowerAccessibilityService
```

Controle ADB :

```sh
adb shell settings get secure enabled_accessibility_services
adb shell settings get secure accessibility_enabled
```

Si necessaire, l'activer dans les reglages Android :

```text
Parametres > Accessibilite > TCL Power Menu
```

## Mode Ecran off et ADB

`Ecran off` n'est pas une vraie veille. Il n'appelle pas la fenetre TCL AudioOnly, pour eviter le compte a rebours. Il tente d'abord les API TCL directes :

```text
TTvFunctionManager.setPowerBacklight(false)
TWindowManager.setAudioOnlyFlag(true)
```

Puis il force le flag interne par root :

```text
service call TVKitService 60 i32 1
```

Dans cet etat, le retroeclairage est coupe mais Android reste reveille. C'est ce qui permet de garder ADB et le reseau disponibles.

Verification possible :

```sh
adb shell service call TVKitService 61
adb shell dumpsys power | grep -E 'Display Power|mWakefulness'
```

Un retour `TVKitService 61` avec `00000001` indique que le flag AudioOnly est actif.

## Desinstallation

Dans Magisk : supprimer/desactiver le module `TCL Power Menu`, puis redemarrer.

En ADB root :

```sh
adb shell su -c 'rm -rf /data/adb/modules/tcl_power_menu /data/adb/modules_update/tcl_power_menu'
adb reboot
```

## Notes de securite

- Root/Magisk obligatoire.
- Module cible, teste sur TCL Android 11 R51MT05. Ne pas installer sur une autre plateforme sans verifier le keylayout.
- Le mode `Ecran off` garde Android actif : ce n'est pas une economie d'energie equivalente a la veille profonde.
- La cle de signature APK n'est pas incluse dans ce depot.
