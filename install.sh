#!/bin/bash

# to install colorful-prompt using this script execute the following command on target machine:
# curl https://raw.githubusercontent.com/zeionara/colorful-prompt/master/install.sh -s | bash 

lua_version=${LUA_VERSION:-5.4}

quit () {
    echo $1
    exit 1
}

install_lua () {
    echo 'installing lua...'
    sudo apt-get update
    sudo apt-get install lua$lua_version | quit 'cannot install lua'
}

lua -v | install_lua

echo 'cloning repo...'

git clone https://github.com/zeionara/colorful-prompt.git $HOME/colorful-prompt || quit 'cannot clone repo'

echo 'updating bashrc...'

echo -e '\nsource $HOME/colorful-prompt/colorful-prompt.sh\n' >> ~/.bashrc || quit 'cannot ubdate .bashrc'

echo 'finished installing colorful-prompt'
