## According to section 2.5.10 of Zsh guide, this file is the safest place to
## define environment variables.

# Prefer system binaries to local ones.
# Don't add anything to $path if it's there already ('-U means unique').
typeset -gU path
export GOPATH=$HOME/z/go
path=($path ~/bin $GOPATH/bin ~/.local/bin)

cdpath=(~/ ~/z/)

export ZSH_CONFIG_HOME=$HOME/.zsh
if [[ -e `whence nvim` ]]
then export EDITOR="nvim"
elif [[ -e `whence vim` ]]
then export EDITOR="vim"
else export EDITOR="nano"
fi
export LC_COLLATE=C
# export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export VDPAU_DRIVER=va_gl
#export LIBVA_DRIVER_NAME=vdpau
