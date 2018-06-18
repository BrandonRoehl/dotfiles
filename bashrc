# Set up AndroidSDK for adb
export PATH="$PATH:$HOME/AndroidSDK/platform-tools/:$HOME/.scripts"
# Color bash
export TERM=xterm-256color
export CLICOLOR=1

# Use Apple command line developer tools
# Using implicit path
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
source "$(xcode-select -p)/usr/share/git-core/git-completion.bash"
source "$(xcode-select -p)/usr/share/git-core/git-prompt.sh"
# source "$HOME/.profile"
test -e "$HOME/.iterm2_shell_integration.bash" && source "$HOME/.iterm2_shell_integration.bash"
if [ -f 'brew --prefix'/etc/bash_completion ]; then
    . 'brew --prefix'/etc/bash_completion
fi

# This is the stuff for making bash pretty
export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\W\[\033[0m\]$(__git_ps1 "\[\033[1;33m\](\[\033[0;35m\]⎇ %s\[\033[1;33m\])") \[\033[1;36m\]\u\[\033[0m\]$ '

# Reload the bashrc
function reload {
    source ~/.bashrc
    echo 'reloaded'
}

# Prints out the current bash version
alias version='echo $BASH_VERSION'

# Create a blank java main method
function mkmainJava {
    if [ $# -eq 0 ]
    then
        echo 'Need class name argument'
    else
        for CLASS in $@
        do
            if [ -f "$CLASS.java" ]
            then
                echo "$CLASS.java already exists"
            else
                echo "public class $CLASS {" >> "$CLASS.java"
                echo "    public static void main(String[] args){" >> "$CLASS.java"
                echo "        " >> "$CLASS.java"
                echo "    }" >> "$CLASS.java"
                echo "}" >> "$CLASS.java"
                echo "$CLASS.java with main was created successfully"
            fi
        done
    fi
}

# added by travis gem
[ -f /Users/BrandonRoehl/.travis/travis.sh ] && source /Users/BrandonRoehl/.travis/travis.sh
