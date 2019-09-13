# bash profile ###################################################################
#
# Load our dotfiles like ~/.bash_prompt, etc…
#   ~/.extra can be used for settings you don’t want to commit,
#   Use it to configure your PATH, thus it being first in line.
for file in ~/.{extra,bash_prompt,exports,functions}; do
    [[ -r "$file" ]] && source "$file"
done
unset file
for file in ~/.zsh/aliases/*; do source $file; done

# to help sublimelinter etc with finding my PATHS
case $- in
   *i*) source ~/.extra
esac

# generic colouriser
GRC=`which grc`
if [ "$TERM" != dumb ] && [ -n "$GRC" ]
    then
        alias colourify="$GRC -es --colour=auto"
        alias configure='colourify ./configure'
        for app in {diff,make,gcc,g++,netstat,ping,traceroute}; do
            alias "$app"='colourify '$app
    done
fi

##
## gotta tune that bash_history…
##

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
export HISTTIMEFORMAT='%F %T '

# keep history up to date, across sessions, in realtime
#  http://unix.stackexchange.com/a/48113
export HISTCONTROL="erasedups:ignoreboth"       # no duplicate entries
export HISTSIZE=65536                           # big big history (default is 500)
export HISTFILESIZE=$HISTSIZE                   # big big history
type shopt &> /dev/null && shopt -s histappend  # append to history, don't overwrite it

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Save multi-line commands as one command
shopt -s cmdhist

##
## Completion…
##

# bash completion.
# TODO: Fix this for linux
if  which brew > /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
    source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;

# homebrew completion
if  which brew > /dev/null; then
    source "$(brew --prefix)/etc/bash_completion.d/brew"
fi;

# hub completion
if  which hub > /dev/null; then
    source "$(brew --prefix)/etc/bash_completion.d/hub.bash_completion.sh";
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type __git_complete &> /dev/null; then
    __git_complete g __git_main
fi;

##
## better `cd`'ing
##

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Correct spelling errors in arguments supplied to cd
shopt -s cdspell;

# Autocorrect on directory names to match a glob.
shopt -s dirspell 2> /dev/null

# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null

# base16-shell theme
source ~/.zsh/plugs/base16-monokai.dark.sh

# bash prompt#######################################

# This prompt inspired by paul irish, gf3, sindresorhus, alrra, and
# mathiasbynens.
# Most of the stuff is copy pasted from paul
# https://github.com/paulirish/dotfiles/blob/master/.bash_prompt

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

if [[ -n "$ZSH_VERSION" ]]; then  # quit now if in zsh
    return 1 2> /dev/null || exit 1;
fi;


if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi


set_prompts() {

    local black="" blue="" bold="" cyan="" green="" orange="" \
          purple="" red="" reset="" white="" yellow=""

    local dateCmd=""

    if [[ -x /usr/bin/tput ]] && tput setaf 1 &> /dev/null; then

        tput sgr0 # Reset colors

        bold=$(tput bold)
        reset=$(tput sgr0)

        # Monokai colors
	black=$(tput setaf 00);
	blue=$(tput setaf 81);
	cyan=$(tput setaf 37);
	green=$(tput setaf 148);
	orange=$(tput setaf 208);
	purple=$(tput setaf 141);
	red=$(tput setaf 197);
	violet=$(tput setaf 61);
	white=$(tput setaf 15);
	yellow=$(tput setaf 185);
   else
	bold='';
	reset="\e[0m";
	black="\e[1;30m";
	blue="\e[1;34m";
	cyan="\e[1;36m";
	green="\e[1;32m";
	orange="\e[1;33m";
	purple="\e[1;35m";
	red="\e[1;31m";
	violet="\e[1;35m";
	white="\e[1;37m";
	yellow="\e[1;33m";
    fi

    function prompt_git() {
        # this is >5x faster than mathias's.

        # check if we're in a git repo. (fast)
        git rev-parse --is-inside-work-tree &>/dev/null || return

        # check for what branch we're on. (fast)
        #   if… HEAD isn’t a symbolic ref (typical branch),
        #   then… get a tracking remote branch or tag
        #   otherwise… get the short SHA for the latest commit
        #   lastly just give up.
        branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
            git describe --all --exact-match HEAD 2> /dev/null || \
            git rev-parse --short HEAD 2> /dev/null || \
            echo '(unknown)')";


        ## early exit for Chromium & Blink repo, as the dirty check takes ~5s
        ## also recommended (via goo.gl/wAVZLa ) : sudo sysctl kern.maxvnodes=$((512*1024))
        repoUrl=$(git config --get remote.origin.url)
       
            # check if it's dirty (slow)
            #   technique via github.com/git/git/blob/355d4e173/contrib/completion/git-prompt.sh#L472-L475
            dirty=$(git diff --no-ext-diff --quiet --ignore-submodules --exit-code || echo -e "*")

            # mathias has a few more checks some may like:
            #    github.com/mathiasbynens/dotfiles/blob/a8bd0d4300/.bash_prompt#L30-L43


        [ -n "${s}" ] && s=" [${s}]";
        echo -e "${1}${branchName}${2}$dirty";

        return
    }



    # ------------------------------------------------------------------
    # | Prompt string                                                  |
    # ------------------------------------------------------------------

    PS1="\[\033]0;\w\007\]"                                 # terminal title (set to the current working directory)
    PS1+="\n\[$bold\]"
    PS1+="\[$blue\]\w"                                     # working directory
    PS1+="\n"
    PS1+="\$(prompt_git \"\[$white\] \[$purple\]\" \"\[$violet\]\")"   # git repository details
    PS1+=" "
    PS1+="\[$reset$white\]❯ \[$reset\]"

    export PS1

    # ------------------------------------------------------------------
    # | Subshell prompt string                                         |
    # ------------------------------------------------------------------

    export PS2="⚡ "

    # ------------------------------------------------------------------
    # | Debug prompt string  (when using `set -x`)                     |
    # ------------------------------------------------------------------

    # When debugging a shell script via `set -x` this tricked-out prompt is used.

    # The first character (+) is used and repeated for stack depth
    # Then, we log the current time, filename and line number, followed by function name, followed by actual source line

    # FWIW, I have spent hours attempting to get time-per-command in here, but it's not possible. ~paul
    export PS4='+ \011\e[1;30m\t\011\e[1;34m${BASH_SOURCE}\e[0m:\e[1;36m${LINENO}\e[0m \011 ${FUNCNAME[0]:+\e[0;35m${FUNCNAME[0]}\e[1;30m()\e[0m:\011\011 }'


    # shoutouts:
    #   https://github.com/dholm/dotshell/blob/master/.local/lib/sh/profile.sh is quite nice.
    #   zprof is also hot.

}



set_prompts
unset set_prompts
# vi:syntax=sh

# .bashrc ################################################################
[[ -n "$PS1" ]] && source ~/.bash_profile

[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

####################################################### exports
if hash nvim 2>/dev/null
then
    export EDITOR="nvim"
elif hash vim 2>/dev/null
then
    export EDITOR="vim"
else
    export EDITOR="nano"
fi

# https://wiki.archlinux.org/index.php/locale
export LC_COLLATE=C

# todo: don't do this by default
if [[ ! -d $HOME/z/go ]]
then
    mkdir -p $HOME/z/go
fi

export GOPATH=$HOME/z/go
PATH=$PATH:$GOPATH

PATH=$PATH:$HOME/.gem/ruby/2.6.0/bin


################################################### extra fzf
# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

##################################### zlogin
# This file is read at login after zshrc
{
  # Compile the completion dump to increase startup speed.
  zcompdump="~/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

############################################################### zprofile
# If the shell is is a login shell, commands are read from /etc/profile and
# then from $ZDOTDIR/.zprofile.


# Start X at login
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
## According to section 2.5.10 of Zsh guide, this file is the safest place to
## define environment variables.

# Prefer system binaries to local ones.
# Don't add anything to $path if it's there already ('-U means unique').
typeset -gU path
export GOPATH=$HOME/z/go
path=($path ~/bin $GOPATH/bin ~/.local/bin)

cdpath=(~/ ~/z/)

export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
# export VDPAU_DRIVER=va_gl
#export LIBVA_DRIVER_NAME=vdpau

# setup default dirs
[[ $XDG_CACHE_HOME ]] || export XDG_CACHE_HOME="$HOME/.cache"
[[ $XDG_CONFIG_HOME ]] || export XDG_CONFIG_HOME="$HOME/.config"
[[ $XDG_DATA_HOME ]] || export XDG_DATA_HOME="$HOME/.local/share"


