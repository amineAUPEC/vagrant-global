
echo "adding user grincheux"
adduser grincheux 
grincheux1234+
grincheux1234+


su grincheux

echo "diskpart"
fdisk /dev/sda

sudo fdisk
n
p
1
+2G

n
p
2
+2G


fdisk -l 

echo "formatting in ext4"
sudo mkfs -t ext4 /dev/sda1
sudo mkfs -t ext4 /dev/sda2


echo "création, gestion du propriétaire, gestion des permissions"
mkdir /data/data_clear
mkdir /data/data_encrypted

chown root:grincheux /data_clear
chmod 750 /data_clear

chown root:grincheux /data_encrypted
chmod 750 /data_encrypted



blkid



mount -U $uid /data/clear

sudo echo “UUID=id de la 1er partition /data_clear auto defaults 0 0” >> /etc/fstab



sudo chown root:grincheux /data_clear
sudo chown root:grincheux /data_encrypted
sudo chmod 750 /data_encrypted




echo "PARTIE1"
# "PARTIE1"

chown grincheux:grincheux /home/grincheux 
chmod 700 /home/grincheux

drwxr-xr-x 
chmod 755 /etc



chmod -R 700 /etc/apt /etc/network /etc/modules 
chmod 700 /etc/sysctl.conf 


echo "PARTIE2"
# "PARTIE2"



echo " Installer l'outil *acl*"
sudo apt-get install -y acl 




echo "Créer un fichier */data_clear/flag1.txt* (droits 600, propriétaire : root, groupe : root)"

touch /data_clear/flag1.txt
chmod 600 /data_clear/flag1.txt
chown root:root /data_clear/flag1.txt
setfacl -m u:root:rw /data_clear/flag1.txt

- Ajouter une ACL pour que grincheux puisse lire ce fichier *sans modifier les permissions*

setfacl -m u:grincheux:r /data_clear/flag1.txt
-> On liste les permissions 
getfacl  /data_clear/flag1.txt


# partie 3
- Créer un fichier */data_clear/flag2.txt* (droits 666, propriétaire : root, groupe : root)


touch /data_clear/flag2.txt
chmod 666 /data_clear/flag2.txt
chown root:root /data_clear/flag2.txt



- Rendre ce fichier impossible à modifier.
chmod 444 /data_clear/flag2.txt



- Tenter de le modifier.
nano /data_clear/flag2.txt


# Partie 4
- Installer la librairie *libpam-cap* et l'outil *tcpdump*
sudo apt-get install -y libpam-cap tcpdump
nano /etc/security/capability.conf


which tcpdump
setcap cap_net_raw,cap_net_admin=eip /usr/bin/tcpdump


sudo groupadd pcap
sudo usermod -a -G pcap grincheux
chgrp pcap /usr/bin/tcpdump

setcap cap_net_raw,cap_net_admin=eip /usr/bin/tcpdump

su grincheux
tcpdump

# partie 6 chroot
- Créer le group *sftpusers* et l'utilisateur *simplet* (*simplet* appartient avec le mdp simple


sudo groupadd sftpusers
sudo adduser simplet 
sudo usermod -a -G sftpusers simplet


- Créer l'arborescence suivante /data_clear/sftp-chroot/writable

sudo mkdir -p /data_clear/sftp-chroot/writable

- Modifier les permissions de sorte que :
  - *simplet* puisse se connecter en SFTP
echo "Match group simplet" >> /etc/ssh/sshd_config
On ajoute le groupe sftpusers à l’utilisateur simplet
sudo usermod -a -G sftpusers simplet


  - *simplet* puisse télécharger un fichier déposé dans */data_clear/sftp-chroot*
chown -R simplet:simplet /data_clear/sftp-chroot

chmod 550 /data_clear/sftp-chroot 


    - *simplet* puisse déposer un fichier dans */data_clear/sftp-chroot/writable*

chmod 750   /data_clear/sftp-chroot/writable

chown simplet:simplet  /data_clear/sftp-chroot/writable
chown simplet:sftpusers  /data_clear/sftp-chroot/writable

- S'assurer que le service SSH est installé et fonctionnel, puis ajouter la configuration nécessaire (dans un fichier dédié : /etc/ssh/sshd_config.d/chroot.conf puis inclure ce fichier)

systemctl status sshd 
  - 
  - 
  - 


# ! Partie 7 : quotas
- Installer l'outil **quota**
    sudo apt-get install -y quota
- Activer les quotas sur le point de montage */data_clear*
    quotaon -v /data_clear
- Initialiser les quotas dans le dossier */data_clear* (hint: quotacheck, quotaon)
    quotaon -v /data_clear

    quotacheck -cugm /data_clear

- Ajouter des quotas pour empêcher l'utilisateur *simplet* d'utiliser plus   d'1Go d'espace disque sur la partition */data_clear*

 setquota -u simplet 1000M 1000M 0 0 /data_clear


- Ajouter des quotas pour empêcher l'utilisateur *grincheux* de créer plus de 20   fichiers sur la partition */data_clear*

 setquota -u grincheux 20 20 0 0 /data_clear

# ! Partie 8 : sudo
- Installer l'outil *sudo*, lister les règles existantes.

    sudo apt-get install -y sudo

- Créer un fichier */root/flag6.txt* en 600:root:root
    touch /root/flag6.txt
    chmod 600 /root/flag6.txt
    chown root:root /root/flag6.txt

- Configurer une règle pour que *grincheux* puisse exécuter n'importe quelle
  commande en root **avec un mot de passe** (directement dans le fichier de configuration, sans utiliser le groupe sudo)

a. Le fichier de configuration sera /etc/sudoers
1. nous ajoutons la ligne 
    grincheux ALL=(ALL:ALL) ALL


- Configurer une règle pour que *grincheux* puisse exécuter les commandes suivantes en tant que root, **sans mot de passe** :
  - systemctl status ssh.service
  - cat /root/flag6.txt

1. create 2 Cmnd_Alias : 
1. A. Cmnd_Alias SSH_SERVICE = /usr/bin/systemctl status ssh.service
1. B. Cmnd_Alias CAT_FLAG6 = /usr/bin/cat /root/flag6.txt


2. Dans un second temps on relie l'utilisateur aux commandes

grincheux ALL=(root:root) NOPASSWD: SSH_SERVICE
grincheux ALL=(root:root) NOPASSWD: CAT_FLAG6

3. Enfin on teste
1. 



- Créer une variable d'environnement pour *grincheux* (hint: /etc/environement) nommée HARDEN_LINUX=yes

    echo "HARDEN_LINUX=yes" >> /etc/environment

- Configurer une règle pour que *grincheux* puisse conserver cette variable d'environnement lors de l'utilisation de sudo

echo "
Defaults:grincheux env_keep+=HARDEN_LINUX" >> /etc/sudoers



# Partie 9 ssh 
ed25519
ssh-keygen -t ed25519

 Ajouter la clé publique dans le fichier */home/xxx/.ssh/authorized_keys* de votre utilisateur
    pass
- Ajouter la clé publique suivante dans le fichier authorized_keys de grincheux :
  *ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIG1EMj39R4uiSXKmka9+rE7Tgu3EKpUpQTGlyg0lhp0 tiix@grincheux*
      pass  
        

- Créer un groupe *sshusers*, et ajouter de l'utilisateur *grincheux* dans ce groupe (votre utilisateur également si nécessaire)
sudo groupadd sshusers
sudo usermod -a -G sshusers grincheux


 Modifier la configuration SSH comme suit :
  - Port d'écoute : 2222
  - IP d'écoute : IP de votre VM (pas 0.0.0.0)
  - Famille d'écoute : IPv4 only
  - Autorisation de connexion : uniquement les groupes *sshusers* et *sftpusers*
  - Désactiver l'authentification par mot de passe
  - 

AddressFamily inet
ListenAddress 192.168.2.10
Port 2222
PermitRootLOgin no 
Allowgroups sshusers sftpusers
PasswordAuthentication no

AllowAgentForwarding no
AllowStreamLocalForwarding no
X11Forwarding no
LoginGraceTime 2m
StrictModes yes
MaxAuthTries 3
MaxSessions 3
DebianBanner no
