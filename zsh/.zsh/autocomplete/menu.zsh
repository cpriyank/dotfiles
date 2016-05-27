# menu completion on more than 5 options
zstyle ':completion:*' menu select=5
# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*' insert-unambiguous true
zstyle ':completion:*:corrections' format '%B%F{green}>> %d (errors: %e)%f%b'
zstyle ':completion:*:correct:*' original true
