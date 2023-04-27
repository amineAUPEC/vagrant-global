echo "PART 1 : Accès"

useradd -m -s /usr/bin/bash grincheux

ls

cat /etc/group | grep grincheux

sudo passwd grincheux

 

lsblk

fdisk -l

 

fdisk /dev/sdb << EOF

    n

    p

    1

    2048

    n

    p

    w

EOF

 

lsblk

sudo mkfs.ext4 /dev/sdb1

sudo mkfs.ext4 /dev/sdb2

sudo mkdir /data_clear /data_encrypted

ls /

sudo chown root:grincheux data_encrypted/ data_clear/

sudo chmod 750 data_encrypted/ data_clear/

ls -l /

 

sudo blkid /dev/sdb1

sudo blkid /dev/sdb2

 

UUID=$(sudo blkid /dev/sdb1| grep UUID | tr -s ' ' | cut -f 1 -d "=" )

 

sudo mount UUID="$UUID" data_clear/

 

nano /etc/fstab

sudo mount -a

cd /home

lsblk

ls -l

chmod 700 -R grincheux/

ls -l

 

usermod -aG sudo vagrant

cat /etc/group | grep sudo

sudo chmod -R 750 /etc/apt /etc/network /etc/sysctl.conf

ls -l

echo "****"

 

echo "PART 2 : ACL"

sudo apt install acl

sudo touch /data_clear/flag1.txt

sudo chown root:root /data_clear/flag1.txt

sudo chmod 600 /data_clear/flag1.txt

 

ls -l

sudo getfacl flag1.txt

sudo setfacl -m u:grincheux:r flag1.txt

sudo getfacl flag1.txt

nano flag1.txt

echo "test" >> flag1.txt

 

echo "PART 3 : attributs"

 

sudo touch flag2.txt

sudo chown root:root flag2.txt

sudo chmod 666 flag2.txt

 

sudo chattr +i flag2.txt

lsattr flag2.txt

nano flag2.txt

echo "test" >> flag2.txt

 

echo "PART 4 : capabilities"

sudo apt install libpam-cap tcpdump

sudo which tcpdump

sudo setcap cap_net_raw=ie /bin/tcpdump

 

echo "cap_net_raw           grincheux" >> /etc/security/capability.conf

sudo vi /etc/security/capability.conf

 

sudo /sbin/getcap /bin/tcpdump

tcpdump

 

echo "PART 5 : les limites"

ulimit -a grincheux

 

echo "grincheux     hard    maxlogins   4" >> /etc/security/limits.conf

echo "grincheux     hard    cpu     1 " >> /etc/security/limits.conf

echo "grincheux     hard    fsize     5000 " >> /etc/security/limits.conf

echo "grincheux     hard    nproc   10 "  >> /etc/security/limits.conf

 

nano test-cap.txt

echo "débordement de la taille"

 

sudo apt-get install -y stress

stress

echo "PART 6 : chroot"

sudo addgroup sftpusers

sudo useradd -m -s /usr/bin/bash simplet

sudo usermod -aG sftpusers simplet

 

sudo cat /etc/group | grep simplet

 

mkdir /data_clear/sftp-chroot /data_clear/sftp-chroot/writable

 

chown root:sftpusers -R /data_clear/sftp-chroot/  

 

chmod 750 /data_clear/sftp-chroot

chmod 770 /data_clear/sftp-chroot/writable

systemctl status ssh

cd /etc/ssh/sshd_config.d/

ls

cat chroot.conf >> EOF

Match group sftpusers

    ChrootDirectory /data_clear/sftp-chroot

    ForceCommand internal-sftp -u 007 -P symlink, hardlink

    AllowAgentForwarding no

    AllowStreamLocalForwarding no

    X11Forwarding no

EOF

 

echo "****"

cd /home/simplet

mkdir .ssh

chown grincheux .ssh

chmod 700 .ssh

ssh-keygen

cd /data_clear/sftp-chroot

mkdir .ssh

cd .ssh

vi authorized_keys

 

sftp key_path simplet@debianbulleye

 

echo "PART 6 : les quota"

apt install quota

quota --version

vi /etc/fstab

echo "defaults,usrquota,grpquota"

mount -o remount /data_clear/

quotacheck -cugm /data_clear/

quotaon -v /data_clear/

 

setquota -u simplet 1000 1000 0 0 /data_clear/

quota -vs simplet

 

su simplet

cd /data_clear/sftp-chroot/writable/

 

dd if=/dev/urandom bs=1G count=3 of=test




sudo apt install sudo

 

touch /root/flag6.txt

chown root:root /root/flag6.txt

chmod 600 /root/flag6.txt

 

echo "grincheux ALL=(ALL:ALL) ALL" >> /etc/sudoers

 

echo "***"

sudo cat /root/flag6.txt

sudo systemctl status ssh.service

sudo systemctl restart ssh.service

 

echo "HARDEN_LINUX=yes" >> /etc/environment

 

echo "***"

 

echo "PART 9: SSH"

 

sudo addgroup sshusers

sudo usermod -aG sshusers grincheux

sudo usermod -aG sshusers vagrant

 

cat /etc/group | grep sshusers

cat /etc/sshd_config << EOF

Port 2222

AddressFamily inet

EOF

 

AllowGroups sftpusers sshusers

 

sudo apt install fail2ban

 

echo "part 10 luks"

sudo cryptsetup --verbose luksformat --verify-passphrase /dev/sdb2

sudo cryptsetup --verbose luksOpen /dev/sdb2 encrypted

sudo mkfs.ext4 /dev/mapper/encrypted

sudo mkdir /etc/luks

sudo dd if=/dev/urandom of=/etc/luks/key part2.lek bs=512 count=4

 

sudo chmod 700 -R /etc/luks

sudo chown root -R /etc/luks

sudo chatatr +i /etc/luks/key_part2.lek

sudo lsattr /etc/luks/key_part2.lek

sudo cryptsetup luksAddKey /dev/sdb2 /etc/luks/key_part2.lek

sudo blkid /dev/sdb2

sudo nano /etc/fstab

echo "***"

 

echo "part 11 nftables"

sudo nft add table ip nftable_rules

sudo nft add chain ip nftable_rules output { type filter hook input priority 0 \; }

sudo nft add chain ip nftable_rules input { type filter hook input priority 0 \; }

sudo nft list tables

sudo nft add rule nftable_rules input icmp type echo-request accept

sudo nft add rule nftable_rules input tcp  dport 22 counter accept

sudo nft add rule nftable_rules input ct state established, related counter accept

sudo nft add rule nftable_rules input tcp dport 80 accept

sudo nft add rule nftable_rules input tcp dport 443 accept

sudo nft list nftable_rules

 

sudo nft add chain ip nftable_rules output drop

sudo nft add chain ip nftable_rules input drop

 

echo "part 12 nginx"

sudo apt-get install -y nginx

sudo systemctl status nginx

sudo systemd-analyze security

sudo systemd-analyze nginx

sudo systemd-analyze security | grep nginx

 

sudo systemd-cgls

sudo lsns

sudo -lai  /proc/3108/ns

 

sudo systemd-analyze security | grep nginx

sudo systemctl edit nginx.service

echo "/hardening.conf"

 

sudo systemd-analyze security | grep nginx

 

sudo apt-get install -y apparmor  apparmor-utils apparmor-profiles apparmor-profiles-extra

 

sudo wget

sudo git clone

sudo apparmor_parser -r usr.bin.nginx

sudo systemctl reload apparmor.service

sudo systemctl status apparmor.service

sudo vi /etc/nginx/profile

 

sudo apparmor_status

 

sudo mkdir /var/www/upload

sudo chown root:sftpusers /var/www/upload

sudo chmod 770 /var/www/upload

 

sudo systemctl reload apparmor.service

sudo systemctl status apparmor.service