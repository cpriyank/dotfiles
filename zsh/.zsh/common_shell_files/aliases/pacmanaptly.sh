if [[ -e /usr/bin/pacman ]] ; then
	## Arch specific aliases
	alias pacupg='sudo pacman -Syu'
	alias pacin='sudo pacman -S'
	alias pacins='sudo pacman -U'
	alias pacrem='sudo pacman -Rns'
	alias pacref='sudo pacman -Syy'

	# Delete the lock file /var/lib/pacman/db.lck
	alias pacunlock='sudo rm /var/lib/pacman/db.lck'

	# Package search and info from remote repos
	alias pacrinfo='pacman -Si'
	alias pacrfind='pacman -Ss'

	# Same as above for local repos
	alias paclinfo='pacman -Qi'
	alias paclfind='pacman -Qs'

	# Remove orphaned packages
	alias pacrorf='sudo pacman -Rns $(pacman -Qtdq)'

	# List all explicitly installed packages not in base and base-devel
	alias paclist='expac -HM "%011m\t%-20n\t%10d" $( comm -23 <(pacman -Qqen|sort) <(pacman -Qqg base base-devel|sort) ) | sort -n'

	# List packages installed from AUR
	alias aurlist='pacman -Qm'

	# Search AUR for matching strings
	alias aurfind='pacaur -Ss'

	# Install an AUR package
	alias aurin='trizen -S'

	# Upgrade AUR packages
	alias aurupg='trizen -Syu'

elif [[ -e /usr/bin/apt-get ]] ; then

	## Debian specific aliases
	alias pacupg='sudo apt-get dist-upgrade'
	alias pacin='sudo apt-get install'
	alias pacins='sudo dpkg -i'
	alias pacrem='sudo apt-get purge'
	alias pacref='sudo apt-get update'

	alias pacrinfo='apt-cache show'
	alias pacrfind='apt-cache search'

	alias paclinfo='dpkg -s'

	# Remove orphans
	alias pacorf='sudo apt-get autoremove && sudo apt-get clean all'

	# Apt policy
	alias acp='apt-cache policy'

	# sort installed Debian-packages by size
	alias paclist="dpkg-query -Wf 'x \${Installed-Size} \${Package} \${Status}\n' | sed -ne '/^x  /d' -e '/^x \(.*\) install ok installed$/s//\1/p' | sort -nr"

elif [[ -e /usr/local/bin/brew ]] ; then

	# Brew specific aliases
	alias pacupg='brew upgrade'
	alias pacin='brew install'
	alias pacrem='brew rmtree'
	alias pacre='brew rmtree --dry-run'
	alias pacref='brew update'
	alias pacrorf='brew cleanup'

elif [[ -e /usr/sbin/pkg ]] ; then
	# FreeBSD specific
	alias pacin='sudo pkg install'
	alias pacorf='sudo pkg autoremove'
	alias pacrem='sudo pkg remove'
fi
