#!/bin/bash

function install_package(){
    sudo apt-get install -y asterisk fish


}


install_package


function verify_status(){
    sudo systemctl status asterisk
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
sudo asterisk -rvvv <<< EOF


core show applications

EOF


}



test_asterisk



function saving_asterisk_conf(){

sudo cp $default_config_dir_asterisk/$default_config_file $default_config_dir_asterisk/$default_config_file.bkp
sudo echo "" > $default_config_dir_asterisk/$default_config_file
sudo cat "" > $default_config_dir_asterisk/$default_config_file



}

saving_asterisk_conf