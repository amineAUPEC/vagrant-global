vagrant init debian/bullseye64
vagrant up
vagrant ssh 
vagrant ssh <<< "vagrant"


vagrant halt
vagrant destroy -f

vagrant halt && vagrant up && vagrant provision && vagrant ssh