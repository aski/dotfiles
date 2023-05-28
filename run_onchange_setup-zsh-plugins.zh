#!/usr/bin/env bash

PLUGINS_DIR="$HOME/.local/share/zsh/plugins"
mkdir -p "$PLUGINS_DIR"

if [ ! -d "$PLUGINS_DIR/yous/vanilli.sh" ]; then
    git clone https://github.com/yous/vanilli.sh.git "$PLUGINS_DIR/yous/vanilli.sh"
fi

if [ ! -d "$PLUGINS_DIR/zsh-users/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-completions.git "$PLUGINS_DIR/zsh-users/zsh-completions"
fi

if [ ! -d "$PLUGINS_DIR/zsh-users/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$PLUGINS_DIR/zsh-users/zsh-autosuggestions"
fi

if [ ! -d "$PLUGINS_DIR/zsh-users/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-users/zsh-syntax-highlighting"
fi

if [ ! -d "$PLUGINS_DIR/mafredri/zsh-async" ]; then
    git clone https://github.com/mafredri/zsh-async.git "$PLUGINS_DIR/mafredri/zsh-async"
fi

if [ ! -d "$PLUGINS_DIR/sindresorhus/pure" ]; then
    git clone https://github.com/sindresorhus/pure.git "$PLUGINS_DIR/sindresorhus/pure"
fi
