#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function install() {
    echo "Syncing dotfiles to home directory..."
    cp .tmux.conf ~/
    FC="~/.config/fish/config.fish"
    if [ -f ${FC} ]; then
	    grep -q 'direnv hook' ${FC} || echo "eval (direnv hook fish)" >> ${FC}
    else:
        echo "eval (direnv hook fish)" >> ${FC}
    fi
    grep -q '.dotfiles\/.my_bash' || echo "if [ -f ~/.dotfiles/.my_bash ]; then . ~/.dotfiles/.my_bash; fi" >> ~/.bashrc
    echo "done"
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    install;
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install;
    fi;
fi;
unset install;
