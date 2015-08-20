if [[ -e /usr/bin/pacman ]] ; then
	## Arch specific aliases
	alias pacupg='sudo pacman -Syyu'
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

	# Find orphaned packages
	alias pacorf='pacman -Qdt'

	# List all explicitly installed packages not in base and base-devel
	alias paclist='expac -HM "%011m\t%-20n\t%10d" $( comm -23 <(pacman -Qqen|sort) <(pacman -Qqg base base-devel|sort) ) | sort -n'

	alias aurlist='pacman -Qem' # List packages installed from aur 
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
fi
