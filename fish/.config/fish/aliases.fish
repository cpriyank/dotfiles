### Navigation
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end


### File size
function fs
	stat -f "%z bytes" $argv
end

function v
	eval $EDITOR $argv
end

function l
	la $argv
end

function m
	tmux
end

function a
	tmux attach
end

# Open vim in readonly mode
function vr
	v -R $argv
end

function scp
	command scp -p $argv
end

function wget
	command wget -c $argv
end

function pong
	ping -c 3 www.google.com
end

function xrr
	xrdb ~/.Xresources
end

function t
	if test -n $argv
		tree -C $argv
	else
		tree -C .
	end
end

# Make du readable
function da
	du -sch $argv
end

# Warn on overwrite
# function mv
	# command gmv --interactive --verbose $argv
# end

function rm
	trash $argv
end

function cp
  rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 $argv
end

# function cp
	# command gcp --interactive --verbose $argv
# end

### Download video by URL from STDIN
function apo
	youtube-dl $argv
end

function asong
	youtube-dl -f 251 $argv
end

# Download videos from the list of URLs from a file
function apone
	youtube-dl -a $argv
end

# just play audio from a video file or url
function p
	mpv --no-video $argv
end

### Redshift aliases. For saving eyes, seriously.
# Gandhinagar coordinates
function shantib
	redshift -o -l 23.22:72.68
end

# Seattle coordinates
function shanti
	redshift -o -l 47.61:-122.33 -t 4500:2800
end

# Reset color
function ashanti
	redshift -x
end

### Recursively delete `.DS_Store` files
function cleanup
	find . -name '*.DS_Store' -type f -ls
end

### Git specific
# git root
function gr --description "Jump to the git root"
	set -l repo_info (command git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree --short HEAD ^/dev/null)
  	test -n "$repo_info"; or return

	set -l cd_up_path (command git rev-parse --show-cdup)

	if test -n $cd_up_path
		cd $cd_up_path
	end
end

# alias ga only if forgit is not installed
function ga
	if not type forgit::add &> /dev/null
		git add $argv
	else
		forgit::add
	end
end

function gc
	git commit -v $argv
end

function gco
	git checkout $argv
end

function gsb
	git status -sb
end

function gst
	git status
end

function gd
	git diff $argv
end

function glola
	git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all
end

function gp
	git push $argv
end

function gpd
	git push --dry-run $argv
end

function grh
	git reset HEAD -- $argv
end

# pretty print the path
function ppath
  echo $PATH | tr -s " " "\n"
end

# case insensitive rg
function rgi
  rg -i $argv
end

# case insensitive rg with $EDITOR
function rgil
	rg -l -i $argv | xargs $EDITOR
end

function k
  kak $argv
end

function cdf --description 'Change to directory opened by Finder'
  if [ -x /usr/bin/osascript ]
    set -l target (osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)')
    if [ "$target" != "" ]
      cd "$target"; pwd
    else
      echo 'No Finder window found' >&2
    end
  end
end

function cdls
   cd $argv
   ls -ahl
end

function cleanlatex --description 'pdflatex with cleanup'
	set texfile (basename $argv .tex)
	pdflatex $argv
	rm "$texfile".log
	rm "$texfile".aux
end

function f --description "find shorthand"
	grc find . -name "$argv" 2>&1 | grep -v 'Permission denied'
end

function g --wraps git
        git $argv;
end

function update --description "update brew, pip packages"
   brew update
	 brew cleanup
	 # toolbox update
	 pip3 install --upgrade pip
end

# TODO: lack of consistency in fish aliases/abbrs
if type -q lsd
	abbr --add --global l lsd
	abbr --add --global la lsd -al
end

function md --wraps mkdir -d "Create a directory and cd into it"
  command mkdir -p $argv
  if test $status = 0
    switch $argv[(count $argv)]
      case '-*'
      case '*'
        cd $argv[(count $argv)]
        return
    end
  end
end

function fuck -d 'Correct your previous console command'
    set -l exit_code $status
    set -l eval_script (mktemp 2>/dev/null ; or mktemp -t 'thefuck')
    set -l fucked_up_commandd $history[1]
    thefuck $fucked_up_commandd > $eval_script
    . $eval_script
    rm $eval_script
    if test $exit_code -ne 0
        history --delete $fucked_up_commandd
    end
end

alias pacupg='sudo pacman -Syu'
alias pacin='sudo pacman -S'
alias pacins='sudo pacman -U'
alias pacrem='sudo pacman -Rns'
alias pacref='sudo pacman -Syy'
alias nixup='nix-channel --update; and darwin-rebuild switch'

# Delete the lock file /var/lib/pacman/db.lck
alias pacunlock='sudo rm /var/lib/pacman/db.lck'

# Package search and info from remote repos
alias pacrinfo='pacman -Si'
alias pacrfind='pacman -Ss'

# Same as above for local repos
alias paclinfo='pacman -Qi'
alias paclfind='pacman -Qs'

# Remove orphaned packages
alias pacrorf='sudo pacman -Rns (pacman -Qtdq)'

# List packages installed from AUR
alias aurlist='pacman -Qm'

# Search AUR for matching strings
alias aurfind='trizen -Ss'

# Install an AUR package
alias aurin='trizen -S --noedit'

# Upgrade AUR packages. See archlinux news before upgrading
alias aurupg='trizen -Syu -w --noedit'
