#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function install() {
    echo "Syncing dotfiles to home directory..."
	cp .tmux.conf ${HOME}/
    cp .dotenvrc ${HOME}/.config/direnv/direnvrc
    FC="${HOME}/.config/fish/config.fish"
    if [ -f /usr/bin/vim ]; then
        EDITOR="/usr/bin/vim"
    fi
    if [ -f ${FC} ]; then
	    grep -q 'direnv hook' ${FC} || echo "eval (direnv hook fish)" >> ${FC}
	    grep -q 'alias ll' ${FC} || echo "alias ll 'ls -lah'" >> ${FC}
        if [ -n ${EDITOR} ]; then
            grep -q 'EDITOR' ${FC} || echo "set -x EDITOR $EDITOR" >> ${FC}
        fi
    else
        echo "eval (direnv hook fish)" >> ${FC}
        echo "alias ll 'ls -lah'" >> ${FC}
        if [ -n ${EDITOR} ]; then
            echo "set -x EDITOR $EDITOR" >> ${FC}
        fi
    fi
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
