#!/bin/sh
#brew install coreutils
#$(brew --prefix coreutils)
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:/usr/local/opt/openssl/bin:/opt/homebrew/bin:$PATH:$HOME/.zsh/bin"
export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export GOPATH="$HOME/workspace/go"
export PATH="$PATH:$(go env GOPATH)/bin"

# Flutter
export PATH="$PATH:/etc/google-cloud-sdk/bin"

# Flutter
export PATH="$PATH:$HOME/workspace/flutter/bin"

# brew install libpq
export PATH="/usr/local/opt/libpq/bin:$PATH"

# PIPx
export PATH="$PATH:$HOME/.local/bin"
# Use GPG
export GPG_TTY=$(tty)

# Auto git template
export GIT_TEMPLATE_DIR="$HOME/.gitconf/git_template"

# Add pyenv executable to PATH and
# enable shims by adding the following
# to ~/.profile and ~/.zprofile:
#
export PYENV_ROOT="$HOME/.pyenv"
if test -d $PYENV_ROOT
then
    # Load pyenv into the shell by adding
    # the following to ~/.zshrc:
    export PATH="$PYENV_ROOT/bin:$HOME/.local/bin:$PATH"
    eval "$(pyenv init --path)"
fi


# Copies the current path to the clipboard
alias cpdir="pwd | tr -d '\n' | pbcopy"

# Attached a session if it has been detached from or create a new one
alias startTmux='(tmux ls | grep -vq attached && tmux at) || tmux'

alias fix_xcode="rm -rf '$HOME/Library/Developer/Xcode/DerivedData'"

alias ':q'='exit'
alias 'x'='exit'
if type 'nvim' > /dev/null
then
    export EDITOR="nvim"
    alias vim='nvim'
    alias vi='nvim'
elif type 'vim' > /dev/null
then
    export EDITOR="vim"
else
    export EDITOR="vi"
fi
#if [ -n "$WSL_DISTRO_NAME" ]; then
#    alias git="git.exe"
#    alias ssh="ssh.exe"
#fi

function start_idf() {
    source "$HOME/esp/esp-idf/export.sh"
    source "$HOME/esp/esp-matter/export.sh"
}

function useJava() {
    if [[ ! -z $1 ]]; then
        local jvm
        jvm=$(/usr/libexec/java_home -v "$1")
        if [[ $? -eq 0 ]]; then
            export JAVA_HOME=$jvm
            java -version
        fi
    fi
}

alias 'sourcegraph'="docker run --publish 7080:7080 --publish 2633:2633 --rm --volume ~/.sourcegraph/config:/etc/sourcegraph --volume ~/.sourcegraph/data:/var/opt/sourcegraph sourcegraph/server:3.3.7"

function listening() {
    if [ $# -eq 0 ]; then
        lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        lsof "-iTCP:$1" -sTCP:LISTEN -n -P
    else
        echo 'Usage: listening [pattern]'
        return 1
    fi
}

function git-who() {
    git ls-files | while read f; do git blame --line-porcelain $f | grep '^author '; done | sort -f | uniq -ic | sort -n
}

