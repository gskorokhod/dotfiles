# vim: foldmethod=marker foldmarker=#START,#END ft=bash

#START Colour aliases
########################################################
#                    COLOUR ALIASES                    #
########################################################

#https://scriptim.github.io/bash-prompt-generator/
#https://stackoverflow.com/questions/4133904/ps1-line-with-git-current-branch-and-colors

# List of ANSI escape sequences: https://misc.flogisoft.com/bash/tip_colors_and_formatting
# echo -e to allow escape sequences

# escape all non printable chars using \[...\]
# see: https://unix.stackexchange.com/questions/28827/why-is-my-bash-prompt-getting-bugged-when-i-browse-the-history
CLEARALL='\[\e[0m\]'
BOLD='\[\e[1m\]'
CLEARBOLD='\[\e[21m\]'
DIM='\[\e[2m\]'
CLEARDIM='\[\e[22m\]'

# use 16 colour scheme
# foreground cols
COL_DEFAULT='\[\e[39m\]'
BLACK='\[\e[30m\]'
RED='\[\e[31m\]'
GREEN='\[\e[32m\]'
YELLOW='\[\e[33m\]'
BLUE='\[\e[34m\]'
MAGENTA='\[\e[35m\]'
CYAN='\[\e[36m\]'
LGRAY='\[\e[37m\]'

DGRAY='\[\e[90m\]'
LRED='\[\e[91m\]'
LGREEN='\[\e[92m\]'
LYELLOW='\[\e[93m\]'
LBLUE='\[\e[94m\]'
LMAGENTA='\[\e[95m\]'
LCYAN='\[\e[96m\]'
WHITE='\[\e[97m\]'

B_DGRAY='\[\e[01;90m\]'
B_LRED='\[\e[01;91m\]'
B_LGREEN='\[\e[01;92m\]'
B_LYELLOW='\[\e[01;93m\]'
B_LBLUE='\[\e[01;94m\]'
B_LMAGENTA='\[\e[01;95m\]'
B_LCYAN='\[\e[01;96m\]'
B_WHITE='\[\e[01;97m\]'
#END


#START Utilities
function i_am_mac() {
  [ $(uname) = "Darwin" ]
}

function i_am_labs() {
  [ $(uname) = "Linux" ] && [ $(whoami) = "gs248" ]
}

function i_am_bigboi() {
  [ $(uname) = "Linux" ] && [ $(hostname) == "bigboi" ] && [ $(whoami) = "mayday" ]
}

function i_am_laptop() {
  [ $(uname) = "Linux" ] && [ $(hostname) == "fedora" ] && [ $(whoami) = "mayday" ]
}

function i_am_work() {
  [ $(uname) = "Linux" ] && [ $(whoami) = "gskorokhod" ]
}

function i_am_root() {
  [ $(whoami) = "root" ]
}
#END


#START debian config
# set variable identifying the chroot you work in
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
#END debian config


#START Prompt 
if i_am_labs
then
  ICON=
  COL=$B_LBLUE
elif i_am_work
then
  ICON=
  COL=$B_LMAGENTA
elif i_am_bigboi
then
  ICON=
  COL=$LYELLOW
elif i_am_laptop
then
  ICON=
  COL=$B_LGREEN
else
  ICON=
  COL=$B_LCYAN
fi

[ -e ~/.bash/git-prompt.sh ] && source ~/.bash/git-prompt.sh

# show previous 3 directories, then use ...
export PROMPT_DIRTRIM=3

colour_my_prompt () {
    local __chroot_debian="${debian_chroot:+($debian_chroot)}"
    local __icon="$BOLD$COL$ICON$CLEARALL"
    local __host="$BOLD$COL\u@\h$CLEARALL"
    local __current_dir="$BOLD$YELLOW\w$CLEARALL"
    local __line_end="$COL>$CLEARALL "

    # see https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
    export GIT_PS1_SHOWDIRTYSTATE=1

    # Check if git PS1 is empty. If not, output it prefixed with a space. This helps avoid double spaces when git PS1 is empty.
    local __git='$(git_branch=$(__git_ps1 "%s"); if [[ -n $git_branch ]]; then echo -n " '$B_LRED'(${git_branch})'$CLEARALL'"; fi)'

    # Run __git to actually generate the git status and substitute it into the prompt
    export PS1="$__icon $__chroot_debian $__host $__current_dir${__git} $__line_end"

    # If this is an xterm set the title to user@host:dir
    if [[ "$TERM" == xterm* ]] || [[ "$TERM" == rxvt* ]]; then
        export PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    fi
}
#END
