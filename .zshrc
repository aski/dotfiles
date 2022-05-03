# Download zplug if it is not installed
if [[ ! -d "$HOME/.zplug" ]]; then
    git clone -q --depth 1 --branch master \
        --single-branch https://github.com/zplug/zplug "$HOME/.zplug"
    source "$HOME/.zplug/init.zsh" && zplug update
fi

# Download fzf command-line fuzzy finder if it is not installed
if [[ ! -d "$HOME/.fzf" ]]; then
    git clone -q --depth 1 --branch master \
        --single-branch https://github.com/junegunn/fzf "$HOME/.fzf"
    "$HOME/.fzf/install" --all
fi

source "$HOME/.zplug/init.zsh"

zplug "zplug/zplug"
zplug "yous/vanilli.sh"

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:3

# needed for pure prompt
zplug "mafredri/zsh-async", from:github

zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

zplug "plugins/colored-man-pages",  from:oh-my-zsh, as:plugin

zplug check --verbose || zplug install
zplug load

setopt nohist_findnodups
setopt inc_append_history
setopt share_history

# ... because vim keybindings in the shell are strange
set -o emacs

command -v kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)
command -v helm    >/dev/null 2>&1 && source <(helm completion zsh)

[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

[ -f  "$HOME/.dir_colors" ] && eval $(dircolors "$HOME/.dir_colors")
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Load local customizations from ~/.zshrc.local
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -d ~/.sdkman ] && export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
