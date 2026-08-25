# Changelog

## v0.6

- Le bouton Power/F11 ouvre uniquement le menu.
- Suppression de la logique qui tentait de reveiller le retroeclairage depuis le bouton Power.
- Conservation de `Ecran off` via le service TCL officiel AudioOnly ajoute en v0.5.

## v0.5

- `Ecran off` lance systematiquement `com.tcl.settings.ShowWindowService` avec `Type=AudioOnly`.
- Corrige le cas ou `setPowerBacklight(false)` retournait sans erreur mais ne coupait pas l'image.

## v0.4

- Remappage `key 116 POWER` vers `F11` pour eviter `F10`, qui declenchait le mute sur ce firmware.
- Ajout du menu Power via service d'accessibilite.
