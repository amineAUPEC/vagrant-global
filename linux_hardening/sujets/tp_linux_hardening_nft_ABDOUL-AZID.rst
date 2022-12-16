
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
