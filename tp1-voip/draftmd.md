
- chinny calls amine  : 
- then code result
  - we include the result when we switch G711 codecs to GSM 8Khz on both dial client the server remain in directmedia yes
certain conditionsently running on ubuntu-bionic (pid = 1063)
    -- Registered SIP 'amine' at 192.168.1.110:53025
       > Saved useragent "MicroSIP/3.20.7" for peer amine    
-- Registered SIP 'chhiny' at 192.168.1.110:62876
       > Saved useragent "MicroSIP/3.20.7" for peer chhiny   
  == Using SIP RTP CoS mark 5
       > 0x7f4b10010f70 -- Strict RTP learning after remote address set to: 192.168.1.110:4000
    -- Executing [100@internal:1] Dial("SIP/chhiny-00000000", "SIP/amine") in new stack
  == Using SIP RTP CoS mark 5
    -- Called SIP/amine
    -- SIP/amine-00000001 is ringing
       > 0x7f4b3400cdb0 -- Strict RTP learning after remote address set to: 192.168.1.110:4002
    -- SIP/amine-00000001 answered SIP/chhiny-00000000
    -- Channel SIP/amine-00000001 joined 'simple_bridge' basic-bridge <0f432449-9bea-4c13-9cd7-f279e97d9cfb>
    -- Channel SIP/chhiny-00000000 joined 'simple_bridge' basic-bridge <0f432449-9bea-4c13-9cd7-f279e97d9cfb>
       > Bridge 0f432449-9bea-4c13-9cd7-f279e97d9cfb: switching from simple_bridge technology to native_rtp
       > Remotely bridged 'SIP/chhiny-00000000' and 'SIP/amine-00000001' - media will flow directly between them
       > 0x7f4b3400cdb0 -- Strict RTP switching to RTP target address 192.168.1.110:4002 as source
       > 0x7f4b10010f70 -- Strict RTP learning after remote address set to: 192.168.1.110:4000
    -- Channel SIP/chhiny-00000000 left 'native_rtp' basic-bridge <0f432449-9bea-4c13-9cd7-f279e97d9cfb>
  == Spawn extension (internal, 100, 1) exited non-zero on 'SIP/chhiny-00000000'
    -- Channel SIP/amine-00000001 left 'native_rtp' basic-bridge <0f432449-9bea-4c13-9cd7-f279e97d9cfb>
    -- Unregistered SIP 'amine'
    -- Registered SIP 'amine' at 192.168.1.110:54417
    -- Unregistered SIP 'amine'
    -- Registered SIP 'amine' at 192.168.1.110:58811
    -- Unregistered SIP 'chhiny'
    -- Registered SIP 'chhiny' at 192.168.1.110:58819
ubuntu-bionic*CLI> 


### scenario 2 : 
chiny calls amine 23:06 
directmedia =yes
chiny end the call


  == Using SIP RTP CoS mark 5
       > 0x7f4b10010f70 -- Strict RTP learning after remote address set to: 192.168.1.110:4000
    -- Executing [100@internal:1] Dial("SIP/chhiny-00000002", "SIP/amine") in new stack
  == Using SIP RTP CoS mark 5
    -- Called SIP/amine
    -- SIP/amine-00000003 is ringing
       > 0x7f4b0c010480 -- Strict RTP learning after remote address set to: 192.168.1.110:4002
    -- SIP/amine-00000003 answered SIP/chhiny-00000002
    -- Channel SIP/amine-00000003 joined 'simple_bridge' basic-bridge <9c496c94-fdf5-4c21-92f0-b810cfcc5955>
    -- Channel SIP/chhiny-00000002 joined 'simple_bridge' basic-bridge <9c496c94-fdf5-4c21-92f0-b810cfcc5955>
       > Bridge 9c496c94-fdf5-4c21-92f0-b810cfcc5955: switching from simple_bridge technology to native_rtp
       > Remotely bridged 'SIP/chhiny-00000002' and 'SIP/amine-00000003' - media will flow directly between them
       > 0x7f4b0c010480 -- Strict RTP learning after remote address set to: 192.168.1.110:4002
       > 0x7f4b0c010480 -- Strict RTP switching to RTP target address 192.168.1.110:4002 as source
       > 0x7f4b10010f70 -- Strict RTP switching to RTP target address 192.168.1.110:4000 as source
    -- Channel SIP/chhiny-00000002 left 'native_rtp' basic-bridge <9c496c94-fdf5-4c21-92f0-b810cfcc5955>
    -- Channel SIP/amine-00000003 left 'native_rtp' basic-bridge <9c496c94-fdf5-4c21-92f0-b810cfcc5955>
  == Spawn extension (internal, 100, 1) exited non-zero on 'SIP/chhiny-00000002'


images


rtp stream 
rtp stream analysis graph

## scenario 3 : 
chiny calls amine 23:18
G.723 8khz (microsip incompatible)
directmedia =yes

amine bug codecs

    -- Unregistered SIP 'chhiny'
    -- Registered SIP 'chhiny' at 192.168.1.110:63427
    -- Unregistered SIP 'amine'
    -- Registered SIP 'amine' at 192.168.1.110:56836
  == Using SIP RTP CoS mark 5
[Mar 28 21:19:50] NOTICE[2119][C-00000002]: chan_sip.c:10884 process_sdp: No compatible codecs, not accepting this offer!
    -- Unregistered SIP 'amine'
    -- Registered SIP 'amine' at 192.168.1.110:63854
  == Using SIP RTP CoS mark 5
[Mar 28 21:20:25] NOTICE[2119][C-00000003]: chan_sip.c:10884 process_sdp: No compatible codecs, not accepting this offer!
  == Using SIP RTP CoS mark 5
[Mar 28 21:20:38] NOTICE[2119][C-00000004]: chan_sip.c:10884 process_sdp: No compatible codecs, not accepting this offer!
ubuntu-bionic*CLI>

## scenario 4
codec speex 8khz
codec incompatible
directe_media=yes

## scenario 4.1


codec speex 32khz
codec incompatible

# scenario 5

root@ubuntu-bionic /vagrant# nano /etc/asterisk/sip.conf
root@ubuntu-bionic /vagrant# cat /etc/asterisk/sip.conf
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

[chhiny]
type=friend
callerid="My name" <200>
host=dynamic
secret=vitrygtr
context=internal
disallow=all

directmedia=yes

### scenario 5.1 -> Q4 (before/intermediate)
23:35

appel entre chiny et amine 
disallow all 
codec g711
directe_media yes
codec compatible

mais ne fonctionne tjrs pas avec g723 8khz


## scenario 6 -> Q4
gsm 8khz chiny
speex 8khz amine
disallow all
directmedia yes
23:41

=> résultat channel unavailable

    -- Auto fallthrough, channel 'SIP/chhiny-00000011' status is 'CHANUNAVAIL'


l'appel n'est pas réalisée car le canaux de transmission est pas compatible / selon asterisk il est indisponible  il y a une congestion  
  == Everyone is busy/congested at this time (1:0/0/1)
  car les appareils clients n'arrivent pas à communiquer correctement il faudrait potentiellement faire transiter grace au serveur SIP PROXY via asterisk en remplaçant le directmedia yes par la valeur no

## scenario 7 -> Q6

le codec n'est pas configurée côté asterisk  / sip proxy je pense dou le fait que l'appel n'aboutit toujours pas
disallow all a été modifié suite à une faute de frappe
sip reload pour recharger la conf
## scenario 8


1. On chiffre l'échange à l'aide d'un VPN par exemple
2. on peut chiffrer à l'aide de protocole de chiffrement ou des clés de chiffrement
3. on peut aussi sécuriser grâce à des codecs propriétaires
4. procéder à du bourrage pour compliquer la compréhension / lecture par un tiers
## scenario 9

13:14 

chiny call amine
directmedia=yes
allow=all
chiny : gsm 8khz
amine : speex 8khz
## scenario 10
13:18
13:19 13:20

chiny call amine
directmedia=no
allow=all
chiny : gsm 8khz
amine : speex 8khz

sip transfer the call to amine and even to chiny
chiny -> sip -> amine -> sip -> chiny
110 -> 114 -> 110 -> 114 -> 110

because amine and chiny have the same IP : 110
sip : l'adresse IP du SIP se termine par .114

vagrant halt



## scénario 11
Nous avons utilisés VAGRANT afin de gérer la gestion des machines virtuelles. Pour les créer en 5 min chronos. 
Nous avons aussi mis en place différents procédés afin de conserver un script bash afin d'appeler la fonction au moment donné.
