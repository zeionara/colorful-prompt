# Colorful prompt

Project that allows you to set up a better prompt which arguably is more beatiful than the default one and provides you more information about your environment.

![example of the new prompt look](example.jpg)

# Installation

The script mainly rely on `lua` and `git`, so they must be installed in your system for the new prompt to work. To enable the new look you should make links to the files `colorful-prompt.sh` and `stringify-time.lua` under your home directory, and then you will need to update your `.bashrc` configuration file (which is located in the home directory as well) by including the following line in any place:

```sh
source $HOME/colorful-prompt.sh
```