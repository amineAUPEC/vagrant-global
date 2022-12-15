
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


chmod 755 /etc



chmod -R 711 /etc/apt /etc/network /etc/modules 
chmod 711 /etc/sysctl.conf 


echo "PARTIE2"



sudo apt-get install -y acl 



