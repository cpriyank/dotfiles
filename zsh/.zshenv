## According to section 2.5.10 of Zsh guide, this file is the safest place to
## define environment variables.

# Prefer system binaries to local ones.
# Don't add anything to $path if it's there already ('-U means unique').
typeset -gU path
GOPATH=~/Development/gopher
path=($path ~/bin $GOPATH/bin)

cdpath=(~/ ~/Development/ ~/Development/C++/ ~/Development/gopher/)

export ZSH_CONFIG_HOME=$HOME/.zsh
export EDITOR="nvim"
# export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export VDPAU_DRIVER=va_gl
export LIBVA_DRIVER_NAME=vdpau
