# TCL Power Menu v0.7

## Fichiers

- `tcl-power-menu-v0.7-magisk.zip` : module Magisk pret a installer.
- `TclPowerMenu-v0.7.apk` : APK seul, utile pour test ou installation manuelle.
- `SHA256SUMS` : empreintes des deux fichiers.

## Changements

- `Veille normale` est maintenant le premier choix du menu.
- `Ecran off` coupe l'image sans ouvrir la fenetre TCL AudioOnly, donc sans compte a rebours.
- `Redemarrer` coupe d'abord l'image, lance `sync`, attend une seconde, puis demande un reboot systeme.

## Menu

```text
Veille normale
Ecran off
Redemarrer
Eteindre
```

## Details techniques

`Veille normale` utilise :

```text
input keyevent 223
```

`Ecran off` utilise les appels TCL directs, puis :

```text
service call TVKitService 60 i32 1
```

`Redemarrer` utilise :

```text
sync; sleep 1; svc power reboot userrequested || setprop sys.powerctl reboot,userrequested || reboot
```

Le bouton Power/F11 ouvre uniquement le menu. Pour sortir de `Ecran off`, utiliser une autre touche de la telecommande.
