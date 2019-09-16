# Enable fish-like syntax highlighting
case $(uname) in
    "Linux") source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ;;
    "Darwin") source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ;;
esac

# In OS X, autosuggestion config is maintained as a package in brew
# source
[[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
	&& source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# In arch, one might have to manage by oneself install zsh-autosuggestions
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# TODO: enable for Debian and Ubuntu
