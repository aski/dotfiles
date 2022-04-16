#!/usr/bin/env bash

DIR=$(dirname "$(realpath "$0")")

FILES=(
.aliases
.bashrc
.curlrc
.dir_colors
.editrc
.gitconfig
.gitignore
.ideavimrc
.inputrc
.tmux.conf
.vimrc
.zshenv
.zshrc
)

for f in "${FILES[@]}"
do
    if [ ! -e "$HOME"/"$f" ]; then
        ln -s "$DIR"/"$f" "$HOME"/"$f"
    elif [ -L "$HOME/$f" ]; then
        if [ "$(readlink -- "$HOME/$f")" != "$DIR/$f" ]; then
            echo "$HOME/$f is linked to another location"
        fi
    else
        echo "$HOME/$f already exists"
    fi
done

mkdir -p ~/.vim/autoload
mkdir -p ~/.config/nvim

if [ ! -e ~/.vim/after ]; then
    ln -s ~/.dotfiles/after/ ~/.vim/after
fi

if [ ! -e ~/.config/nvim/autoload ]; then
    ln -s ~/.vim/autoload ~/.config/nvim/autoload
fi

if [ ! -e ~/.config/nvim/after ]; then
    ln -s ~/.vim/after ~/.config/nvim/after
fi

if [ ! -e ~/.config/nvim/init.vim ]; then
    ln -s ~/.vimrc ~/.config/nvim/init.vim
fi

if [ ! -e ~/.config/nvim/lua ]; then
    ln -s "$DIR"/lua ~/.config/nvim/lua
fi
