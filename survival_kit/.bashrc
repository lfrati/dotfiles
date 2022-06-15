# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
PATH=$PATH:$HOME/bin

# from https://unix.stackexchange.com/a/20413
[ -z "$PS1" ] && return
function cd {
    builtin cd "$@" && ls -F
}

# https://michurin.github.io/xterm256-color-picker/
# use lightblue to distinguish from my local pink
export PS1="\[\033[38;5;75m\]\n \w\n ❯ \[\033[0m\]"
