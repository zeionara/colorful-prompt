#!/bin/bash

# to install colorful-prompt using this script execute the following command on target machine:
# curl https://bit.ly/setup-colorful-prompt -s | bash 

lua_version=${LUA_VERSION:-5.3}

quit () {
  echo $1
  exit 1
}

echop () {
  echo "🚩 $@"
}

patch_bashrc () {
  echo -e "$1" >> $HOME/.bashrc || quit 'Cannot update bashrc'

  . $HOME/.bashrc
}

install_lua () {
  echop 'Installing lua...'

  if test ! -z $(which pacman 2> /dev/null); then
    sudo pacman -Syu
    sudo pacman -S lua
  elif test ! -z $(which apt-get 2> /dev/null); then
    sudo apt-get update
    sudo apt-get install lua$lua_version || quit 'cannot install lua'
  elif test ! -z $(which emerge 2> /dev/null); then
    sudo emerge --ask dev-lang/lua
  else
    quit "Can't install lua"
  fi
}

echo '🏁 Installing colorful-prompt. Checking if lua is already installed...'

if test -z $(which lua 2> /dev/null); then
    install_lua
else
    echop 'Found an existing lua installation'
fi

echop 'Cloning colorful-prompt repo...'

git clone https://github.com/zeionara/colorful-prompt.git "$HOME/colorful-prompt" || quit 'Cannot clone colorful-prompt repo'

echop 'Updating bashrc...'

patch_bashrc '\n. $HOME/colorful-prompt/colorful-prompt.sh\n'

echop 'Finished installing colorful-prompt'
