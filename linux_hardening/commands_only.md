
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

chown grincheux:grincheux /home/grincheux 
chmod 700 /home/grincheux

drwxr-xr-x 
chmod 755 /etc



chmod -R 700 /etc/apt /etc/network /etc/modules 
chmod 700 /etc/sysctl.conf 


echo "PARTIE2"



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

