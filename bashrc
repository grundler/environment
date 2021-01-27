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

alias ls='ls -F --color=auto'
alias ll='ls -lh'
alias lt='ll -tr'
alias la='ll -A'
alias l='ls -l'
alias vi=vim

# less latest file in directory
lless()
{
	ls -1dt "$1"/* | head -1 | xargs less
}

# word diff
worddiff()
{
    # -U0 means no context around different lines
    # --word-diff option puts [- -]{+ +} around changed words
    # --no-index means ignore git index, just look at two given paths
    git diff -U0 --word-diff --no-index $1 $2
}

# \u - username
# \h - hostname up to first '.'
# \H - full hostname
# \w - full path
# \W - tail of path
# \[\033[XXm\] - set color

#TITLEBAR='\[\e]0;\u@\H:\w\a\]'
#PS1="${TITLEBAR}\[\033[36m\]\u@\H \[\033[32m\]\W >\[\033[00m\] "
PS1="\[\033[36m\]\u@\H \[\033[32m\]\W\[\033[36m\] >\[\033[00m\] "
