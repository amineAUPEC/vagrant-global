Hardening avancé
================

https://wiki.archlinux.org/title/cgroups#With_systemd

Résumé
------

Partie 3 - hardening avancé
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Visualisation et gestion des éléments liés au cgroups
- Visualisation et gestion des éléments liés aux namespaces
- Créer un cgroup grâce à systemd
- Hardening systemd du service nginx
- Adapter un profil apparmor

Pré-requis
----------

`tp_linux_setup`
`tp_linux_hardening`

Consignes
---------

**SNAPSHOT**

cgroups
-------

1. Installer nginx depuis les dépôts debian
2. Analyser le service systemd nouvellement créé :
   - quelles options de sécurité
   - quels cgroups
   - quels namespaces
3. Créer un nouveau cgroup nommé "sun" grâce à systemd
   - Attribuer 20% du CPU
   - Attribuer 15% de la mémoire
   - D'autres restrictions à votre guise
4. Modifier le service systemd de nginx pour le lancer dans ce cgroup

**SNAPSHOT**

namespaces
----------

cadeau :)

systemd
-------

1. Lancer un systemd-analyze security sur le service nginx
2. Configurer des options de sécurité sur le service nginx pour obtenir un niveau de sécurité OK
   - Créer un *override* systemd (nommé hardening.conf) pour nginx qui contiendra toutes les options de sécurité
   - Ci-dessous une liste d'options à configurer. Le but est de comprendre leur utilité et de configurer une valeur correcte de sorte que le score de sécurité diminue, et que le service fonctionne toujours. (si la valeur d'une des options ci-dessous est à la valeur par défaut, le script de correction échouera) 
PrivateTmp
PrivateDevices
PrivateNetwork
NoNewPrivileges
ProtectKernelModules
ProtectKernelTunables
ProtectHostname
ProtectClock
ProtectControlGroups
ProtectKernelLogs
ProtectHome
ProtectSystem
CapabilityBoundingSet
LimitNPROC
LimitFSIZE
LimitLOCKS
LockPersonality
MemoryDenyWriteExecute
RestrictRealtime
RestrictAddressFamilies
RestrictSUIDSGID
RestrictNamespaces
SystemCallArchitectures

Tip : https://www.freedesktop.org/software/systemd/man/systemd.exec.html

**SNAPSHOT**

apparmor
--------

1. Installer les outils apparmor apparmor-utils apparmor-profiles apparmor-profiles-extra
2. Télécharger le profil apparmor pour nginx ici : https://raw.githubusercontent.com/jelly/apparmor-profiles/master/usr.bin.nginx
3. Installer et charger le profil apparmor pour nginx
4. Vérifier que le profil est chargé et en mode enforce
5. Ajouter les règles suivantes au profil (à vous de déterminer les permissions strictement nécessaires) :
   - Ajouter un webroot */var/www/html* : accès uniquement pour le propriétaire des fichiers
   - Ajouter un répertoire pour uploader des fichiers : */var/www/upload*
   - Ajouter la possibilité de lancer un ping depuis le serveur web avec une transition global vers le profil ping
   - Ajouter la possibilité de lancer la commande /usr/bin/exploit avec une transition locale
   - Définir le profil de /usr/bin/exploit en local (Ce tool lancera "/bin/bash")

