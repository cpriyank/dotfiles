# beautify ls, show git status if available

# local gem binary path must be set before `source`-ing this file
# as of this commit, gem binary path is added to $PATH first because
# the file that does it, i.e. common_shell_files/languages/ruby.sh
# comes before this file lexicographically
if command -v colorls > /dev/null 2>&1 && command -v gem > /dev/null 2>&1; then
  tab_completer="$(dirname $(gem which colorls))/tab_complete.sh"
  [[ -n "${tab_completer}" ]] && source "${tab_completer}"
  unset tab_completer

  # some of these override existing aliases
  # todo: disable this for large projects?
  alias ls="colorls --git-status --sort-dirs"
  alias l="colorls --long --git-status --sort-dirs"
  alias la="colorls --long --almost-all --human-readable --git-status --sort-dirs"
  alias lsd="colorls --dirs"
  alias lsf="colorls --files --git-status"
  alias lst="colorls --tree"
  # sort output by modification time
  alias lt="colorls --git-status --sort-dirs -t"
fi
