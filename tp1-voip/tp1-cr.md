# Info   
VOIP   
# TP1 : VOIX SUR IP :ASTERISK   
# ASTERISK   
1. Nous commençons par installer le paquet à l'aide de la commande :      
        `sudo apt-get update -y && sudo apt-get install -y Asterisk`      
- Les fichier de configurations se situe dans */etc/asterix/* donc */etc/asterisk/sip.conf* sera notre fichier de configuration principale.   
   
- Pour trouver la localisation :      
        `package_name="asterisk" && dpkg -L $package_name | sort | uniq -c`     
  - On voit bien que la majorité des fichiers se trouve dans */etc/asterisk*            
2. Nous lançons Asterisk en mode debug (en mode verbose)       
        `sudo asterisk -rvvv`      
- L'option `-r` : permet de s'attacher au processus existant.  
- L'option `-v` : permet d'afficher des informations afin de diagnostiquer les problèmes/échanges. Plus il y a de `-v` plus il y a de détails.  


- Les commandes principales sont :      
  - `?`    
  - `sip show peers/users`     
  - `core show applications`    
  - `sip reload`    
  - `dialplan reload`     
   
3. Nous avons configuré le client SIP sous Windows Microsip en ajoutant le compte :      
   - En ajoutant un compte : utilisateur celui qui est renseigné dans le *sip.conf* (amine) et son mot de passe (directive *secret*): ***test***    
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
   
4. L'enregistrement se déroule à travers une liaison UDP et l'échange de paquets  en utilisant le protocole RTP :    
- Ce sont des ports dynamiques qui sont utilisés  : 
   - Port source : côté VM (dynamique): **4000; 4002 ; 5060**
   - Port source : côté PC : (port plage dynamique mais reste fixe) : **57837**    
![4screens](voip_m1_salim/q4--enregistrement sip)

5. On teste le client :    
-  Nous avons rechargé le fichier de configuration via `dialplan reload`  
-  Le service fonctionne en appelant le **600**, nous avons la sonnerie par défaut (l'équivalent d'un standard)   
> Résultat :    
```dotnet   
 == Using SIP RTP CoS mark 5   
    > 0x7f42e801d290 -- Strict RTP learning after remote address set to: 192.168.1.110:4000   
 -- Executing [600@internal:1] Playback("SIP/amine-00000001", "demo-echotest") in new stack   
    > 0x7f42e801d290 -- Strict RTP learning after remote address set to: 192.168.1.110:4000   
    > 0x7f42e801d290 -- Strict RTP switching to RTP target address 192.168.1.110:4000 as source   
 -- <SIP/amine-00000001> Playing 'demo-echotest.gsm' (language 'en')   
    > 0x7f42e801d290 -- Strict RTP learning complete - Locking on source address 192.168.1.110:4000   
```   
   
6. La capture a lieu sur la carte en accès par pont :    
- La valeur du binding est à 1 lors de l'enregistrement tandis qu'elle est à 0 lorsque l'on se déconnecte. (Lorsque le mot de passe est incorrect).  
![4screens](voip_m1_salim/q6--motdepasse incorrect)
   
7. La déconnexion se déroule par une demande request remove 1 binding , les informations sont par conséquent "obsolète" :       
- Les différentes étapes sont :   
   - L'échange de l'appel est réalisé à travers le protocole RTP et son protocole de transport reste le UDP   
   Le RTCP rentre aussi en jeu   
      
   - D'abord il y a une demande SIP/SDP   
      
   - Ensuite il y a le protocole RTCP puis à nouveau le SIP/SDP dès qu'il obtient le feu vert (SIP/SDP 200 OK) : le protocole RTP prend le relai de l'appel   
      
      
   - On peut visualiser l'échange de la conversation vocale : dans l'onglet telephony > VOIP   
   
  Sur Wireshark :
  - Dans l'onglet statistic -> flow graph   
![3screens](voip_m1_salim/q7--others-sip)
   
   
   
8. a. L'analyse des paquets suivant avec Wireshark :   
- Le protocole de transport est toujours **UDP**    
- Pour établir la session :   
- Un paquet contient :    
  - *request type invite : "cseq 102 invite"* avec le protocole SIP/SDP    
- Avec ce format : `sip:$nomdestinataire@$ipdest:$portdest`
- Le diagramme des échanges  :   
  -  try      
  -  ringing     
  -  register      
  -  200 ok     
  -  des échanges ACK ont lieu afin dre confirmer la réception.  
   
   
   
8. b. Les messages utilisés pour transporter la voix sont :   
   - Le transport de la voix s'effectue via le protocole RTP     
   - Real time transport protocol     
8. c. 8. c.  Le message utilisé pour clore la session contient **un request bye**   
   
8. d.  8. d. Les différentes sources sont : 
- IP source   : *192.168.1.110*  
- IP dest   : *192.168.1.114*  
   
8. e    : Les différents ports utilisées sont :
- Port source :    *4018*  
- Port dest   :  *14096*  

9.  Avec `directmedia=yes` pour *sip.conf* :   
- Le client communique directement avec le second client sans passer par le serveur SIP. Sauf lorsque l'appel est initialisé.  
- Le serveur SIP se contente de gérer les appels entrant et sortant. Et de les couper.
- La communication passe à travers le protocole RTP.

10.  Le client ne répond pas :
- Le client n'arrive pas à initialiser l'appel car il ne trouve pas de client.


## tasks draft
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
<!-- tnum =0 -->
<!-- T_remplissage = ((64-16)*8)/8kbit/sec -->
<!-- T_remplissage = 48 ms -->
```markdown
==========================    CALCUL SUR LES TEMPS    ==========================
On calcule souvent la distance avec la formule : d=v*t
On sait que l'**en_tête** vaut  16 octets et le **total_transmission_paquet** vaut 64 bits
On détermine alors le **contenant_utile** vaut le **total_transmission_paquet** - l'**en_tête**.
On a le **temps de numérisation** qui vaut 0 car le **temps de transmission** est négligeable.

On a le calcul suivant : 
**T_numérisation** = 0 
**T_remplissage** = ((64-16)*8) / 8 kbit/secondes = 48ms 
**T_propagation** = D / 200 000 km/s 
**T_transmission** = (64*8) / 100 mbit/s = 0.00512 ms (ce temps est négligeable) 
**T_traitement** = 7 ms 
 

0 + 48 + (D / 200 km/ms) + 0.00512 + 7 < 150 
D <  (150 – 48 – 0.00512 – 7) *200km 
D < 1 9000 km 
```

# exo2 : 2. NÉGOCIATION DES CODECS ET QUALITÉ AUDIO

1. Nous avons capturé le flux RTP et le flux RTCP. 
   - Tout d'abord : On ajoute les erreurs.
   - En effet la communication est directe entre les différents clients mais le serveur SIP contrôle / Initie les demandes téléphoniques.

- Pour cela nous avons utilisé la commande suivante : Afin de le lancer avec X11 :
```bash
sesu - etudiant
sudo wireshark &
```
- Lorsque nous modifions le codec, on voit que l'en-tête des paquets RTP sont modifiés  :   
![rtcp analysis stream scenario2.png](\images\2-\rtcp analysis stream scenario2.png)  

![screen1](voip-tp2\codexc\2-capturefluxrtcp_directmedia_yes\1-2022-03-08-165432.png)
- Grâce à l'onglet **RTP STREAM**:
  - Le port source pour le *client1* est : *4002*, son adresse IP est *192.168.1.110*. 
    - A destination du port *11322* du serveur SIP *192.168.1.114*.
  - Le port source pour le *client2* est : *4004*, son adresse IP est *192.168.1.110*.
    - A destination du port *13380* du serveur SIP *192.168.1.114*.
  - On observe que le codec est affiché dans le champ **Payload** : *g711U* 
  - On constate les pertes de paquets dans le champ **Lost**.
  - Enfin on constate la latence dans les champs **Jitter**.   
![screen2](voip-tp2\codexc\2-capturefluxrtcp_directmedia_yes\2-2022-03-08-161044.png)
- On peut voir le diagramme d'échange lors de l'appel grâce à l'onglet **Call Flow** :
  -  On voit l'initiation  de l'appel entre les clients. Avec le protocole SIP.
  -  On voit bien les paquets RTP échangés et leur longueur.
<!-- ![screen4](voip-tp2\codexc\2-capturefluxrtcp_directmedia_yes\4-2022-03-08-161139.png) -->
Configuration du serveur Asterisk : *sip.conf*  
`nano /etc/asterisk/sip.conf && cat /etc/asterisk/sip.conf` 
```ini
[general]
context=public
bindaddr=0.0.0.0
transport=udp

[amine]
type=friend
callerid="My name" <100>
host=dynamic
secret=test
context=internal
directmedia=yes

[chhiny]
type=friend
callerid="My name" <200>
host=dynamic
secret=vitrygtr
context=internal
directmedia=yes
```


[Screen pret](docx)    
L'affichage et l'appel est rejoué grâce au bouton play stream.


2. Observez-vous la même qualité audio selon les différents codecs utilisés ? Si non, quelle observation pouvez-vous faire ?  
   - La qualité audio se dégrade en fonction du codec utilisé. Même si pour autant l'ensemble de ces codecs sont satisfaisants.  **GSM** / **G.711**
   - Les codecs **G.723 8khz** et **Speex 8khz**ne sont pas fonctionnels avec Asterisk et Microsip. Du moins avec la configuration actuelle.  


3. Les valeurs Qos associés sont différentes en fonction des codecs utilisées 
    - Le codec par défaut : (G.711 A-law G.711 u-law ) : a la valeur de QoS la plus élevée. 0% de perte de paquets.
      - Le codec a une valeur plus basse puisque des pertes de paquets sont liés à la compression.
    - Ces valeurs sont conformes aux contraintes ToIP qui exige 99.999% de taux de disponibilité.  
    - Les 5 contraintes : sont respectées :
      - Temps de numérisation de la voix
      - Temps de remplissage des paquets
      - Temps de propagation
      - Temps de transmission
      - Temps de traitement par les noeuds intermédiaires
    - Le temps de latence ne dépasse pas les 150ms et est inférieur à 300ms.
4. Est-ce que l’appel est bien réalisé (décrire ce que l’on observe).  
- **L'appel n'est pas réalisé.**
- Le client est configuré avec le codec *gsm 8khz* pour **Chhiny** et l'autre client est avec le codec *speex 8khz* pour **Amine**    
![screen1](./images/tp2-images/6-Q4directmediayes_disallowall/1-2022-03-28-233830.png)
![screen2](./images/tp2-images/6-Q4directmediayes_disallowall/2-speex_amine.png)
- Les paramètres appliqués sont:
   - `disallow=all`    
   - `directmedia=yes`    
> résultat channel unavailable 
    -- Auto fallthrough, channel 'SIP/chhiny-00000011' status is 'CHANUNAVAIL'  
- L'appel n'est pas réalisée car le canal de transmission est incompatible / selon Asterisk il serait indisponible, par conséquent : il y a une congestion      
  `== Everyone is busy/congested at this time (1:0/0/1)`
  car les appareils clients n'arrivent pas à communiquer  correctement il faudrait potentiellement faire transiter  grâce au serveur SIP PROXY via Asterisk en remplaçant le `directmedia=yes` par la valeur `no`  
- Le message *Service unavailable* est affiché sur le softphone. Lors de l'appel.
![screen3](./images/tp2-images/6-Q4directmediayes_disallowall/3-CHANUNNAVLAIBLE.png)


- Voici le fichier de configuration en détail : `nano /etc/asterisk/sip.conf && cat /etc/asterisk/sip.conf` 
```ini
[general]
context=public
bindaddr=0.0.0.0
transport=udp
disallow=all

[amine]
type=friend
callerid="My name" <100>
host=dynamic
secret=test
context=internal
disallow=all
directmedia=yes

[chhiny]
type=friend
callerid="My name" <200>
host=dynamic
secret=vitrygtr
context=internal
disallow=all
directmedia=yes
```


5. Remettre `directmedia=no`. Est-ce que l’appel est bien réalisé (décrire ce que l’on observe)    
- **L'appel n'est pas réalisé.**
- Le client est configuré avec le codec *gsm 8khz* pour **Chhiny** et l'autre client est avec le codec *speex 8khz* pour **Amine**    
- Voici le fichier de configuration en détail : `nano /etc/asterisk/sip.conf && cat /etc/asterisk/sip.conf` 
```ini
[general]
context=public
bindaddr=0.0.0.0
transport=udp
disallow=all

[amine]
type=friend
callerid="My name" <100>
host=dynamic
secret=test
context=internal
disallow=all
directmedia=no

[chhiny]
type=friend
callerid="My name" <200>
host=dynamic
secret=vitrygtr
context=internal
disallow=all

directmedia=no
```

- Voici ce qui est affiché sur la console : *No compatible codecs, not accepting this offer!*
```dotnet
ubuntu-bionic*CLI> sip reload
 Reloading SIP
  == Parsing '/etc/asterisk/sip.conf': Found
  == Parsing '/etc/asterisk/users.conf': Found
  == Using SIP CoS mark 4
  == Parsing '/etc/asterisk/sip_notify.conf': Found
    -- Registered SIP 'amine' at 192.168.1.110:58950
    -- Registered SIP 'chhiny' at 192.168.1.110:62988
  == Using SIP RTP CoS mark 5
[Apr  2 12:54:29] NOTICE[2216][C-00000000]: chan_sip.c:10884 process_sdp: No compatible codecs, not accepting this offer!
```
- Visualisation des clients connectés : 
```dotnet
ubuntu-bionic*CLI> sip show peers
Name/username             Host                                    Dyn Forcerport Comedia    ACL Port     Status      Description
amine/amine               192.168.1.110                            D  Auto (No)  No             58950    Unmonitored
chhiny/chhiny             192.168.1.110                            D  Auto (No)  No             62988    Unmonitored
2 sip peers [Monitored: 0 online, 0 offline Unmonitored: 2 online, 0 offline]
```


- Microsip affiche `not acceptable here.`
- [screen](docx)


6. Utiliser Wireshark pour enregistrer l’appel. Comment peut-on sécuriser l’échange ?  

- L'appel est bien réalisé, lorsque l'on change `allow=all`:   
  - On autorise tout type de codecs.  
  - On passe par le proxy SIP grâce à `directmedia=no`.  
  - L'appel est transmis en clair.  L'appel est bien réalisé entre les 2 **Softphones**.  

- **On pourra sécurisé cet échange**  :
   1. On chiffre l'échange à l'aide d'un VPN par exemple  
   2. On peut chiffrer à l'aide de protocole de chiffrement, certificats ou des clés de chiffrement.  
   3. On peut aussi sécuriser grâce à des codecs propriétaires.  
   4. On pourrait mettre en place du bourrage pour compliquer la compréhension / lecture par un tiers.  
   5. On pourrait créer un réseau de serveur/proxy SIP avec des couches de chiffrement.    
   6. On pourrait utilisé firewall ou un PBX.  
   7. Mettre en place plus d'utilisateur/ authentification entre ses utilisateurs/ protection De déni de service.  
   8. Mise en place du SRTP Secure Real Time Protocol au lieu du RTP classique.  

![4 images](./tp2-images/7-/10-/directmediano--allowall--disallownone/fix)
- Le serveur SIP transfère l'appel à Amine et à Chhiny.
  - Chhiny -> SIP -> Amine -> SIP -> Chhiny  
  - 110 -> 114 -> 110 -> 114 -> 110  
  - Chhiny et Amine ont la même adresse IP.
  - Le serveur SIP se termine par *.114*

## Nota Bene : 
- Nous avons utilisés VAGRANT afin de gérer la gestion des machines virtuelles. Pour les créer en 5 min chronos.  
- Nous avons aussi mis en place différents procédés afin de conserver un script bash afin d'appeler la fonction au moment donné.  


- Nous avons aussi privilégié le format markdown pour la documentation.    

- Voici le lien du VagrantFile : https://github.com/amineAUPEC/vagrant-global/blob/main/tp1-voip/Vagrantfile


## Conclusion : 
- La latence *(Gigue augmente)* en fonction des codecs.   
- La communication est directe entre les différents clients mais le serveur SIP contrôle / Initie les demandes téléphoniques.  Avec la directive `directmedia=yes`.  
- Le G711 n'a pas de compression mais il est un des meilleurs codecs.  
- Nous avons communiqué entre différents clients SIP/VoIP (SoftPhone).   
- Le protocole RTP est utilisé lors de la communication. Le RTCP contrôle la latence/corrige les erreurs.   
  - Le SIP quant à lui contrôle la signalisation.   
- Nous avons stresser le réseau avec la commande `tc` (trafic control) afin de détecter les seuils de la qualité de service (QoS).  


## sources : 
https://aircall.io/fr/blog/voip-fr/voip-et-securite-les-5-bonnes-pratiques-a-connaitre/
https://www4.cs.fau.de/Projects/JRTP/pmt/node83.html

https://sip.goffinet.org/wireshark/analyse-voip-wireshark/
https://stackoverflow.com/questions/35497913/direct-media-and-direct-rtp-setup-in-asteisk
https://www.voip-info.org/asterisk-config-sipconf/
http://irt.enseeiht.fr/beylot/enseignement/VoIPQoS.pdf
## tasks

- faire question 3
  - trouver valeur qos
- finir exo2
- images à mettre

## draft
mise en place de téléphones SIP qui communique à travers un SIP PROXY  


on envoie vers un relai intermédiaire   
1. La qualité audio varie en fonction des codecs  
2. Les rapports RTCP donne : et les valeurs de Qos  : et : le codec par défaut est :  (G.711 A-law G.711 u-law )  
3.  
4. Il faudrait mettre en place une couche de chiffrement /d'authentification supplémentaire.  


draft

1-capturelfuxrtcp_directmedia_yes
   on rejoue la communication téléphonique
## draftend