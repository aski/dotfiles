# Download zplug if it is not installed
if [[ ! -d ~/.zplug ]]; then
    git clone -q --depth 1 --branch master \
        --single-branch https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update
fi

# Download fzf command-line fuzzy finder if it is not installed
if [[ ! -d ~/.fzf ]]; then
    git clone -q --depth 1 --branch master \
        --single-branch https://github.com/junegunn/fzf ~/.fzf
    ~/.fzf/install --all
fi

source ~/.zplug/init.zsh

zplug "zplug/zplug"
zplug "yous/vanilli.sh"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:3
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "changyuheng/zsh-interactive-cd"
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

if zplug check zsh-users/zsh-history-substring-search; then
    bindkey '^[OA' history-substring-search-up
    bindkey '^[OB' history-substring-search-down
fi

[ -f  ~/.dir_colors ] && eval $(dircolors ~/.dir_colors)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.aliases ] && source ~/.aliases

# Load local customizations from ~/.zshrc.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

[ -d ~/.sdkman ] && export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "/home/andreask/.sdkman/bin/sdkman-init.sh" ]] && source "/home/andreask/.sdkman/bin/sdkman-init.sh"
