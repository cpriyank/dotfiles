# beautify ls

# some colors for ls
if command -v lsd >/dev/null 2>&1; then
	if [[ -e ~/.dircolors ]]; then
		eval "$(dircolors -b ~/.dircolors)"
	fi
fi

# icons for ls; requires lsd installed
if command -v lsd >/dev/null 2>&1; then # check if command exists and is not an alias
  # some of these override existing aliases
	alias ls='command lsd --group-dirs first'
	alias l='command lsd --human-readable --classify --long --group-dirs first'
	alias la='command lsd --almost-all --human-readable --classify --long --group-dirs first'
	alias lst='command lsd --tree'
fi
