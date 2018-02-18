#!/bin/bash

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export GOPATH="$HOME/workspace/go"
export PATH="$PATH:$GOPATH/bin"

# Copies the current path to the clipboard
alias cpdir="pwd | tr -d '\n' | pbcopy"

# Attached a session if it has been detached from or create a new one
alias startTmux='(tmux ls | grep -vq attached && tmux at) || tmux'

