#!/bin/bash
sudo apt-get install -y zsh git


sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cd ~/.oh-my-zsh/custom/plugins

git clone https://github.com/zsh-users/zsh-syntax-highlighting

 

git clone https://github.com/zsh-users/zsh-autosuggestions

sed -i 's/robbyrussell/agnoster/g' /root/.zshrc
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions)/g' /root/.zshrc


sudo apt install -y powerline jq



sudo git clone https://github.com/Aloxaf/fzf-tab


[ ! -f ~/.oh-my-zsh/custom/plugins/fzf-tab/fzf-tab.plugin.zsh ] || source ~/.oh-my-zsh/custom/plugins/fzf-tab/fzf-tab.plugin.zsh

