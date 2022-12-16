Hardening de la machine virtuelle de TP
=======================================

Résumé
------

Partie 0 - préparation
----------------------

- Création de l'utilisateur pour le TP
- Partitionnement du second disque

Partie 1 - hardening basique
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Permissions, ACL, attributs
- Capabilities
- Limites, quotas
- Configuration d'un SFTP chrooté
- Configuration sudo sécurisée
- hardening ssh
- Chiffrement + montage automatique au boot du second disque


Pré-requis
----------

Configuration d'une machine virtuelle debian :

- [x] Debian 11 (bullseye)
- [x] 2Go RAM
- 10Go de disque (ext4)
- Installation classique non chiffrée
- 1 CPU
- 2 interfaces réseau
  - 1 interface NAT vers hyperviseur
  - 1 interface isolée
- Un second disque de 5Go
- Pas d'interface graphique !



`tp1_linux_setup`

Consignes
---------

**SNAPSHOT**

Créer un fichier *tp_linux_hardening_NOM.txt* dans lequel seront notées toutes vos modifications.
À chaque étape, noter les commandes et les modifications effectuées.

Pensez à prendre des snapshots réguliers afin de ne pas perdre toutes vos modifications si votre
système ne boot plus.

Toutes les configurations devront être persistentes et survivre à un reboot.

Partie 0 - Préparation
~~~~~~~~~~~~~~~~~~~~~~

- Créer un utilisateur *grincheux*
- Configurer le mot de passe de grincheux avec : *grincheux1234+*
- Créer 2 partitions sur le disque supplémentaire (peu importe leur taille) formatées en ext4
- Créer un répertoire */data_clear* et un répertoire */data_encrypted*. Ceux-ci doivent appartenir
  à l'utilisateur *root* (rwx) et au groupe *grincheux* (rx). Les autres utilisateurs ne doivent pas pouvoir
  y accéder.
- Monter la première partition du 2e disque sur /data_clear et faire en sorte qu'elle soit montée au
  boot automatiquement **sans utiliser le nom du device** (hint : blkid)

  .. note::

    Attention aux permissions une fois la partition montée, il faut les modifier comme demandé ci-dessus car le montage change celles-ci

**SNAPSHOT**

Partie 1 - Les permissions
~~~~~~~~~~~~~~~~~~~~~~~~~~

*One does not simply 777 their entire server*

- Configurer les permissions sur le répertoire home de grincheux de sorte que personne d'autre
  que lui-même ne puisse y accéder. 
    `chown grincheux:grincheux /home/grincheux ; chmod 700 /home/grincheux`
- Modifier les permissions sur le répertoire /etc (quelles permissions peuvent être possibles sans casser le système ?)

- Restreindre l'accès à certains fichiers et/ou répertoires dans /etc de sorte qu'un utilisateur
  non admin ne puisse pas y accéder. (hint: /etc/apt, /etc/network, /etc/sysctl.conf, /etc/modules... )

**REBOOT**
**SNAPSHOT**

Partie 2 - Les ACL
~~~~~~~~~~~~~~~~~~

*Give that man admin permissions*

- Installer l'outil *acl*
- Créer un fichier */data_clear/flag1.txt* (droits 600, propriétaire : root, groupe : root)
- Ajouter une ACL pour que grincheux puisse lire ce fichier *sans modifier les permissions*

Partie 3 - Les attributs
~~~~~~~~~~~~~~~~~~~~~~~~

*DAFUQ ?*

- Créer un fichier */data_clear/flag2.txt* (droits 666, propriétaire : root, groupe : root)
- Rendre ce fichier impossible à modifier.
- Tenter de le modifier.

Partie 4 - Les capabilities
~~~~~~~~~~~~~~~~~~~~~~~~~~~

*I AM ROOT !*

- Installer la librairie *libpam-cap* et l'outil *tcpdump*
- Faire en sorte que seul *grincheux* puisse lancer un tcpdump sans être root. Hints :
    - Trouver les capabilities nécessaires pour pouvoir lancer **tcpdump** sans être root (cf. cours et actions sur ping)
    - Appliquer ces capabilities dans le set *inheritable* du binaire **tcpdump**
    - Ajouter ces capabilities dans le fichier qui permet de configurer les capabilities pour les utilisateurs
    - Vérifier que le module pam_cap est bien chargé lorsqu'un utilisateur se connecte
    - Tester
- Lister les options de tcpdump, et proposer dans le write-up une ligne de commande qui permette de
  lancer ce tcpdump de la manière la plus sécurisée possible.

**SNAPSHOT**

Partie 5 - Les limites
~~~~~~~~~~~~~~~~~~~~~~

*The Sky is the limit. Sort of...*

- En prenant la liste des limites détaillées dans le cours, proposer une configuration
  appliquant au moins **4 limites différentes** pour *grincheux*
- Proposer une ligne de commande pour tester chacune de ces limites
  (la commande doit être interrompue pour cause de limite atteinte)

**SNAPSHOT**

Partie 6 - Les chroot
~~~~~~~~~~~~~~~~~~~~~

*Permission denied in chroot environment*

- Créer le group *sftpusers* et l'utilisateur *simplet* (*simplet* appartient
  au groupe *sftpusers*).
- Créer l'arborescence suivante */data_clear/sftp-chroot/writable*
- Modifier les permissions de sorte que :
  - *simplet* puisse se connecter en SFTP
  - *simplet* puisse télécharger un fichier déposé dans */data_clear/sftp-chroot*
  - *simplet* puisse déposer un fichier dans */data_clear/sftp-chroot/writable*
- S'assurer que le service SSH est installé et fonctionnel, puis ajouter la configuration nécessaire (dans un fichier dédié : /etc/ssh/sshd_config.d/chroot.conf puis inclure ce fichier)
  pour l'utilisation du sftp (cc cours). La racine du chroot doit être */data_clear/sftp-chroot*, ainsi que le home de simplet.
- Ajouter les fichiers/clés nécessaires pour que simplet puisse se connecter en sftp grâce à une clé ssh.
- Tester :
  - Déposer un fichier *flag3.txt* avec l'identité *grincheux* (en ssh) dans */data_clear/sftp-chroot/writable*
  - Déposer un fichier *flag4.txt* avec l'identité *root* (en ssh) dans */data_clear/sftp-chroot*
  - Récupérer les fichiers *flag3.txt* et *flag4.txt* avec l'identité de *simplet* (en sftp)
  - Déposer un fichier *flag5.txt* avec l'identité de *simplet* (en sftp) dans */data/sftp-chroot/writable*
- Laisser les fichiers déposés

**SNAPSHOT**

Partie 7 - Les quotas
~~~~~~~~~~~~~~~~~~~~~

*Don't just talk about hitting quota. Make it so.*

- Installer l'outil **quota**
- Activer les quotas sur le point de montage */data_clear*
- Initialiser les quotas dans le dossier */data_clear* (hint: quotacheck, quotaon)
- Ajouter des quotas pour empêcher l'utilisateur *simplet* d'utiliser plus
  d'1Go d'espace disque sur la partition */data_clear*
  fichiers sur la partition */data_clear*
- Tester (hint: commande **dd**)

.. note::

   quotaon: Your kernel probably supports ext4 quota feature but you are using external quota files. Please switch your filesystem to use ext4 quota feature as external quota files on ext4 are deprecated.
    Cette erreur est normale, ça n'empêche pas les quotas de fonctionner.

**SNAPSHOT**

Partie 8 - sudo
~~~~~~~~~~~~~~~

*Reboot. Permission denied. Sudo reboot.*

- Installer l'outil *sudo*, lister les règles existantes.
- Créer un fichier */root/flag6.txt* en 600:root:root
- Configurer une règle pour que *grincheux* puisse exécuter n'importe quelle
  commande en root **avec un mot de passe** (directement dans le fichier de configuration, sans utiliser le groupe sudo)
- Configurer une règle pour que *grincheux* puisse exécuter les commandes
  suivantes en tant que root, **sans mot de passe** :
  - systemctl status ssh.service
  - cat /root/flag6.txt
- Créer une variable d'environnement pour *grincheux* (hint: /etc/environement) nommée HARDEN_LINUX=yes
- Configurer une règle pour que *grincheux* puisse conserver cette variable d'environnement lors de l'utilisation de sudo
- Tester :
  - sudo echo $HARDEN_LINUX

**SNAPSHOT**

Partie 9 - SSH
~~~~~~~~~~~~~~

*Use ssh keys my young apprentice*

- Générer une paire de clés ssh de type ed25519 sur votre machine physique
- Ajouter la clé publique dans le fichier */home/xxx/.ssh/authorized_keys* de votre utilisateur
- Ajouter la clé publique suivante dans le fichier authorized_keys de grincheux :
  *ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIG1EMj39R4uiSXKmka9+rE7Tgu3EKpUpQTGlyg0lhp0 tiix@grincheux*
- Créer un groupe *sshusers*, et ajouter de l'utilisateur *grincheux* dans ce groupe (votre utilisateur également si nécessaire)
- Modifier la configuration SSH comme suit :
  - Port d'écoute : 2222
  - IP d'écoute : IP de votre VM (pas 0.0.0.0)
  - Famille d'écoute : IPv4 only
  - Autorisation de connexion : uniquement les groupes *sshusers* et *sftpusers*
  - Désactiver l'authentification par mot de passe
- À l'aide du cours, de vos connaissances, et des internets, sécuriser au
  maximum la configuration SSH de votre VM.

**SNAPSHOT**

Partie 10 - LUKS
~~~~~~~~~~~~~~~~

*Encrypt all the drives !!*

- Formater la deuxième partition du 2nd disque dur au format LUKS (hint: cryptsetup)
- Déchiffrer la partition avec le mot de passe, puis la formater au format ext4 (hint: cryptsetup, mkfs.ext4 /dev/mapper/xxx)
- Générer une clé aléatoire nommée *key_part2.lek* qui servira pour déchiffrer la partition (hint: dd)
- Stocker la clé dans le répertoire */etc/luks*, et rendre le dossier et le fichier lisibles uniquement par root, et rendre le fichier impossible à modifier
- Ajouter un slot de déchiffrement par fichier clé
- Configurer le système pour déchiffrement automatique au boot de ce disque (hint: /etc/crypttab)
- Configurer le système pour qu'il soit monté automatiquement au boot sur /data_encrypted (hint: /etc/fstab)

  .. note::

    Attention aux permissions une fois la partition montée, il faut les modifier comme demandé dans la partie 0 car le montage change celles-ci

- Reboot & test !

**SNAPSHOT**

