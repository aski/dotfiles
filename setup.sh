#!/usr/bin/env bash

DIR=$(dirname "$(realpath "$0")")

FILES=(
.aliases
.bashrc
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
