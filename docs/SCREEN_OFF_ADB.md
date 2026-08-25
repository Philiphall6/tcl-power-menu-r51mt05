# Mode Ecran off et maintien ADB

## Probleme

Une veille classique TV peut couper ou degrader :

- ADB via TCP/IP ;
- le Wi-Fi ou l'Ethernet USB ;
- certains services Android ;
- la possibilite de reveiller proprement la TV a distance.

Pour une TV root utilisee en debug, ce comportement est peu pratique.

## Solution retenue

Le bouton `Ecran off` du menu n'appelle pas `reboot -p` et ne simule pas une extinction complete. Il appelle le mode officiel TCL AudioOnly via :

```text
com.tcl.settings.ShowWindowService
Type=AudioOnly
```

Le firmware TCL lance ensuite son compte a rebours AudioOnly et active le flag interne :

```text
TVKitService AudioOnlyFlag=true
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

Sur cette TV, les touches classiques de la telecommande sortent du mode AudioOnly. La v0.6 laisse donc ce reveil au comportement TCL natif.

Le bouton Power ne force plus le reveil du retroeclairage. Il ouvre uniquement le menu quand Android livre l'evenement au service d'accessibilite.

## Limite

Ce n'est pas une vraie veille basse consommation. C'est un mode maintenance/debug : ecran eteint, systeme actif.
