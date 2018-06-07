#!/bin/bash
#brew install coreutils
#$(brew --prefix coreutils)

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH:$HOME/.zsh/bin"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export GOPATH="$HOME/workspace/go"
export PATH="$PATH:$GOPATH/bin"

# Universe
export PATH="$PATH:$HOME/.universe/bin" # Add RVM to PATH for scripting
# Use GPG
export GPG_TTY=$(tty)

# Copies the current path to the clipboard
alias cpdir="pwd | tr -d '\n' | pbcopy"

# Attached a session if it has been detached from or create a new one
alias startTmux='(tmux ls | grep -vq attached && tmux at) || tmux'

alias ':q'='exit'
alias 'x'='exit'

alias initJamf="git init --template '$HOME/Dropbox (JAMF Software)/git_template'"

