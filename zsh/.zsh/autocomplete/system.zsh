# not just at the end
setopt COMPLETE_IN_WORD

# * shouldn't match dotfiles. ever.
setopt noglobdots

# Expand history on pressing Space while using "!" or ""
bindkey ' ' magic-space

# Install standard set of default colors
zstyle ':completion:*' list-colors ''

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# Ignore autocomplete for unavailable commands
zstyle ':completion:*:functions' ignored-patterns '_*'

zstyle ':completion:*:*:*:users' ignored-patterns \
                                           bin daemon mail ftp http \
																					 nobody dbus avahi named\
																					 bitlbee mpd \
                                           rtkit ntp usbmux

# Remove trailing slash when using directory as arguments (Useful with ln)
zstyle ':completion:*' squeeze-slashes true

# caching to speed up _apt and _dpkg
[[ -d $HOME/.zsh/cache ]] && zstyle ':completion:*' use-cache yes && \
		zstyle ':completion::complete:*' cache-path $HOME/.zsh/cache/

# use generic completion with commands that provide a --help option
for compcom in cp deborphan df feh fetchipac gpasswd head hnb ipacsum mv \
								pal stow uname ; do
    [[ -z ${_comps[$compcom]} ]] && compdef _gnu_generic ${compcom}
done; unset compcom

