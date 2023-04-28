#!/bin/bash

# MAJ du système

apt update && apt dist-upgrade -y 

# Supprimer les packets inutiles
apt autoremove -y 

#Configuration d'une clee ssh 

## Demander à l'utilisateur de saisir une clée publique (read) ,
## affecter la valeur de l'utilisateur à une variable
## utilisation de la variable système $USER 

read -p "Entrer un clee publique : " publickey
# Si le dossier /home/$USER/.ssh existe tu passe à echo dans un fichier 
#sinon tu crée le dossier
ssh_user_folder="/home/$USER/.ssh"

if [ ! -d $ssh_user_folder ];
	mkdir $ssh_user_folder
fi
echo $publickey >> /home/$USER/.ssh/authorized_keys



## Configuration SSH 

sed -i 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config
sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

## Redemarrer le service ssh 
systemctl restart sshd

# Installer les MAJ automatiques
apt install unattended-upgrades -y 
dpkg-reconfigure unattended-upgrades


# Désactiver l'accès pour tout les utilisateurs system

for user in $(awk -F: '$3 < 1000 {print $1}' /etc/passwd); do
	if [ "$user" != "root" ]; then 
		chsh -s /usr/sbin/nologin "$user"
	fi
done


# Désactiver le login avec root
chsh -s /usr/sbin/nologin root

# Faire un point de montage de /tmp et /var/tmp avec le système de fichier tmpfs 
# et interdire l'excution des scripts présent dans ce dossier

echo "tmpfs /tmp tmpfs defaults,nodev,nosuid,noexec 0 0" >> /etc/fstab
echo "tmpfs /var/tmp tmpfs defaults,nodev,nosuid,noexec 0 0" >> /etc/fstab

## Installer fail2ban 

apt install fail2ban -y 
systemctl enable fail2ban
systemctl start fail2ban

## Installer UFW et le configurer

apt install -y ufw 
ufw default deny incoming 
ufw default all outgoing
ufw allow 2222/tcp
ufw enable

echo "Hardenisation terminée"

## Demander à l'utilisateur de choisir entre option a (yes) et option b (no)
## afin de redemarrer le serveur 

## Demander à l'utilisateur de choisir entre option a (yes) et option b (no)
## afin de redemarrer le serveur 

read -p "Voulez-vous redemarrer le serveur ? (Y,N) " option_reboot

if [ $option_reboot == "y" ]; then
        echo "Rebooting ..."
        sudo reboot
else
        echo "Le serveur ne va pas redémarrer"
fi


## Demander à l'utilisateur de choisir entre option a (yes) et option b (no)
## afin de redemarrer le serveur 

#while true; do
#	read -p "Voulez-vous redémarrer le serveur ?  (O/N) : " reponse
#	case $reponse in
#		[Oo]* ) echo "Redemarrage du serveur en cours ..."; sudo reboot; break;;
#		[Nn]* ) echo "Le serveur ne va redémarrer"; exit ;;
#                 *   ) echo " Choix non valide, veuillez saisir 'O' pour oui et 'N' pour non :";;
#	esac
#done
