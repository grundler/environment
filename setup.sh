#!/bin/bash -
#===============================================================================
#
#          FILE: setup.sh
#
#         USAGE: . setup.sh
#
#   DESCRIPTION: Set personal configuration files as links to this directory
#					to make it simple to put configurations in git and use them
#					across multiple machines
#
#===============================================================================

set -o nounset                              # Treat unset variables as an error

function setfile {
	SOURCE=$1
	TARGET=$2
	if [ -L "$TARGET" ]; then
		rm $TARGET
	elif [ -f "$TARGET" ]; then
		mv $TARGET ${TARGET}_save
	fi
	ln -s $SOURCE $TARGET
}

#ipython
FILE=common_imports.py
setfile $PWD/ipython/$FILE $HOME/.ipython/profile_default/startup/$FILE

declare -a HOMEFILES=(bash_aliases vimrc inputrc gitconfig tmux.conf)
for FILE in "${HOMEFILES[@]}"; do
    setfile $PWD/$FILE $HOME/.$FILE
done

# check if .bashrc calling for bash aliases
#   probably not perfect
grep -E "^\s*\.\s+~/\.bash_aliases" $HOME/.bashrc >& /dev/null
if [ $? -ne 0 ]; then
    echo "looks like we need to source .bash_aliases in ~/.bashrc"
fi
