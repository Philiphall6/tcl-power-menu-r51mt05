# Mode Ecran off et maintien ADB

## Probleme

Une veille classique TV peut couper ou degrader :

- ADB via TCP/IP ;
- le Wi-Fi ou l'Ethernet USB ;
- certains services Android ;
- la possibilite de reveiller proprement la TV a distance.

Pour une TV root utilisee en debug, ce comportement est peu pratique.

## Solution retenue

Le bouton `Ecran off` du menu n'appelle pas `reboot -p` et ne simule pas une extinction complete. En v0.7, il n'appelle plus non plus la fenetre TCL AudioOnly, afin d'eviter le compte a rebours.

Il tente d'abord les API TCL directes :

```text
TTvFunctionManager.setPowerBacklight(false)
TWindowManager.setAudioOnlyFlag(true)
```

Puis il force le flag interne par root :

```text
service call TVKitService 60 i32 1
```

## Effet concret

L'ecran devient noir parce que le retroeclairage est coupe, mais Android reste dans un etat reveille. Sur la TV testee, les observations etaient :

```text
mWakefulness=Awake
Display Power: state=ON
TVKitService 61 => 00000001
```

Cela permet de conserver ADB actif, a condition que le reseau reste lui aussi actif.

## Sortir du mode

Sur cette TV, les touches classiques de la telecommande sortent du mode AudioOnly. La v0.7 laisse donc ce reveil au comportement TCL natif.

Le bouton Power ne force plus le reveil du retroeclairage. Il ouvre uniquement le menu quand Android livre l'evenement au service d'accessibilite.

## Limite

Ce n'est pas une vraie veille basse consommation. C'est un mode maintenance/debug : ecran eteint, systeme actif.
