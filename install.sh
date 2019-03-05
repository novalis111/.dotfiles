#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function install() {
    command -v 'bc' &>/dev/null || echo "You need to install 'bc' package for tmux version check"
    DC="${HOME}/.config/direnv/direnvrc"
    FC="${HOME}/.config/fish/config.fish"
    BC="${HOME}/.dotfiles/.my_bash"
    echo "Syncing dotfiles to home directory..."
    cp .tmux.conf ${HOME}/
    if [ -d ${HOME}/.config/direnv ]; then
        cp .dotenvrc ${HOME}/.config/direnv/direnvrc
    else
        echo "Notice: direnv not installed, skipping config"
    fi
    # fish shell
    if [ -f /usr/bin/vim ]; then
        EDITOR="/usr/bin/vim"
    fi
    if [ -f ${FC} ]; then
	    grep -q 'direnv hook' ${FC} || echo "eval (direnv hook fish)" >> ${FC}
        if [ -n ${EDITOR} ]; then
            grep -q 'EDITOR' ${FC} || echo "set -x EDITOR $EDITOR" >> ${FC}
        fi
        grep -q 'my_aliases' ${FC} || cat .my_aliases >> ${FC}
    else
	     echo "Notice: fish shell not installed, skipping config"
    fi
    # bash shell
    grep -q '.dotfiles\/.my_bash' ${HOME}/.bashrc || echo "[ -r ~/.dotfiles/.my_bash ] && . ~/.dotfiles/.my_bash" >> ${HOME}/.bashrc
    # vim
    wget -q https://raw.githubusercontent.com/amix/vimrc/master/vimrcs/basic.vim -O ~/.vimrc
    echo "Done :)"
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
