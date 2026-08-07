{ config, pkgs, ... }:

{
	home.username = "{{HOME_MANAGER_USERNAME}}";
	home.homeDirectory = "{{HOME_MANAGER_HOME_DIRECTORY}}";
	home.enableNixpkgsReleaseCheck = false;
	home.stateVersion = "25.11"; # Do not change - set when first created

	home.packages = with pkgs; [
		android-tools
		awscli2
		btop
		cargo
		cmus
		coreutils
		delta
		espeak-ng
		fd
		ffmpeg
		gdu
		gh
		ghostscript
		gnutar
		gping
		gradle
		graphicsmagick
		imagemagick
		jdk17
		jq
		lazygit
		libimobiledevice
		libopus
		localsend
		lsd
		luajit
		mpv
		neovim
		nerd-fonts._0xproto
		nodejs
		pandoc
		pnpm
		postgresql
		pyright
		rclone
		ripgrep
		rsync
		rustc
		sad
		sox
		stow
		syncthing
		tmux
		tmuxPlugins.extrakto
		trash-cli
		uv
		vim
		yazi
		zstd
	];

	home.sessionVariables = {
		EDITOR = "nvim";
	};

	programs.bat.enable = true;
	programs.direnv.enable = true;
	programs.fzf.enable = true;
	programs.zoxide.enable = true;

	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			function print_log_separator --on-event fish_postexec
				if test "$argv" != "clear"
					set -l term_width $COLUMNS
					set_color 444
					string repeat -n $term_width "─"
					set_color normal
				end
			end

			source ~/.dotfiles/fish/.config/fish/aliases.fish
			source ~/.dotfiles/fish/.config/fish/gists.fish
		'';
		shellInit = ''
			set -g fish_greeting

			set -p fish_function_path ~/.dotfiles/fish/.config/fish/functions

			fish_add_path $HOME/.nix-profile/bin
			fish_add_path /nix/var/nix/profiles/default/bin
			fish_add_path $HOME/.cargo/bin
			fish_add_path /opt/homebrew/bin
			fish_add_path /Applications/kitty.app/Contents/MacOS
			fish_add_path /usr/local/sessionmanagerplugin/bin
			fish_add_path $HOME/.local/bin
			fish_add_path $HOME/.opencode/bin
			fish_add_path $HOME/.config/emacs/bin

			# add npm config get prefix to fish_user_paths if npm is installed
			if command --search --quiet "npm"
				set -gx NPM_PREFIX (npm config get prefix)
				set -gx fish_user_paths "$NPM_PREFIX/bin" $fish_user_paths
			end

			# Allow cd to find directories in home without typing ~/
			set -gx CDPATH . ~

			if test -e $HOME/.config/fish/private.fish
				source $HOME/.config/fish/private.fish
			end
		'';
		shellAliases = {
			gs = "git status";
		};
		plugins = [
			{ name = "done"; src = pkgs.fishPlugins.done.src; }
			{ name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
			{ name = "gruvbox"; src = pkgs.fishPlugins.gruvbox.src; }
			{ name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
			{ name = "hydro"; src = pkgs.fishPlugins.hydro.src; }
			{ name = "pisces"; src = pkgs.fishPlugins.pisces.src; }
			{ name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
			{ name = "bass"; src = pkgs.fishPlugins.bass.src; }
		];
	};

	programs.home-manager.enable = true;
}
