# Download zplug if it is not installed
export ZPLUG_HOME="$XDG_DATA_HOME/zplug"
export ZPLUG_ROOT="$XDG_DATA_HOME/zplug"

if [[ ! -d "$ZPLUG_HOME" ]]; then
    git clone -q --depth 1 --branch master \
        --single-branch https://github.com/zplug/zplug "$ZPLUG_HOME"
    source "$ZPLUG_HOME/init.zsh" && zplug update
fi

# Download fzf command-line fuzzy finder if it is not installed
if [[ ! -d "$XDG_DATA_HOME/fzf" ]]; then
    git clone -q --depth 1 --branch master \
        --single-branch https://github.com/junegunn/fzf "$XDG_DATA_HOME/fzf"
    "$XDG_DATA_HOME/fzf/install" --all --xdg --no-update-rc
fi

source "$ZPLUG_HOME/init.zsh"
zplug "zplug/zplug"
zplug "yous/vanilli.sh"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:3
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug check --verbose || zplug install
zplug load

setopt nohist_findnodups
setopt inc_append_history
setopt share_history

set -o emacs

command -v kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)
command -v helm    >/dev/null 2>&1 && source <(helm completion zsh)

export LANG="en_US"
export LC_ALL="en_US.UTF-8"

export ANSIBLE_NOCOWS=1
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export EDITOR='nvim'
export MANPAGER="nvim +Man!"
export MAVEN_OPTS='-Xmx4096m -Xms1024m -XX:PermSize=512m -XX:MaxPermSize=512m'
export PAGER='less'
export PATH=$HOME/bin/node/bin:$HOME/bin:$PATH
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export VISUAL='nvim'
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export HISTFILE="$XDG_STATE_HOME"/zsh/history


[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f "$XDG_DATA_HOME/cargo/env" ] && source "$XDG_DATA_HOME/cargo/env"

[ -f  "$XDG_CONFIG_HOME/.dir_colors" ] && eval $(dircolors "$XDG_CONFIG_HOME/.dir_colors")
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Load local customizations from zshrc.local
[ -f "$ZDOTDIR/zshrc.local" ] && source "$ZDOTDIR/zshrc.local"

[ -f "$XDG_CONFIG_HOME/fzf/fzf.zsh" ] && source "$XDG_CONFIG_HOME/fzf/fzf.zsh"

[ -d ~/.sdkman ] && export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
