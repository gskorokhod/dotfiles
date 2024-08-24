# Sample .bashrc for SUSE Linux
# Copyright (c) SUSE Software Solutions Germany GmbH

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# vim: foldmethod=marker foldmarker=#START,#END ft=bash

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

test -s "$HOME/.alias" && . "$HOME/.alias" || true

#START history
HISTCONTROL=ignoreboth # don't put duplicate lines or lines starting with space in the history
shopt -s histappend    # append to the history file, don't overwrite it
HISTSIZE=1000
HISTFILESIZE=2000
#END history

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

#START conda setup
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/mayday/Applications/anaconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "/home/mayday/Applications/anaconda3/etc/profile.d/conda.sh" ]; then
		. "/home/mayday/Applications/anaconda3/etc/profile.d/conda.sh"
	else
		export PATH="/home/mayday/Applications/anaconda3/bin:$PATH"
	fi
fi
unset __conda_setup
# <<< conda initialize <<<
#END conda setup

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Required for school systems not to break
[ -e /etc/bashrc ] && source /etc/bashrc

#START Env for rust, haskell, etc
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"                 # cargo-env
[ -f "$HOME/.cabal/bin/ghc-env" ] && source "$HOME/.cabal/bin/ghc-env" # ghc-env
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"                      # ghcup-env
#END Env for rust, haskell, etc

#START path
DIRS_TO_ADD=(
	"/usr/local/python/bin" # school installs custom python bins here!!
	"$HOME/.local/bin"
	"$HOME/.cargo/bin"
	"$HOME/uni/bin"
	"$HOME/.idris2/bin"
	"$HOME/.pack/bin"
	"$HOME/miniconda3/bin"
	"$HOME/.cabal/bin"
	"$HOME/.ghcup/bin"
	"$HOME/.config/emacs/bin"
	"/usr/local/anaconda3/bin"
	"/home/linuxbrew/.linuxbrew/bin"
)

for path in "${DIRS_TO_ADD[@]}"; do
	[ -d "$path" ] && LOCAL_PATH="${LOCAL_PATH:+${LOCAL_PATH}:}$path"
done

export PATH=${LOCAL_PATH:+${LOCAL_PATH}:}$PATH
#END path

#START aliases
alias ls='ls --color=auto'
alias cd=z
alias vim=nvim
alias vi=nvim
alias myip='curl ipinfo.io/ip'
alias resetbrave='rm -rf ~/.config/BraveSoftware/Brave-Browser/Singleton*'
#END aliases

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#START environment variables
export STUDENT_ID=220032141
export REPORT_TEMPLATE_REPO="https://github.com/gskorokhod/typesetting"
export EDITOR=nvim
#END environment variables

#START shopts
shopt -s nullglob     # don't complain if no files match a glob
shopt -s globstar     # enable ** globbing
shopt -s checkwinsize # Check window size and update output
#END shopts

#START completions
bind "set completion-ignore-case on" # ignore case
bind "set show-all-if-ambiguous on"  # show all options if ambiguous

completion_files=(~/.bash/*-completion.bash)

if [ ${#completion_files[@]} -gt 0 ]; then
	for i in "${completion_files[@]}"; do
		source "$i"
	done
fi

[ -e ~/.bash/git-prompt.sh ] && source ~/.bash/git-prompt.sh      # source the git prompt script
[ -x $(command -v pandoc) ] && eval "$(pandoc --bash-completion)" # enable pandoc completions if available
#END completions

#START fzf
[ -f ~/.bash/fzf/completion.bash ] && source ~/.bash/fzf/completion.bash
[ -f ~/.bash/fzf/key-bindings.bash ] && source ~/.bash/fzf/key-bindings.bash
#END fzf

#START zoxide
eval "$(zoxide init bash)"
#END zoxide

#START prompt
[ -f ~/.bash/prompt.sh ] && source ~/.bash/prompt.sh
colour_my_prompt
#END prompt
