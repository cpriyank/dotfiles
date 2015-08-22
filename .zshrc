# Use vi keybindings for line editing (Default if $EDITOR *contains* vi)------
bindkey -v


## Command history------------------------------------------------------------
# (Zsh doesn't use readline. It uses its own ZLE (Z Line Editing).
HISTFILE=${ZDOTDIR:-${HOME}}/.zsh_history
HISTSIZE=16384
SAVEHIST=512
setopt HIST_IGNORE_ALL_DUPS

# Append the new history to the old
setopt APPEND_HISTORY
# Add each line to the history as it is executed (not when the shell exits)
setopt INC_APPEND_HISTORY
# Make multiple Zsh sessions share the same history
# setopt SHARE_HISTORY
# Also log when the command was started and how long it ran for.
setopt EXTENDED_HISTORY
# Remove any excess blanks that mean nothing to the shell
setopt HIST_REDUCE_BLANKS

# After a substitution by a modifier(like with '!!:t:r'), make the line appear
# again with the changes, instead of printing and executing directly.
# i.e. You just have to type <RET> to execute it.
setopt HIST_VERIFY


## Keybindings----------------------------------------------------------------
bindkey '^R' history-incremental-search-backward
bindkey -M viins 'jj' vi-cmd-mode


## Load the new autocompletion system-----------------------------------------
autoload -Uz compinit
compinit
zstyle :compinstall filename "${ZDOTDIR:-${HOME}}/.zshrc"

autocompfiles=(${ZDOTDIR:-${HOME}}/.zsh/autocomplete/*)
for file in ${autocompfiles}; do
	source $file
done
unset autocompfiles


## Aliases and functions------------------------------------------------------
aliasfiles=(${ZDOTDIR:-${HOME}}/.zsh/aliases/*)
for file in ${aliasfiles}; do
	source $file
done
unset aliasfiles

# Path to function directory
[[ $fpath = *${ZDOTDIR:-${HOME}}* ]] || fpath=(${ZDOTDIR:-${HOME}}/.zsh/functions $fpath)
# Autoload all the functions. '(:t)' is a modifier that picks the
# last part of a filename, everything after the last slash;
# Parentheses is needed to tell the shell the ‘:t’ isn’t just part of the file
# name.
autoload -U ${fpath[1]}/*(:t)


## The "command not found" hook-----------------------------------------------
# It searches the official repos, when entering an unrecognized command
# And suggests a package that provides that command
source ${ZDOTDIR:-${HOME}}/.zsh/plugs/command-not-found.zsh


## Prompt---------------------------------------------------------------------
#source ${ZDOTDIR:-${HOME}}/.zsh/prompt.zsh
autoload -U promptinit && promptinit
prompt pure
# Enable fish-like syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


## Misc options---------------------------------------------------------------
# If LOCAL_OPTIONS is set in a function (or was already set before
# the function, and not unset inside it), then any options which are changed
# inside the function will be put back the way they were when the function
# finishes.
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS

# In zsh, background jobs are usually run at a lower priority (a ‘higher nice
# value). Disable that.
# setopt NO_BG_NICE

# Suppose you enter the command ‘print file1* file2*’ and the directory
# contains just the file file1.c. With CSH_NULL_GLOB set, file1* matched, and
# file2* is silently removed; ‘file1.c’ is reported.
# If that had not been there, an error would have been reported.
setopt CSH_NULL_GLOB

# Turn off beep on errors
unsetopt beep

# Smart URIs
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
