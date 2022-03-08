#!/bin/bash


function set_keyboards_fr(){
    sudo loadkeys fr
}
set_keyboards_fr


function install_package(){
    sudo apt-get install -y asterisk fish tcpdump

}

function install_package_gui(){
    sudo apt-get install -y xorg awesome

    sudo apt-get install -y wireshark 

# cat > ~/.xinitrc << EOF
# exec awesome &> /dev/null
# startx
# EOF
    # exec awesome &> /dev/null
    # su vagrant
    startx
}




install_package
install_package_gui


function verify_status(){
    sudo systemctl status asterisk | grep ""
}

verify_status

function ssh_user_enabling(){
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config    
    sudo systemctl restart sshd.service
}

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

[amine]
type=friend
callerid="My name" <100>
host=dynamic
secret=test
context=internal

[chhiny]
type=friend
callerid="My name" <200>
host=dynamic
secret=vitrygtr
context=internal

EOF

cat  $default_config_dir_asterisk/$default_config_file
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

echo "création d'un user"

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

exten => 600,1,Playback(demo-echotest)
exten => 600,n,Echo

exten => 100,1,Dial(SIP/amine)
exten => 200,1,Dial(SIP/chhiny)
EOF
sudo cat $default_config_dir_asterisk/extensions.conf 




}

config_extensions_conf

function reload_config(){

sudo asterisk -rvvv << EOF
dialplan reload
EOF

}
echo "dialing 600 from microsip"


echo "capture tcpdump"
function tcpdump_start(){
tcpdump -i enp0s8 -w /home/vagrant/sip.cap
cp /home/vagrant/sip.cap /vagrant

}
echo "capture wireshark"
function launch wireshark(){
    sudo wireshark &
}

function test_gui_x11(){
echo "as normal user" &> /dev/null
xclock&

}

function test_network(){
    sudo ip -br a
    sudo netsta -tunap
}
# function sipconf_config_default(){

# cat >  $default_config_dir_asterisk/$default_config_file << EOF 
# [general]
# context=public
# bindaddr=0.0.0.0
# transport=udp

# [salim]
# type=friend
# callerid="My name" <100>
# host=dynamic
# secret=test
# context=internal

# [nibras]
# type=friend
# callerid="My name" <200>
# host=dynamic
# secret=test
# context=internal

# EOF

# cat  $default_config_dir_asterisk/$default_config_file
# }


# function config_extensions_conf_default(){
# sudo echo "" > $default_config_dir_asterisk/extensions.conf
# sudo cat > $default_config_dir_asterisk/extensions.conf << EOF
# [internal]

# exten => 600,1,Playback(demo-echotest)
# exten => 600,n,Echo

# exten => 100,1,Dial(SIP/salim)
# exten => 200,1,Dial(SIP/nibras)
# EOF
# sudo cat $default_config_dir_asterisk/extensions.conf 




# }


# function fish_utilty(){

#     function sudo --description "Replacement for Bash 'sudo !!' command to run last command using sudo."
#     if test "$argv" = !!
#     eval command sudo $history[1]
#     else
#     command sudo $argv
#     end
#     end
# }


function sound_resolution_draft(){
    aconnect -x
start-pulseaudio-x11
sudo apt-get install -y pulseaudio alsa-utils
pulseaudio --start
sudo wireshark
aconnect -x
sudo chmod 777 /dev/snd/
sudo chmod 777 /dev/snd/seq
}