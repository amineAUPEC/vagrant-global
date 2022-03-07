#!/bin/bash

function install_package(){
    sudo apt-get install -y asterisk fish


}


install_package


function verify_status(){
    sudo systemctl status asterisk | grep ""
}

verify_status


function config_dir_asterisk(){

dpkg -l | grep -i asterisk
dpkg -L asterisk-config


}


default_config_dir_asterisk="/etc/asterisk/"
default_config_file="sip.conf"

function draft(){
 echo "draft"  

}


function divers(){

    man asterisk

    echo "debuging " &> /dev/null
    sudo asterisk -v -r 
}



function test_asterisk(){
sudo asterisk -rvvv << EOF
sleep 5
?
core show applications
sip show peers
quit
EOF


}



# test_asterisk



function saving_asterisk_conf(){

sudo cp $default_config_dir_asterisk/$default_config_file $default_config_dir_asterisk/$default_config_file.bkp
sudo cp $default_config_dir_asterisk/extensions.conf $default_config_dir_asterisk/extensions.conf.bkp
sudo echo "" > $default_config_dir_asterisk/$default_config_file
sudo echo "" > $default_config_dir_asterisk/extensions.conf
sudo cat $default_config_dir_asterisk/$default_config_file.bkp



}

saving_asterisk_conf



function sipconf_config(){

cat >  $default_config_dir_asterisk/$default_config_file << EOF 
[general]
context=public
bindaddr=0.0.0.0
transport=udp

[salim]
type=friend
callerid="My name" <100>
host=dynamic
secret=test
context=internal
EOF
}
function sipconf_config_test(){
sudo asterisk -rvvv << EOF

    sip 
    sip reload
    sip show peers
    sip show users
    sip show
EOF
}

sipconf_config

echo "cération d'un user"

echo "connexion d'un softphone auprès du serveur asterisk"


echo "changement en accès par pont afin d'accéder"
echo "sudo systemctl restart networking"


echo "isntallation de microsip on windows"
echo "codfniguration de microsip on windows"


echo "extensions.conf"

function config_extensions_conf(){
sudo echo "" > $default_config_dir_asterisk/extensions.conf
sudo cat > $default_config_dir_asterisk/extensions.conf << EOF
[internal]

exten => 600,1, Playback(demo-echotest)
exten => 600,n, Echo
EOF




}

# config_extensions_conf

function reload_config(){

sudo asterisk -rvvv << EOF
dialplan reload
EOF

}
echo "dialing 600 from microsip"


echo "capture tcpdump"

echo "capture wirehsark"