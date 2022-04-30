![alt](images/2022-04-05-12-45-45.png)
[trunk_asterisk](https://wiki.mdl29.net/lib/exe/fetch.php?media=braveo:02_trunk_asterisk.pdf)

![sip_trunk](images/2022-04-05-14-06-31.png)
[sip_trunk_guide](https://support.voipcloud.online/hc/en-us/articles/201488150-Asterisk-SIP-Trunk-Guide)
![torontoconnectingtwoasterisk](images/2022-04-05-14-39-56.png)
![sip.conf](images/2022-04-05-16-14-06.png)
![](images/2022-04-05-16-14-36.png)
![](images/2022-04-05-16-15-31.png)
![](images/2022-04-05-16-18-49.png)
![](images/2022-04-05-16-25-23.png)
![](images/2022-04-05-16-25-09.png)




1. TRUNK SIP
   1. Réaliser une communication entre le téléphone A et le téléphone B de l’architecture suivante :
   2. Analyser le contenu des messages SIP INVITE et leur contenu SDP.
   3. Faites des manipulations afin de faire apparaitre le maximum des message SIP et les erreurs associées.
   4. Etablir une session avec activation de la vidéo, puis analyser tous les points essentiels de l’établissement de la session et des échanges RTP/RTCP qui s’en suivent.
2. SERVICES TELEPHONIQUES
Implémenter les services suivants :
1. Transfer d’appel
2. Messagerie vocale et consultation de la messagerie vocale
3. Standard automatique
4. Conférence
5. Interception dans le groupe
6. Un petit call center




1. 
- client1 = amine : numéro:100
- client2 = chhinyleboss : numéro:900



## Question 1
### Sur le serveur A : trunksip .153
- Sur la VM A : sip.conf
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
- Sur la VM A : extensions.conf

```python

[internal]

exten => 600,1,Playback(demo-echotest)
exten => 600,n,Echo

exten => 100,1,Dial(SIP/amine)
exten => 200,1,Dial(SIP/chhiny)

exten => 900,1,Dial(SIP/trunk_A_vers_B/${EXTEN})

```

### Sur le serveur B : peersipe .154
-  Sur la VM B : sip.conf
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



-  Sur la VM B : extensions.conf

```ini
[internal]

exten => 600,1,Playback(demo-echotest)
exten => 600,n,Echo

exten => 100,1,Dial(SIP/amine)
exten => 900,1,Dial(SIP/chhinyleboss)

```




### Récapitulatif

- on Précise sur la VMA : 
    - le context (internal)
    - un mot de passe
    - on  relève son adresse IP
    - Dans le extensions.conf    : on précise les numéros de téléphone et 900,1,Dial(SIP/trunk_A_vers_B/${EXTEN}) la plage de début.
- On précise sur la VMB : 
  - on précise le lien trunk dans la section register sous le format : `register => $user_trunk:$mdp@$ip_trunk_vm_a`
  - On précise dans le extensions.conf 
    - les numéros connus.


##  question 2
1. SIP INVITE

![](images/2022-04-06-11-17-38.png)

[capture1_question2et3.pcapng](./pcap)



##  question 4


- j'appuie sur la webcam sur microsip
![](images/2022-04-06-11-51-22.png)


[capture3_question4_video](./pcap/TP3/capture3_question4_video.pcapng)

RTCP
![video](images/2022-04-06-11-52-42.png)



# partie 2 : services téléphoniques
## question 1 : transfert d'appels

### Ressources du prof draft :

![](images/2022-04-06-12-03-47.png) blind transfer 
    ![](images/2022-04-06-12-01-01.png)

![transfertappel](images/2022-04-06-12-00-41.png)
## question 2 :  messagerie vocale et consultation de la messagerie vocale

## question 3 :  standard automatique



## question 4 :  conférence


## question 5 :  interception dans le groupe
- Introduction : 
  - Le parcage d'appels permet à une personne de mettre un appel en attente sur un poste téléphonique et de poursuivre la conversation à partir de n'importe quel autre poste téléphonique.

- 2 modes sont possibles : "Park Pickup Config" ou "Directed Call Pickup" 
  - "Park Pickup Config" : 
    - on appelle le numéro de l'appelant
    - on attend qu'un poste téléphonique appelle le numéro de l'appelé
    - on récupère l'appel
    - on continue la conversation
    
cALL PICKUP REPRENDRE UN APPEL
FOLLOW ME : pour continuer à suivre une fonctionnalité
Cela nécessite l'ajout d'un troisième poste téléphonique. 

#### Mise en place du call parking
Le **call parking** s'active dans le fichier *extensions.conf*  


#### Mise en place du call pickup
Tandis que le **call pickup** s'active dans le fichier *features.conf* :  et en modifiant ensuite le fichier *extensions.conf*

`pickupexten = *8`  


Pour recharger la modification : du fichier *features.conf*  dans le terminal : 

`module reload features`


Ensuite on modifie le fichier *extensions.conf* :
```python
callgroup=1
pickupgroup=1
directmedia=no
```

Pour recharger la modification : du fichier *extension.conf* dans le terminal :   
`sip reload`


[CALLPARK](https://github.com/flaviogoncalves/AsteriskTraining/wiki/Lab-4---PBX-Features)

## question 6 :  un petit call center
Un call parking est nécessaire pour un call center
Un agent avec des queues peut être utilisé pour gérer les appels entrants. Et le trafic dans un call center.

Using queues.conf]()
mais on peut simplifier le processus d'autres modules que nous avons déjà vu.


call center asterisk : call center phone systems

automated call distributor : ACD
using voicemail.conf
[ACR_asterisk](https://obrienlabs.net/automate-asterisk-to-auto-dial-a-number-for-testing/)
[doc_astreisk_agent](https://link)




