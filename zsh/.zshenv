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
