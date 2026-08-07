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
	gdu -sch $argv
end

# Warn on overwrite
# function mv
# 	command gmv --interactive --verbose $argv
# end

function rm
	trash $argv
end

# Helper function to prompt for directory creation and handle overwrites
function __safe_file_op --argument-names op
    set -e argv[1]

    if test (count $argv) -lt 2
        echo "Usage: $op source... destination"
        return 1
    end

    # Get destination (last argument)
    set -l dest $argv[-1]
    set -l sources $argv[1..-2]

    # Determine destination directory
    set -l dest_dir
    if test (count $sources) -gt 1
        # Multiple sources: dest must be a directory
        set dest_dir $dest
    else
        # Single source: dest could be file or dir
        if string match -q '*/' $dest
            set dest_dir $dest
        else if test -d $dest
            set dest_dir $dest
        else
            set dest_dir (dirname $dest)
        end
    end

    # Check if destination directory exists
    if not test -d $dest_dir
        read -l -P "Directory '$dest_dir' doesn't exist. Create it? [y/N] " confirm
        if test "$confirm" = y -o "$confirm" = Y
            mkdir -p $dest_dir
            or return 1
        else
            echo "Aborted."
            return 1
        end
    end

    # Check for overwrites
    for src in $sources
        set -l target
        if test -d $dest
            set target $dest/(basename $src)
        else
            set target $dest
        end

        if test -e $target
            read -l -P "Overwrite '$target'? [y/N] " confirm
            if test "$confirm" != y -a "$confirm" != Y
                echo "Skipping '$src'."
                set -l idx (contains -i $src $sources)
                set -e sources[$idx]
            end
        end
    end

    # Execute the operation if there are sources left
    if test (count $sources) -gt 0
        switch $op
            case cp
                rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 $sources $dest
            case mv
                command mv --verbose $sources $dest
        end
    end
end

function cp
    __safe_file_op cp $argv
end

function mv
    __safe_file_op mv $argv
end

# function cp
	# command gcp --interactive --verbose $argv
# end

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

function updatebrew --description "update brew, pip packages"
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

function mcd --wraps mkdir -d "Create a directory and cd into it"
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
alias mkcd='mcd'

alias lg='lazygit'

# Only set the following if running linux
if type -q pacman
	alias pacupg='sudo pacman -Syu'
	alias pacin='sudo pacman -S'
	alias pacins='sudo pacman -U'
	alias pacrem='sudo pacman -Rns'
	alias pacref='sudo pacman -Syy'

	# check if usb-hid-brightness is installed
	# max value is 54000
	if type -q usb-hid-brightness
		alias monitor-brightness='sudo usb-hid-brightness'
	else
	    echo "usb-hid-brightness not installed"
	end

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
else
    alias pacupg='nix flake update --flake ~/.dotfiles/nix/.config/home-manager; and home-manager switch --flake ~/.dotfiles/nix/.config/home-manager'
end
