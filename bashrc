# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
HISTCONTROL=erasedups
export HISTIGNORE="pwd:ls:ll:lt:fg"
shopt -s histappend

HISTSIZE=
HISTFILESIZE=

alias lt='ls -ltr'

#less latest file in directory
lless()
{
	ls -1dt "$1"/* | head -1 | xargs less
}

TITLEBAR='\[\e]0;\h:\w\a\]'
PS1="${TITLEBAR}\h> "
