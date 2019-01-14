#!/bin/sh
#brew install coreutils
#$(brew --prefix coreutils)

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH:$HOME/.zsh/bin"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export GOPATH="$HOME/workspace/go"
export PATH="$PATH:$GOPATH/bin"

# Flutter
export PATH="$PATH:/etc/google-cloud-sdk/bin"

# Flutter
export PATH="$PATH:$HOME/workspace/flutter/bin"

# Universe
export PATH="$PATH:$HOME/.universe/bin" # Add RVM to PATH for scripting
# Use GPG
export GPG_TTY=$(tty)

# Auto git template
export GIT_TEMPLATE_DIR="$HOME/.gitconf/git_template"

# Copies the current path to the clipboard
alias cpdir="pwd | tr -d '\n' | pbcopy"

# Attached a session if it has been detached from or create a new one
alias startTmux='(tmux ls | grep -vq attached && tmux at) || tmux'

alias ':q'='exit'
alias 'x'='exit'
# if type 'nvim' > /dev/null; then
    # alias vim='nvim'
# fi

function useJava() {
    if [[ ! -z $1 ]]; then
        local jvm
        jvm=`/usr/libexec/java_home -v $1`
        if [[ $? -eq 0 ]]; then
            export JAVA_HOME=$jvm
            java -version
        fi
    fi
}

