#!/usr/bin/env bash

if ! command -v stow &> /dev/null
then
    echo "stow not installed"
    exit
fi

packages=(
 curl
 dircolors
 editline
 git
 ideavim
 nvim
 readline
 shell
 tmux
)

for p in "${packages[@]}"; do
    echo "# $p"
    stow -vv "$p"
    echo -e ""
done
