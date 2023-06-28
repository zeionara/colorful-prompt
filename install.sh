#!/bin/bash

# to install colorful-prompt using this script execute the following command on target machine:
# curl https://bit.ly/setup-colorful-prompt -s | bash 

lua_version=${LUA_VERSION:-5.3}

bashrc_root="$HOME/bashrc"

quit () {
    echo $1
    exit 1
}

echop () {
    echo "🚩 $@"
}

patch_bashrc () {
    if test -d "$bashrc_root"; then
        echo -e "$1" >> $bashrc_root/etc/main.sh || quit 'Cannot update bashrc'
    else
        echo -e "$1" >> $HOME/.bashrc || quit 'Cannot update bashrc'
    fi

    . $HOME/.bashrc
}

install_lua () {
    echop 'Installing lua...'

    sudo apt-get update
    sudo apt-get install lua$lua_version || quit 'cannot install lua'
}

echo '🏁 Installing colorful-prompt. Checking if lua is already installed...'

if test -z $(which lua); then
    install_lua
else
    echop 'Found an existing lua installation'
fi

echop 'Cloning colorful-prompt repo...'

git clone https://github.com/zeionara/colorful-prompt.git "$HOME/colorful-prompt" || quit 'Cannot clone colorful-prompt repo'

echop 'Updating bashrc...'

patch_bashrc '\n. $HOME/colorful-prompt/colorful-prompt.sh\n'

echop 'Finished installing colorful-prompt'
