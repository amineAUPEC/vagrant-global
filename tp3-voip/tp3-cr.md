# Compte-rendu TP3
- Compte de rendu de : 
  - Chhiny LIM
  - Amine ABDOUL-AZID
- Efrei NSM1 : Networks and Security Manager
- Salim BENAYOUNE : Module VOIP


# réalisations 

## Question 1 :
### Sur le serveur A : trunksip .153
- Sur la VM A : *sip.conf* :   
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

[trunk_A_vers_B]
type=friend
secret=azerty
context=internal
host=dynamic
insecure=port,invite 
```
- Sur la VM A : *extensions.conf* :   
```ini
[internal]
exten => 600,1,Playback(demo-echotest)
exten => 600,n,Echo

exten => 100,1,Dial(SIP/amine)
exten => 200,1,Dial(SIP/chhiny)

exten => 900,1,Dial(SIP/trunk_A_vers_B/${EXTEN})

```

### Sur le serveur B : peersipe .154
-  Sur la VM B : *sip.conf* :   
```ini
[general]
context=internal
bindaddr=0.0.0.0
transport=udp
register => trunk_A_vers_B:azerty@192.168.1.153

[chhinyleboss]
type=friend
callerid="My name" <900>
host=dynamic
secret=vitrygtr
context=internal
```



-  Sur la VM B : *extensions.conf* :   
```ini
[internal]

exten => 600,1,Playback(demo-echotest)
exten => 600,n,Echo

exten => 100,1,Dial(SIP/amine)
exten => 900,1,Dial(SIP/chhinyleboss)

```




### Récapitulatif de la question 1

- On Précise sur la VMA : 
    - Le contexte (internal)
    - Un mot de passe
    - On  relève son adresse IP
    - Dans le *extensions.conf*    : On précise les numéros de téléphone et `900,1,Dial(SIP/trunk_A_vers_B/${EXTEN})` la plage de début.
- On précise sur la VMB : 
  - On précise le lien trunk dans la section register sous le format : `register => $user_trunk:$mdp@$ip_trunk_vm_a`
  - On précise dans le *extensions.conf*
    - Les numéros connus.


##  Question 2 :  
1. SIP INVITE
- Voici un paquet **SIP INVITE** un ACK a lieu entre **chhinyleboss** et **amine**.
![SIP_invite](images/2022-04-06-11-17-38.png)

[capture1_question2et3.pcapng](./pcap)

## Question 3 : 
- Pour faire apparaître le maximum des messages SIP et les erreurs associées, on va faire des manipulations sur les messages SIP INVITE.  
   - On initie le dialogue avec le client1 et on lui envoie un INVITE.  
   - On initialise le dialogue avec le client2 et on lui envoie un INVITE.  
   - On initialise le dialogue avec le client1 et on lui envoie un ACK.  
   - On initie la requête SIP mais on n'accepte pas l'appel afin de provoquer une erreur.  
   - On initie la requête SIP mais on coupe l'appel afin de provoquer une erreur.  

##  Question 4 :  
- J'appuie sur la webcam sur **microsip** : 
![bouton_webcam](images/2022-04-06-11-51-22.png)


[capture3_question4_video.pcapng](./pcap/TP3/capture3_question4_video.pcapng)

- RTCP : 
  - Les échanges RTP/RTCP sont réalisés à travers le protocole RTP.  Le codec G.711 est utilisé, le SSRC est unique pour chaque échange. 
  - Nous le constatons durant les échanges vidéos.
![video](images/2022-04-06-11-52-42.png)

- Pour maximiser la transmission de la vidéo, on utiliserait le codec H.264.

# Partie 2 : Services téléphoniques
## Question 1 : Transfert d'appels
<!-- ![docs_blind_transfer](images/2022-04-06-12-03-47.png) blind transfer  -->
- Nous avons le fichier *extensions.conf* suivant : 
![transfertappel](images/2022-04-06-12-00-41.png)

Pour transférer un appel : nous allons mettre en place le blind transfer  

Lorsque nous utilisons **la touche dièse #** , nous verrons que l'appel sera transféré vers le numéro suivant.  

Pour cela nous activons dans le fichier *features.conf* : dans la section [featuremap] on ajoute :  

```ini
[featuremap]
blindxfer => #1
atxfer => *2
```
![modification_features](images/2022-04-06-12-01-01.png)  

- **Ensuite on recharge la configuration...**

## Question 2 :  Messagerie vocale et consultation de la messagerie vocale

#### Mise en place de la messagerie vocale
- La commande Record() est utilisée pour enregistrer des messages vocaux. Le premier message est dédiée pour l'auto-attendant et le second pour l'IVR : 
- Nous modifions la section [from-internal] dans le le fichier *extensions.conf*  :  
```ini
[from-internal]
exten => _4.,1,Record(${EXTEN:1}:gsm)
exten => _4.,n,wait(1)
exten => _4.,n,Playback(${EXTEN:1})
exten => _4.,n,Hangup()
```

  
- En fait il enregistre un séquence audio spous unn format ici gsm   
- A vrai dire le **4.** signifie que on accepte tout autre caractère suivi du n°4.  


- On appelle le numéro 4 pour enregistrer un message vocal.  **4menu1**  
> "Merci de bien vouloir presser une touche ou d'attendre votre tour".   
- On presse la touche # pour le réécouter.  


- On répète les étapes mais pour l'IVR : avec 4menu2  
> "Presser 1 pour l'accueil, 2 pour le rayon informatique et 3 pour le rayon vêtement".   
 


#### Mise en place pour consulter de la messagerie vocale

- La consultation de la messagerie vocale :    
- Nous ajoutons dans le fichier **voicemail.conf** :   
```ini
[general]
format=wav49|gsm|wav
[default]
100=>100,Caixa do PAP2,root@localhost,,|attach=yes|delete=0
900=>900,chhiny, root@localhost,,|attach=yes|delete=0
```
- Nous ajoutons dans le fichier *extensions.conf* : 
```ini
[stdexten]
exten=>s,1,Dial(${ARG1},20,tT)
exten=>s,n,Goto(${DIALSTATUS})
exten=>s,n,hangup()
exten=>s,n(BUSY),voicemail(${ARG2},b)
exten=>s,n,hangup()
exten=>s,n(NOANSWER),voicemail(${ARG2},u)
exten=>s,n,hangup()
exten=>s,n(CANCEL),hangup
exten=>s,n(CHANUNAVAIL),hangup
exten=>s,n(CONGESTION),hangup

[from-internal]
exten=>100,1,Gosub(stdexten,s,1(SIP/amine,${EXTEN}))
exten=>900,1,Gosub(stdexten,s,1(SIP/chhiny,${EXTEN}))
exten=9,1,voicemailmain()
```
- Nous testons en appuyant sur la **touche 9**. Afin de **consulter la messagerie vocale**.    

- Par conséquent nous avons réadapté le fichier *extensions.conf*  :  
  - Il attends 20 secondes avant de passer à la messagerie vocale. `s,1,Dial(${ARG1},20,tT)`
  - On peut changer de contexte grâce au Goto et ainsi récupère la valeur de DIALSTATUS.  
  - Elle correspond à la réponse par exemple n'a pas répondu car il est déjà en communication ou le téléphone est éteint ou voire si le numéro n'est plus attribué.   
  - Si il n'a pas de réponse `exten=>s,n(NOANSWER),voicemail(${ARG2},u)`, on lui laisse un message.  
  - Si le canal, n'est pas disponible ou que la personne refuse volontairement l'appel exemple l'arnaque au CPF... `exten=>s,n(CHANUNAVAIL),hangup` et `exten=>s,n(CANCEL),hangup`  

## Question 3 :  Standard automatique  
- Nous mettons en place une auto-attendance aussi connu sous le nom de *standard automatique*.  
- Mais également en tant que IVR :   
- En effet IVR signifiant *Interactive Voice Response system*.   
- Par conséquent, un Serveur Vocal Interactif est un système automatique qui permet de dialoguer avec l'appelant afin de déterminer le plus finement possible le motif de son appel.  

#### Mise en place avec la méthode auto réceptionniste :  
- Mise en place avec la méthode auto réceptionniste dans le fichier *extensions.conf* :   
```ini
[from-internal]
exten=>8,1,goto(trunk_A_vers_B,9999,1)
[from-siptrunk]
include=trunk_A_vers_B
[trunk_A_vers_B]
exten=>9999,1,answer()
exten=>9999,n,background(menu1)
exten=>9999,n,waitexten(10)
exten=>9999,n,Dial(${OPERATOR})
exten=>100,1,Dial(SIP/amine)
exten=>900,1,Dial(SIP/chhiny)
```

- Nous appelons **le 8** et nous testons en appuyant sur le **900** afin d'être redirigé vers le **SIP/chhiny**.  

- Nous allons vers la **priorité n°1**.   
- **Waitextension** est une fonction qui permet de faire attendre l'appelant pendant un certain temps.  
- Il fera appel à **OPERATOR** pour le rediriger vers le **SIP/chhiny** par exemple.  



#### Mise en place avec la méthode IVR 
- Dans le fichier *extensions.conf* nous ajoutons :   
```ini
[from-siptrunk]
include=ivrsip
[from-internal]
exten=>8,1,goto(ivrsip,9999,1)
[ivrsip]
exten=>9999,1,answer()
exten=>9999,n,background(menu2)
exten=>9999,n,waitexten(10)
exten=>9999,n,Dial(${OPERATOR})
exten=>1,1,dial(SIP/amine)
exten=>2,1,dial(SIP/chhiny)
exten=>3,1,dial(IAX/amine2)
exten=>100,1,Dial(SIP/amine)
exten=>900,1,Dial(SIP/chhiny)
```

- Ensuite nous appelons **le 8** afin de tester son fonctionnement et de choisir les différentes options.   
- Il cherche l'extension 9999 dans le contexte *ivrsip* en gros c'est une étiquette pour se brancher.  
- Le menu2 est utilisé toujours avec  le préfixe 4. soit 4menu2.   
- On  tape 1 pour amine , 2 pour chhiny et 3 pour amine2.  

## Question 4 :  Conférence
- La conférence est un service qui permet de communiquer entre plusieurs personnes. 
- En effet cette dernière est assez simple à mettre en place et dans notre contexte, on peut la mettre en place en utilisant un appel entre trois personnes.  



- Dans le fichier *extensions.conf*, on peut trouver la ligne suivante :  
```ini
exten=4,1,Confbridge(main)
```

- Cette directive `Confbridge(main)` permet de démarrer une conférence.  
- Le **numéro 4** lors de l'appel permettra de démarrer la conférence. En effet ce numéro est souvent utilisé avec la plupart des softphones.  


- On peut aussi la spécifier de cette manière :  
```ini
exten => 1,1,Answer()
exten => 1,n,ConfBridge(1234,,1234_participants,1234_menu)
```
[confbridge](https://wiki.asterisk.org/wiki/display/AST/ConfBridge)


## Question 5 :  Interception dans le groupe
- Introduction :   
  - Le parcage d'appels permet à une personne de mettre un appel en attente sur un poste téléphonique et de poursuivre la conversation à partir de n'importe quel autre poste téléphonique.  

- 2 modes sont possibles : "Park Pickup Config" ou "Directed Call Pickup"   
  - "Park Pickup Config" :   
    - on appelle le numéro de l'appelant  
    - on attend qu'un poste téléphonique appelle le numéro de l'appelé  
    - on récupère l'appel  
    - on continue la conversation  
- Nous pouvons aussi nous intéressé à ces méthodes :    
    - Call Pickup reprendre un appel  
    - FOLLOW ME : Pour continuer à suivre une fonctionnalité  
  - Cela nécessite l'ajout d'un troisième poste téléphonique.   

#### Mise en place du call parking
Le **call parking** s'active dans le fichier *extensions.conf*    
```ini
[from-internal]
include => parkedcalls
```

- Cela peut aussi être fait de la manière suivante : dans le fichier *res_parking.conf*:   
```ini
[general]
[default]                      
parkext => 700                 
parkpos => 701-720              
context => parkedcalls          
```

#### Mise en place du call pickup
- Tandis que le **call pickup** s'active dans le fichier *features.conf* :  et en modifiant ensuite le fichier *extensions.conf*  
`pickupexten = *8`  

  
- Pour recharger la modification : du fichier *features.conf*  dans le terminal :   
`module reload features`


- Ensuite on modifie le fichier *extensions.conf* :  
```ini
callgroup=1
pickupgroup=1
directmedia=no
```

- Pour recharger la modification : du fichier *extension.conf* dans le terminal :     
`sip reload`


[CALLPARK](https://github.com/flaviogoncalves/AsteriskTraining/wiki/Lab-4---PBX-Features)  

## Question 6 :  Un petit call center
- Un call parking est nécessaire pour un call center.  
- Un agent avec des queues peut être utilisé pour gérer les appels entrants. Et le trafic dans un call center.  

- En effet nous voulons créer un call center via Asterisk : En général cela s'appelle Automated call distributor : ACD  

- Nous avons aussi besoin d'une messagerie vocale :  *voicemail.conf* que nous avons défini précédemment.   
[Using queues.conf](http://wiki.asterisk.org/wiki/display/AST/Using+queues.conf)
- Voici le fichier *queues.conf* :   
```ini
[general]
persistentmembers = yes

; General sales queue
[sales-general]
context=sales
music=default
strategy=ringall
joinempty=strict
leavewhenempty=strict
; Customer service queue
[customerservice]
context=customerservice
music=default
strategy=ringall
joinempty=strict
leavewhenempty=strict
```


- Mais on peut simplifier le processus d'autres modules que nous avons déjà vu.  



- De cette manière : aussi on peut le définir dans le *queues.conf* :   
```ini
[general]
autofill=yes              
shared_lastcall=yes       
[StandardQueue](!)       
musicclass=default       
strategy=rrmemory        
joinempty=no             
leavewhenempty=yes       
ringinuse=no             
[sales](StandardQueue)   
[support](StandardQueue) 
```
-  Le fichier *extensions.conf* sera réadapté : afin d'ajouter la partie dédié à l'ACD : Automated Distributed Call Center  
```ini
[Queues]
exten => 7001,1,Verbose(2,${CALLERID(all)} entering the support queue)
same => n,Queue(support)
same => n,Hangup()

exten => 7002,1,Verbose(2,${CALLERID(all)} entering the sales queue)
same => n,Queue(sales)
same => n,Hangup()

[LocalSets]
include => Queues      ; allow phones to call queues
```

- Sources :   
[ACR_asterisk](https://obrienlabs.net/automate-asterisk-to-auto-dial-a-number-for-testing/)  
[voip-info.org](https://www.voip-info.org/acd-for-asterisk-by-indosoft/)  
[ACD](https://www.asterisk.org/get-started/applications/call-center/)    
[asterisk_book_chunk_acd](http://www.asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/asterisk-ACD.html)  
## Les fichiers de configuration final : 
#### sip.conf
```ini
[general]
bindport=5060
bindaddr=0.0.0.0
context=dummy
disallow=all
allow=ulaw
alwaysauthreject=yes
allowguest=no

register=1040:vitrygtr@sip.kaiba.corp:5600/9999
register => trunk_A_vers_B:azerty@192.168.1.153

[group1](!)
type=friend
secret=vitrygtr
host=dynamic
qualify=yes
callgroup=1
pickupgroup=1
directmedia=no
context=from-internal


[amine](group1)
[chhiny](group1)
[kaiba](group1)
[makuba](group1)

[siptrunk]
type=peer
defaultuser=1040
secret=vitrygtr
port=5600 
insecure=invite
host=sip.kaiba.corp
fromuser=1040
fromdomain=sip.kaiba.corp
context=from-siptrunk
```

#### extensions.conf
```ini
[globals]
OPERATOR=SIP/chhiny


[from-internal]
include=>parkedcalls

exten => _4.,1,Record(${EXTEN:1}:gsm)
exten => _4.,n,wait(1)
exten => _4.,n,Playback(${EXTEN:1})
exten => _4.,n,Hangup()

exten=>900,1,Gosub(stdexten,s,1(SIP/amine,${EXTEN}))
exten=>6002,1,Gosub(stdexten,s,1(SIP/chhiny,${EXTEN}))
exten=>6003,1,Gosub(stdexten,s,1(SIP/makuba,${EXTEN}))
exten=>6004,1,Gosub(stdexten,s,1(SIP/kaiba,${EXTEN}))

exten=>_9.,1,dial(SIP/siptrunk/${EXTEN:1},20)

exten=6,1,Confbridge(main)
exten=7,1,goto(trunk_A_vers_B,9999,1)
exten=9,1,voicemailmain()

exten => 8100,1,Answer()
exten => 8100,n,MusicOnHold(default,30)

[from-siptrunk]
include=trunk_A_vers_B

[trunk_A_vers_B]
exten=>9999,1,answer()
exten=>9999,n,background(menu2)
exten=>9999,n,WaitExten(10)
exten=>9999,n,Dial(${OPERATOR})
exten=>1,1,dial(SIP/amine)
exten=>2,1,dial(SIP/chhiny)
exten=>3,1,dial(SIP/kaiba)
exten=>100,1,Dial(SIP/amine)
exten=>900,1,Dial(SIP/chhiny)

[stdexten]
exten=>s,1,Dial(${ARG1},20,tT)
exten=>s,n,FollowMe(${ARG2})
exten=>s,n,Goto(${DIALSTATUS})
exten=>s,n,hangup()
exten=>s,n(BUSY),voicemail(${ARG2},b)
exten=>s,n,hangup()
exten=>s,n(NOANSWER),voicemail(${ARG2},u)
exten=>s,n,hangup()
exten=>s,n(CANCEL),hangup
exten=>s,n(CHANUNAVAIL),hangup
exten=>s,n(CONGESTION),hangup
```
#### features.conf

#### res_parking.conf :
```ini
[general]
[default]                       ; Default Parking Lot
parkext => 700                  ; What extension to dial to park. (optional; if
parkpos => 701-720              ; What range of parking spaces to use - must be numeric
context => parkedcalls          ; Which context parked calls and the default park
```