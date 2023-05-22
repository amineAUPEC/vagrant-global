partie 1.0
On utilise VMware Workstation 17 Pro pour la virtualisation.
On ajoute 3 cartes réseaux en LAN segment (réseau interne) sur lequel on attribue les noms DMZ, LAN1, LAN2 et WAN. Et une carte en NAT pour l'accès à internet.
On attribue 35 Gb pour Pfsense en espace disque et 20 Gb pour les machines Debian. On attribue aussi 2 cpu pour chacun. 
On attribue 2Gb de RAM pour Pfsense et 512Mb pour les machines Debian.

On décompresse le fichier Pfsense.tar.gz et on charge l'ISO dans VMWare Workstation.
partie 1.1
On configure une machine Debian, on se contente d'installer un serveur ssh et le grub sur la partition racine. Il s'agit d'un bastion qui va nous permettre de nous connecter à Pfsense en web. 
On peut utiliser awesome pour l'interface graphique ou GNOME (si on a plus de ressources)

On aura une 3ème VM sous Debian pour l'utiliser comme serveur avec du hardening. 
partie 1.2
On installe Pfsense et on coche l'option non pour la configuration avancé. 
On sélectionne shell et on change le clavier en français.

partie 1.3
Pour passer le clavier en Français dans pfSense.

Dans le menu taper 8 pour accéder au Shell
Ensuite kbdmap
Sélectionner French ISO-8859-1 (accent keys)

Source : https://www.linuxaga.com/linux/divers/17-passer-le-clavier-de-pfsense-en-francais

partie 1.4
on désactive pfsense avec pfctl -d
On se connecte à l'interface web avec admin et pfsense

Voici la carte local LAN 192.168.1.100
on modifie pour que ce soit la passerelle du réseau DMZ 192.168.100.254

192.168.100.254 dmz  - VM1 - Pfsense - Pfsense




partie 1.5
On configure *mntui* nmtui pour le bastion
192.168.100.240 
systemctl restart networking
systemctl restart NetworkManager
dhclient -r eth0

partie 1.6
On modifie la plage d'adresse du serveur DHCP pour la DMZ
192.168.100.50 192.168.100.100
partie 1.7
On modifie l'adresse et les noms des interfaces LAN devient DMZ,  OP1 et OP2 deviennent LAN1 et LAN2
On oublie pas d'activer les interfaces.
On configure le masque en /24 pour les interfaces LAN1 et LAN2

On configure 
192.168.101.254 LAN1  - VM1 - Pfsense - Pfsense
192.168.102.254 LAN2  - VM1 - Pfsense - Pfsense
partie 1.8
On se rend sur Firewall Rules DMZ on laisse tel quel
On se rend sur LAN1
tout protocole
description allow all et log packet à vrai
puis on fait la même chose pour LAN2
enfin on fait apply changes. 


partie 1.9
On configure le dhcp pour les interfaces LAN1 et LAN2
du .50 au .100

partie 2.1
On configure le server à hardening on réinstalle Debian
Ou bien on clone la VM2 en régénérant les addresses MAC.

Cette VM3 sera sur le réseau DMZ tandis que la VM2 sera sur le réseau LAN1
On conserve l'interface NAT pour l'accès à internet.
de préférence avec un disque en mode LVM pour l'instant non chiffré.
 
partie 2.2
On se connecte avec l'utilisateur lab
nano /etc/sudoers.d/vagrant
vagrant ALL=(ALL:ALL) NOPASSWD: ALL


Afin d'éviter de faire scanner les ports par défaut on change l port 22 en 2222 dans /etc/ssh/sshd_config
On complique la tâche aux bots. 

S'authentifier avec une clé ssh


ssh-keygen avec une passphrase
on copie le fichier id_rsa.pub dans le fichier authorized_keys
partie 2.3

On bloque le tmp avec noexec
nano /etc/fstab
tmpfs /tmp tmpfs defaults,nodev,nosuid,noexec 0 0
mount -a
sudo /tmp/script.sh
partie 2.4
On installe sudo sur la machine Debian avec la commande
apt-get update -y && apt-get install sudo -y
on crée un script bash pour configurer notre machine Debian avec du hardening (de la protection avancée).

On configure le domaine en efrei.local
On configure .254
apt-get update -y && apt-get install awesome xinit  xterm -y
on installe aussi firefox 
apt-get update -y && apt-get install firefox-esr  -y

partie 2.5
On change les règles de firewall du DMZ que 53, 80, 443 en sortie


plan d'adressage
- NAT : 
    192.168.116.129 - nat - VM2 - Debian - Bastion
    192.168.116.131 - nat - WAN - VM1 - Pfsense - Pfsense


    192.168.1.1 - nat - VM1 - Pfsense - Pfsense
- DMZ :
    192.168.100.254 dmz  - VM1 - Pfsense - Pfsense