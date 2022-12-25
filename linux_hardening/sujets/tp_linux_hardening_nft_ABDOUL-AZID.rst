
Partie 11 - nftables
~~~~~~~~~~~~~~~~~~~~

- Suite au cours sur nftables, créer un set de règles initial. Celui-ci devra :
  - Autoriser le ping en entrée
  - Autoriser le ssh en entrée
  - Autoriser les états related, established en entrée
  - Autoriser *root* à naviguer sur TOUS les internets
  - Autoriser les mises à jour via apt-get
  - Autoriser les mises à jour du serveur de temps
  - Logger dans un fichier /var/log/firewall.log tout ce qui n'est pas accepté
  - Dropper tout le reste

  - Autoriser le ping en entrée
nft add rule amazingFilter firstInput icmp accept comment ”icmp-in”
nft add rule amazingFilter firstInput ip protocol icmp accept
comment ”icmp-in”

  - Autoriser le ssh en entrée
nft add rule amazingFilter firstInput tcp dport 2222 counter accept
comment ”ssh-in”

  - Autoriser les états related, established en entrée
nft add rule amazingFilter firstInput ct state established,related
accept comment ”allow-established-sessions”  - Autoriser le ping en entrée
nft add rule amazingFilter firstInput icmp accept comment ”icmp-in”
nft add rule amazingFilter firstInput ip protocol icmp accept
comment ”icmp-in”

  - Autoriser le ssh en entrée
nft add rule amazingFilter firstInput tcp dport 2222 counter accept
comment ”ssh-in”

  - Autoriser les états related, established en entrée
nft add rule amazingFilter firstInput ct state established,related
accept comment ”allow-established-sessions”

$ if $(whoami)==”root” then  ruleset   fi


$ iptables -A INPUT -p udp --sport 123 -j ACCEPT
$ iptables -A OUTPUT -p udp --dport 123 -j ACCEPT



$  ruleset 