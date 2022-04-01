# Info   
VOIP   
# TP1 : VOIX SUR IP :ASTERISK   
# ASTERISK   
1. Nous commençons par installer le paquet à l'aide de la commande      
        `sudo apt-get update -y && sudo apt-get install -y Asterisk`      
- Les fichier de configurations se situe dans /etc/asterix/ donc /etc/asterisk/sip.conf sera notre fichier de configuration principale.   
   
- Pour trouver la localisation :      
        `package_name="asterisk" && dpkg -L $package_name | sort | uniq -c`     
  - On voit bien que la majorité des fichiers se trouve dans /etc/asterisk            
2. Nous lançons Asterisk en mode debug (en mode verbose)     
        `sudo asterisk -rvvv`    
- Les commandes principales sont :      
  - `?`    
  - `sip show peers/users`     
  - `core show applications`    
  - `sip reload`    
  - `dialplan reload`     
   
3. Nous avons configuré le client SIP sous Windows microsip en ajoutant le compte :      
   - En ajoutant un compte : utilisateur celui qui est renseigné dans le sip.conf (amine) et son mot de passe (directive secret): test     
   - le client est enregistré :     
   - `sip show peers`       
   
> Résultat :     
```dotnet   
ubuntu-bionic*CLI> sip show peers   
Name/username             Host                                    Dyn Forcerport Comedia    ACL Port     Status      Description   
amine/amine               192.168.1.110                            D  Auto (No)  No             57837    Unmonitored   
chhiny                    (Unspecified)                            D  Auto (No)  No             0        Unmonitored   
2 sip peers [Monitored: 0 online, 0 offline Unmonitored: 1 online, 1 offline]   
    -- Unregistered SIP 'amine'   
    -- Registered SIP 'amine' at 192.168.1.110:57837   
   
```   
   
4. L'enregistrement se déroule à travers une liaison UDP et l'échange de paquets  en utilisant le protocole RTP    
- Ce sont des ports dynamiques qui sont utilisés  : 
   - port source côté  VM (dynamique): 4000; 4002 ; 5060   
   - port source côté PC :(port plage dynamique mais reste fixe) : 57837   
   
5. On teste le client :    
-  Nous avons rechargé le fichier de configuration via `dialplan reload`  
-  Le service fonctionne en appelant le 600, nous avons la sonnerie par défaut (l'équivalent d'un standard)   
> Result :    
```dotnet   
 == Using SIP RTP CoS mark 5   
    > 0x7f42e801d290 -- Strict RTP learning after remote address set to: 192.168.1.110:4000   
 -- Executing [600@internal:1] Playback("SIP/amine-00000001", "demo-echotest") in new stack   
    > 0x7f42e801d290 -- Strict RTP learning after remote address set to: 192.168.1.110:4000   
    > 0x7f42e801d290 -- Strict RTP switching to RTP target address 192.168.1.110:4000 as source   
 -- <SIP/amine-00000001> Playing 'demo-echotest.gsm' (language 'en')   
    > 0x7f42e801d290 -- Strict RTP learning complete - Locking on source address 192.168.1.110:4000   
```   
   
6. la capture a lieu sur la carte en accès par pont    
la valeur du binding est à 1 lors de l'enregistrement tandis qu'elle est à 0 lorsque l'on se déconnecte   
   
7. La déconnexion se déroule par une demande request remove 1 binding , les informations sont par conséquent "obsolète"     
- Les différentes étapes sont :   
   - l'échange de l'appelle est réalisé à travers le protocole RTP et son protocole de transport reste le UDP   
   Le RTCP rentre aussi en jeu   
      
   - d'abord il y a une demande sip/sdp   
      
   - ensuite il ya le RTCP puis à nouveau le sip/sdp dès qu'il obtient le feu vert (sip/sdp 200 OK) : le protocole RTP prend le relai dee l'appel   
      
      
   - on peut visualiser l'échange de la conversation vocale : telephony > VOIP   
   
- Sur Wireshark
  - statistic-> flow graph   
   
   
   
8.a   
le protocole de transport est toujours UDP   
request type invite : "cseq 102 invite"   
protocole SIP/SDP    
   
sip:$nomdestinataire@$ipdest:$portdest   
   
try    
ringing   
register    
200 ok   
des échanges ack ont lieu   
   
   
   
8.b.   
transport de la voix via le protocole RTP    
Real time transport protocol   
   
8.c.)    
   
clore la session avec un request bye    
   
8.d)    
port source   
port dest   
ip source   
ip dest   
   
8.e)    
à faire    
notes:    
- reste question 8 à rédiger      
- reste question 9, 10  
- reste à tester la valeur directmedia=no et directmedia=yes    
- mettre les screens
   
```bash
echo "directmedia=no" >> /etc/asterisk/sip.conf  
sudo sed -i 's/directmedia=no/directmedia=yes/g' /etc/asterisk/sip.conf    
```

## draft
directmedia permet : 





Direct media = no

Par défaut, on définit que les sessions média ne s’établissent pas directement entre les terminaux.

Directmedia=yes ; pour les appels internes, les sessions RTP s’établissent directement



lors des messages RTP : directmedia autorise les clients SIP1 vers SIP2 sans passer par le proxy via directmedia=yes, 
si directmedia=no : pas de communication RTP et pasSe par le proxy SIP



il faut aussi avoir un codec commun des deux côtés

si directmedia=no
le servur sip proxy : peut jouer le role de transcripteur via sa gestion des codecs



par défaut le paramètres directmedia=yes


# tp 2 -cr 


# exo1 : 1. CALCUL SUR LES TEMPS

calcul = d=v*t

# exo2 : 2. NÉGOCIATION DES CODECS ET QUALITÉ AUDIO


mise en place de téléphones SIP qui communique à travers un SIP PROXY


on envoie vers un relai intermédiaire 
2. La qualité audio varie en fonction des codecs
3. Les rapports RTCP donne : et les valeurs de Qos  : et : le codec par défaut est :  (G.711 A-law G.711 u-law )
5.
6. Il faudrait mettre en place une couche de chiffrement /d'authentification supplémentaire.



draft

1-capturelfuxrtcp_directmedia_yes
   on rejoue la communication telephonique

   
   
   
1. Nous avons capturé le flux RTP et le flux RTCP. 
Tout d'abord : On ajoute les erreurs.
En effet la communication est directe entre les différents clients mais le serveur SIP contr$ole / Initie les demandes téléphoniques.

Pour cela nous avons utilisé la commande suivante : afin de le lancer avec X11 :
```bash
sesu - etudiant
sudo wireshark &
```
Lorsque nous modifions le codec on voit que l'en-tête des paquets sont RTP sont modifiés
![rtcp analysis stream scenario2.png](\images\2-\rtcp analysis stream scenario2.png)


2. Observez-vous la même qualité audio selon les différents codecs utilisés ? Si non, quelle observation pouvez-vous faire ?


La qualité audio se dégrade en fonction du codec utilisé. Même si pour autant l'ensemble de ces codecs sont satisfaisants.
Les codecs G.723 8khz et Speex 8khz ne sont pas fonctionnels avec Asterisk et Microsip. Du moins avec la configuration actuelle.


4. Est-ce que l’appel est bien réalisé (décrire ce que l’on observe).
L'appel n'est pas réalisé
5. Remettre directmedia=no. Est-ce que l’appel est bien réalisé (décrire ce que l’on observe)
L'appel n'est pas réalisé

6. Utiliser Wireshark pour enregistrer l’appel. Comment peut-on sécuriser l’échange ?

L'appel est bien réalisé, l'appel est transmis en clair.

   1. On pourra sécurisé cet échange 
   1. On chiffre l'échange à l'aide d'un VPN par exemple
   2. On peut chiffrer à l'aide de protocole de chiffrement, certificats ou des clés de chiffrement.
   3. On peut aussi sécuriser grâce à des codecs propriétaires.
   4. On pourrait mettre en place du bourrage pour compliquer la compréhension / lecture par un tiers.
   5. On pourrait créer un réseau de serveur/proxy SIP avec des couches de chiffrement.
   6. On pourrait utilisé firewall ou un PBX.
   7. Mettre en place plus d'utilisateur/ authentification entre ses utilisateurs/ protection De déni de service.
   8. Mise en place du SRTP Secure Real Time Protocol au lieu du RTP classique.

   


## Nota Bene : 
Nous avons utilisés VAGRANT afin de gérer la gestion des machines virtuelles. Pour les créer en 5 min chronos. 
Nous avons aussi mis en place différents procédés afin de conserver un script bash afin d'appeler la fonction au moment donné.


Nous avons aussi privilégié le format markdown pour la documentation.


## sources : 
https://aircall.io/fr/blog/voip-fr/voip-et-securite-les-5-bonnes-pratiques-a-connaitre/