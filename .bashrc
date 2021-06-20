# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

HISTFILESIZE=20000
HISTSIZE=10000

# List of commands that shouldn't be added to the history
HISTIGNORE="ls:ps:history:exit"

# Avoid duplicates in history
HISTCONTROL=ignoredups:erasedups

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# Save all lines of a multi-line command in the same history entry
shopt -s cmdhist

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# The pattern "**" used in a pathname expansion context will match all files and zero or more
# directories and subdirectories.
shopt -s globstar

# Automatically correct misspelled directory names
shopt -s cdspell

# Change into directories by just typing the directory name without 'cd'
shopt -s autocd

# When using history substitution, only show the resulting command instead of executing it immediately
shopt -s histverify

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Set colors for the ls command
if [ -x /usr/bin/dircolors ]; then
    if [ -f ~/.dircolors ]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
fi

# Import shell aliases
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

# Load bash completions
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

git_branch_dirty() {
    [[ -z $(git status --porcelain 2> /dev/null) ]] || echo "*"
}

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Set up prompt
export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]$(parse_git_branch)$(git_branch_dirty)\n> '

# Make man pages easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi

# Keep these commands at the end of the file
[ -s "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"
[ -d "$HOME/.sdkman" ] && export SDKMAN_DIR="$HOME/.sdkman"
[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"
