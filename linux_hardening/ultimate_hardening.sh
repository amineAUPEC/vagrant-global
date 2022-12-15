#!/bin/bash


function set_keyboards_fr(){
    sudo loadkeys fr
}
set_keyboards_fr


function install_package(){
    sudo apt-get install -y asterisk fish tcpdump 

}


function main(){
    install_package
}
main