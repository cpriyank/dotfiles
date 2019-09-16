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
# TODO: Test this for ubuntu and debian
if  hash brew 2> /dev/null; then
  if [[ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]]; then
    source "$(brew --prefix)/share/bash-completion/bash_completion";
  elif [[ -f /usr/share/bash-completion ]]; then
    source "/usr/share/bash-completion"
    source "$(brew --prefix)/etc/bash_completion.d/brew"
    # hub completion
  fi

  if  which hub > /dev/null; then
    source "$(brew --prefix)/etc/bash_completion.d/hub.bash_completion.sh";
  fi

fi

# Enable tab completion for `g` by marking it as an alias for `git`
if type __git_complete &> /dev/null; then
    __git_complete g __git_main
fi;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Correct spelling errors in arguments supplied to cd
shopt -s cdspell;

# Autocorrect on directory names to match a glob.
shopt -s dirspell 2> /dev/null

# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null

# aliases, environment variables, functions, and other common files for bash and zsh
for file in ${HOME}/.zsh/common_shell_files/**/*.sh; do
  [[ -r "$file" ]] && source "$file"
done
unset file
