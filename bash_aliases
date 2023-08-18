# .bash_aliases
#
# calling this .bash_aliases instead of .bashrc so that there can be a local
#   .bashrc specific to each system and then this can be my standard settings
#   across all systems
#
# often .bashrc files set to call .bash_aliases already, but if not add the
#   following to the .bashrc file after anything you want to overwrite:
#
# if [ -f ~/.bash_aliases ]; then
#     . ~/.bash_aliases
# fi

# add user bin directory to path
PATH=$PATH:~/bin

# set up to store history across multiple simultaneous sessions
HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%F %T  "
shopt -s histappend

HISTSIZE=
HISTFILESIZE=

# create a persistent history across all sessions
log_bash_persistent_history()
{
    [[
    $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$
    ]]
    local date_part="${BASH_REMATCH[1]}"
    local command_part="${BASH_REMATCH[2]}"
    #shopt -s extglob
    command_part="${command_part##*( )}" # trim leading whitespace
    command_part="${command_part%%*( )}" # trim trailing whitespace
    #shopt -u extglob
    case "$command_part" in
        pwd | l | l[alts] | ps | vi | exit | ipython | vdvsql | snowsql | dpsql)
            # ignore, we don't need to keep these simple commands
            ;;
        "git st" | "git diff" | "git lg" | "git log" | "git branch")
            # ignore, don't really care about these, either
            ;;
        postgresp | prometheus | copypass\ * | copyppass\ *)
            # or these
            ;;
        tmx | tmx\ * | tma\ * | "tmux ls" | "tmux a*")
            # or simple tmux commands
            ;;
        "vi ~/.persistent_history" | "vi ~/.bash_aliases")
            # or these
            ;;
        "$PERSISTENT_HISTORY_LAST")
            # don't need to keep repeated commands, either
            ;;
        *)
            echo $date_part "|" "$command_part" >> ~/.persistent_history
            export PERSISTENT_HISTORY_LAST="$command_part"
            ;;
    esac
}
run_on_prompt_command()
{
    log_bash_persistent_history
}

# User specific aliases and functions
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

tmx()
{
    # create new session with given name
    # split twice; splits done so that in full screen left two panes
    #   have enough space for just over 80 characters with my vi settings
    # attach
    tmux new-session -s ${1:-default} \; \
        split-window -h -p 68 \; \
        split-window -h -p 53 \; \
        attach
}

alias tma='tmux attach -t $1'
if [ -f /etc/bash_completion.d/tma ]; then
    . /etc/bash_completion.d/tma
fi

copypass()
{
    # copy vertica password to clipboard for use elsewhere
    # $1 - user to get pass for
    # grep - pull password out of vdvsql
    # tail - only last line pulled has password
    # sed - extract password from line
    # clip.exe - copy to clipboard
    grep -A2 "$1)" ~/bin/vdvsql \
        | tail -1 \
        | sed -rn  "s/^[\t ]*VPASS='(.*)'$/\1/p" \
        | clip.exe
}

copyppass()
{
    # copy postgres password to clipboard for use elsewhere
    # $@ - args used by dpsql to connect to user
    # ~/bin/dpsql dryrun - get the connection information
    # sed - combine connection information to single string
    # xargs -ifoo - pass input to grep command (replace foo with input)
    #   grep finds right line, cut selects fifth element-the password
    #   clip.exe - copy to clipboard
    ~/bin/dpsql dryrun "$@" \
        | sed "s/ /:/g" \
        | xargs -ifoo grep -m 1 -E "foo:" ~/.pgpass | cut -d: -f5 \
        | clip.exe
}

snowsqlf()
{
    # run snowflake query from file and dump all the extra garbage
    #   so output can be sent to file cleanly
    # friendly=false -- turn off startup and exit messages
    # timing=false -- don't output query time or number of records
    # sed '/^$/d' -- remove empty lines
    # sed '/^-- [^\t]*$/d' -- remove commented lines (without tabs)
    snowsql \
        -o friendly=false \
        -o timing=false \
        -o output_format=tsv \
        -f $1 \
        | sed '/^$/d' \
        | sed '/^-- [^\t]*$/d'
}

# \u - username
# \h - hostname up to first '.'
# \H - full hostname
# \w - full path
# \W - tail of path
# \[\033[XXm\] - set color

PS1="\[\033[36m\]\u@\H \[\033[32m\]\W\[\033[36m\] >\[\033[00m\] "
PROMPT_COMMAND="run_on_prompt_command"
