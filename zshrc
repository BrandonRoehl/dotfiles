#!/usr/bin/env zsh
# Source the shared between sh bash and zsh
source "$HOME/.profile"

# Add antigen and plugins
export ANTIGEN_LOG='/dev/stdout'
export ADOTDIR="$HOME/.zsh/bundle"
source "$HOME/.zsh/antigen/antigen.zsh"
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
# antigen bundle zsh-users/zsh-history-substring-search

antigen bundle BrandonRoehl/zsh-clean
# antigen bundle "$HOME/workspace/zsh-clean" --no-local-clone

# Tell Antigen that you're done.
antigen apply

setopt prompt_subst
setopt correct
setopt EXTENDED_GLOB
# This instead for bash like glob
# setopt KSH_GLOB

# Setopt for testing zsh plugins
# setopt WARN_CREATE_GLOBAL

# Enable colored output for ls
export CLICOLOR=1 # MacOS
# For Linux or MacOS with brew install coreutils
if which dircolors &>/dev/null
then
    alias ls='ls --color=auto --classify'
    eval $(dircolors)
fi
alias grep='grep --color=auto'

autoload -U colors
colors

# Add the iTerm integration
if [ -f "$HOME/.iterm2_shell_integration.zsh" ]; then
    source "$HOME/.iterm2_shell_integration.zsh"
fi

# The following lines were added by compinstall

zstyle ':completion:*' auto-description '%d'
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' use-compctl true
zstyle ':completion:*' verbose true
zstyle ':completion:*' use-cache true
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install

# export PATH="$PATH:$HOME/workspace/universe/bin"

