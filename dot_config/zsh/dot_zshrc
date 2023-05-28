ZSH_PLUGINS="$HOME/.local/share/zsh/plugins"

source "$ZSH_PLUGINS/yous/vanilli.sh/vanilli.zsh"
source "$ZSH_PLUGINS/zsh-users/zsh-completions/zsh-completions.plugin.zsh"
source "$ZSH_PLUGINS/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
source "$ZSH_PLUGINS/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
source "$ZSH_PLUGINS/mafredri/zsh-async/async.plugin.zsh"
source "$ZSH_PLUGINS/sindresorhus/pure/pure.plugin.zsh"

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
[ -f "$ZDOTDIR/.zshrc.local" ] && source "$ZDOTDIR/.zshrc.local"

[ -f "$XDG_CONFIG_HOME/fzf/fzf.zsh" ] && source "$XDG_CONFIG_HOME/fzf/fzf.zsh"

[ -d ~/.sdkman ] && export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
