# Partie 1.0
On utilise VMware Workstation 17 Pro pour la virtualisation.  
On ajoute 3 cartes réseaux en LAN segment (réseau interne) sur lequel on attribue les noms DMZ, LAN1, LAN2 et WAN. Et une carte en NAT pour l'accès à internet.  
On attribue 35 Gb pour Pfsense en espace disque et 20 Gb pour les machines Debian. On attribue aussi 2 cpu pour chacun.   
On attribue 2Gb de RAM pour Pfsense et 512Mb pour les machines Debian.  

On décompresse le fichier Pfsense.tar.gz et on charge l'ISO dans VMWare Workstation.  
# Partie 1.1
On configure une machine Debian, on se contente d'installer un serveur ssh et le grub sur la partition racine. Il s'agit d'un bastion qui va nous permettre de nous connecter à Pfsense en web.   
On peut utiliser awesome pour l'interface graphique ou GNOME (si on a plus de ressources)  

On aura une 3ème VM sous Debian pour l'utiliser comme serveur avec du hardening.   
# Partie 1.2
On installe Pfsense et on coche l'option non pour la configuration avancé.   
On sélectionne shell et on change le clavier en français.  

# Partie 1.3
Pour passer le clavier en Français dans pfSense.  

Dans le menu taper 8 pour accéder au Shell  
Ensuite kbdmap  
Sélectionner French ISO-8859-1 (accent keys)  

Source : https://www.linuxaga.com/linux/divers/17-passer-le-clavier-de-pfsense-en-francais  

# Partie 1.4
On désactive pfsense avec `pfctl -d`  
On se connecte à l'interface web avec admin et pfsense  

Voici la carte local LAN 192.168.1.100  
On modifie pour que ce soit la passerelle du réseau DMZ 192.168.100.254  

192.168.100.254 DMZ  - VM1 - Pfsense - Pfsense  




# Partie 1.5
On configure *mntui* nmtui pour le bastion  
192.168.100.240  

```bash
systemctl restart networking
systemctl restart NetworkManager
dhclient -r eth0
```


# Partie 1.6
On modifie la plage d'adresse du serveur DHCP pour la DMZ  
192.168.100.50 192.168.100.100  
# Partie 1.7
On modifie l'adresse et les noms des interfaces LAN devient DMZ,  OP1 et OP2 deviennent LAN1 et LAN2   
On oublie pas d'activer les interfaces.   
On configure le masque en /24 pour les interfaces LAN1 et LAN2   
 
On configure   :   
192.168.101.254 LAN1  - VM1 - Pfsense - Pfsense    
192.168.102.254 LAN2  - VM1 - Pfsense - Pfsense   
# Partie 1.8
On se rend sur Firewall Rules DMZ on laisse tel quel   
On se rend sur LAN1  
Tout protocole  
Description allow all et log packet à vrai  
Puis on fait la même chose pour LAN2  
Enfin on fait apply changes.   


# Partie 1.9
On configure le dhcp pour les interfaces LAN1 et LAN2  
Du .50 au .100  

# Partie 2.1
On configure le server à hardening on réinstalle Debian  
Ou bien on clone la VM2 en régénérant les addresses MAC.  

Cette VM3 sera sur le réseau DMZ tandis que la VM2 sera sur le réseau LAN1  
On conserve l'interface NAT pour l'accès à internet.  
De préférence avec un disque en mode LVM pour l'instant non chiffré.   
 
# Partie 2.2
On se connecte avec l'utilisateur lab    

```bash
nano /etc/sudoers.d/vagrant  
vagrant ALL=(ALL:ALL) NOPASSWD: ALL
```



Afin d'éviter de faire scanner les ports par défaut on change l port 22 en 2222 dans */etc/ssh/sshd_config*
On complique la tâche aux bots.    

S'authentifier avec une clé ssh   


ssh-keygen avec une passphrase   
On copie le fichier *id_rsa.pub* dans le fichier *authorized_keys*    
# Partie 2.3

On bloque le tmp avec noexec  

```bash
nano /etc/fstab
tmpfs /tmp tmpfs defaults,nodev,nosuid,noexec 0 0
mount -a
sudo /tmp/script.sh
```

# Partie 2.4
On installe sudo sur la machine Debian avec la commande  
`apt-get update -y && apt-get install sudo -y`  
On crée un script bash pour configurer notre machine Debian avec du hardening (de la protection avancée).    

On configure le domaine en *efrei.local*  
On configure .254    
`apt-get update -y && apt-get install awesome xinit  xterm -y`  
On installe aussi firefox     
`apt-get update -y && apt-get install firefox-esr  -y`  

# Partie 2.5
On change les règles de firewall du DMZ que 53, 80, 443 en sortie   
 
On utilise portquiz.net:8080 pour tester les ports ouverts. notamment ici le port 8080    

https://192.168.116.133/pkg_mgr.php -> vm tools et squid que l'on installe et on active le service    
squid proxy qui est un web proxy et de gérer du cache mais aussi de filtrer des URL.    

Il va dans services -> squid proxy   
On  va dans services -> squid proxy -> local cache et on sauvegarde pour éviter d'avoir une erreur.  
On active avec enable squid proxy et enable  access logging  
On  active les logs  

On va dans services -> squid proxy -> ACLs -> blacklist   
neverssl.com  
*.neverssl.com  
openai.com  
*.openai.com  
On peut supprimer la version de squid : avec suppress squid proxy dans les headers car on évite de donner des informations sur le serveur. Pour des vulnérabilités potentiels.  
neverssl.com dans la liste des blacklist du proxy   
neverssl.com est un site qui permet de tester les sites en http sans passer par du https.  


On va dans acl  
# Partie 2.6 : 
On va dans System -> cert manager  
cert manager  
add   
PROXY CA   
Create an internal certificate authority  
Ajout dans le trust store  
sha256  
Durée 365 J  
CN : EFREI-CA  
COUNTRY code : FR  
STATE: FRANCE  
CITY: PARIS  
ORGANIZATION : EFREI   
OU: LAB  

# Partie 2.7
Dans service -> squid proxy server  
ssl man in the middle filtering   
enable ssl filtering  
CA -> proxy ca  
Il faut whitelister les sites du gouvernement, les sites bancaires.  

visible hostname : EFREI PROXY  
Administrator's Email : service.informatique@efrei.local  

# Partie 2.8
installer squidguard à l'aide du package manager. Ensuite on fait apply  
on ajoute du logging  
# Partie 2.9
On ajoute   
https://dsi.ut-capitole.fr/blacklists/download/blacklists_for_pfsense.tar.gz    

On va dans l'onglet blacklist  
-> download   
-> common acl   
- Do not allow IP-Addresses in URL true  
- dans target rules list   
 
adult dating drogue gambling phishing publicite vpn à bloquer  

`sudo apt-get install -y open-vm-tools-desktop`   



# Partie 3.1
On crée une nouvelle VM Debian sans interface graphique  
 srv-web1  

On va effectuer du hardening sur cette machine (aussi sur cette VM)  
On effectue un spliceall dans MITM mode pour ssl man in the middle filtering  


# Partie 3.1.2
On va dans package -> proxy server:cache  
    Services -> Squid proxy Proxy Server -> Cache Management -> Local Cache  

On clique sur le bouton Clear Disk Cache NOW   
Et on modifie le SSL MITM MODE en splice all à nouveau  


Puis il passe par l'EFREI   
# Partie 3.1.3
Installation de lightsquid  
# Partie 3.2
On copie le certificat :   
`sudo cp efrei-ca.crt /usr/local/share/ca-certificates/.`  


```bash
sudo update-ca-certificates
sudo apt install -y lynx sudo lnav
sudo apt install -y apache2 nmap openssl
```


```bash
nano /etc/sudoers.d/vagrant  
vagrant ALL=(ALL:ALL) NOPASSWD: ALL
```

# Partie 3.3
 
On va dans system Certmanager -> CA -> add -> add this to trust store  
WEB-EFREI -- ST=FRANCE, OU=LAB, O=EFREI, L=PARIS, CN=WEB-SERVERs, C=FR   
Pour éviter que le certificat soit fuité ou usurpé il existe un délai d'expiration afin de garantir l'intégrité.  
Au minimum 1 an au maximum 2 ans.  Mais surtout il peuvent usurpés l'autorité de certifications.  
srv1.efrei.local  
# Partie 3.4

On va dans system Certmanager -> Certificates ->   
server certificate  
descriptive name : SRV-WEB1  
365J  
CN srv1.efrei.local   
FR  
France   
Paris   
efrei  
lab  
type : server certificate  
fqdn or hostname : srv1.efrei.local  

On télécharge la clé privée et le certificat. 
# Partie 3.5

systemctl enable --now apache2  
/etc/apache2/sites-available/000-default.conf  
/etc/apache2/sites-available/default-ssl.conf  

    a2enmod ssl  
    a2ensite default-ssl.conf  


`systemctl restart apache2`  
`nano /etc/ssl/certs/ssl-cert-efrei-srv1.pem`  

Dans le fichier efrei-ca.crt on greffe tout le contenu de PROXY-CA.crt télécharger précédemment dans le certmanager :   
`nano efrei-ca.crt`   
On le copie ( efrei-ca.crt ) et on colle dans le dossier /usr/local/share/ca-certificates/.   
Ensuite on update avec `sudo update-ca-certificates`  
  


On utilise openssl  

/etc/ssl/private/ssl-cert-efrei-srv1.key  

`nmap -p 7443 --script ssl-cert 192.168.100.53`   


`netstat -tunlp` 
# Partie 3.6
On ajoute dans DNS resolver : 
host srv1  
domain efrei.local  
ip address 192.168.100.51  

Dans System -> services -> DNS resolver
enable dns resolver true  

# Partie 3.7
https://192.168.116.133/pkg_mgr_install.php  
On recherche snort à installer depuis le package manager  
On va dans services -> snort  
  
zero trust network et zero trust a devoir montrer pate blanche avec un sso ou un portail captif.   
sso avec okata ou keycloak  
wallix   
open-bastion  
teleport  
clés api de snort  

# Partie 3.8
tempmail  
https://temp-mail.org/fr/  

rahox84579@duscore.com  
42b45af55b7bcdd9b92d1cefde35b81177bb33b 0  

soxet89719@pgobo.com  


enable snort vrt pattern de rules  

enable snort gplv2  
enable**et open** emerging threats rules développé par proofpoint ( américain)    
à valider : 
- Hide Deprecated Rules Categories :   
- Click to clear all blocked hosts added by Snort when removing the package.   
Update Interval : 1 day : règles update toutes les 24H  
Remove Blocked Hosts Interval : 12 hours : serait débloquer après 12H éviter de surcharger la base de blocage.  

# Partie 3.9

Il faut mettre à jour : https://192.168.116.133/snort/snort_download_updates.php  


On active le service pour les WAN et DMZ  
interface WAN   
envoie Send Alerts to System Log  


On active les alertes suivantes : Dans Services -> Snort -> Interface Settings -> DMZ -> Categories  
p2p scan shellcode smtp sql snmp telnet tor trojan user-agents exploit dshield java exploit-kit  

# Partie 3.10
On peut utiliser un outil de reconnaissance des failles web avec nikto  

# Partie 4.1
On vérifie les alerts snorts dans https://192.168.116.133/snort/snort_alerts.php?instance=0  

# Partie 4.2
- Block Offenders : Checking this option will automatically block hosts that generate a Snort alert.   
- Changer IPS Mode à legacy mode pour blocking mode.  

# Partie 4.3
status -> system logs -> system -> general  

`sudo nmap -A -vvv 192.168.100.0/24`  
# Partie 4.4
On crée une nouvelle VM pour Zabbix avec 30Gb de Stockage





shodan.io et sansys sont des outils pour scanner les vulnérabilités publiques.
 
# Pour plus tard
On aura un qcm sur la partie théorique  
On devra présenter et créer infrav3  
- dnsfiltering   
- trafic shapping  
# Plan d'adressage :  

- NAT :   
    192.168.116.129 - nat - VM2 - Debian - Bastion    
    192.168.116.131 - nat - WAN - VM1 - Pfsense - Pfsense    


    192.168.1.1 - nat - VM1 - Pfsense - Pfsense  
- DMZ :  
    192.168.100.254 dmz  - VM1 - Pfsense - Pfsense   

# Cours : 
# 5 piliers de la sécurité
- Intégrité : garantir que les données sont celles spécifiées
- Disponibilité : comme la redondance, un SLA. 
- Confidentialité : seul la personne destinataire a le droit de le lire : gpg.
- Non répudiation : être sur que c'est bien la bonne personne et que ça lui qui l'ait envoyé comme pour les mails SPF et signatures
- Authentification : que seul les personnes soient autorisés à accéder aux ressources
- CIDTN : 

- reverse proxy
- firewall
- une note de linfra v3
monitoring avoir un visuel sur l'infrastructure