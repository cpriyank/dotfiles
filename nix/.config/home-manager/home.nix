{ config, pkgs, ... }:

{
	home.username = "orca";
	home.homeDirectory = "/Users/orca";

	# This value determines the Home Manager release that your configuration is
	# compatible with. This helps avoid breakage when a new Home Manager release
	# introduces backwards incompatible changes.
	#
	# You should not change this value, even if you update Home Manager. If you do
	# want to update the value, then make sure to first check the Home Manager
	# release notes.
	home.stateVersion = "25.05"; # Please read the comment before changing.

	# The home.packages option allows you to install Nix packages into your
	# environment.
	home.packages = with pkgs; [
		bat
		delta
		fd
		ffmpeg
		fzf
		gh
		ghostscript
		gping
		graphicsmagick
		imagemagick
		lazygit
		luajit
		lsd
		mpv
		neovim
		nodejs
		pandoc
		pyright
		ripgrep
		sad
		nerd-fonts._0xproto
		# starship
		tmux
		tmuxPlugins.extrakto
		vim
		# vscode # needs nixpkgs.config.allowUnfree
		zoxide
	];


	# Home Manager is pretty good at managing dotfiles. The primary way to manage
	# plain files is through 'home.file'.
	home.file = {
		# # Building this configuration will create a copy of 'dotfiles/screenrc' in
		# # the Nix store. Activating the configuration will then make '~/.screenrc' a
		# # symlink to the Nix store copy.
		# ".screenrc".source = dotfiles/screenrc;

		# # You can also set the file content immediately.
		# ".gradle/gradle.properties".text = ''
		#   org.gradle.console=verbose
		#   org.gradle.daemon.idletimeout=3600000
		# '';
	};

	# Home Manager can also manage your environment variables through
	# 'home.sessionVariables'. These will be explicitly sourced when using a
	# shell provided by Home Manager. If you don't want to manage your shell
	# through Home Manager then you have to manually source 'hm-session-vars.sh'
	# located at either
	#
	#  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
	#
	# or
	#
	#  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
	#
	# or
	#
	#  /etc/profiles/per-user/orca/etc/profile.d/hm-session-vars.sh
	#
	home.sessionVariables = {
		# EDITOR = "emacs";
	};

	programs.fish = {
		enable = true;
		shellInit = ''
    # Your fish initialization here
    if test -d "$HOME/.nix-profile/bin"
      set -p fish_user_paths "$HOME/.nix-profile/bin"
    end
    if test -d "/nix/var/nix/profiles/default/bin"
      set -p fish_user_paths "/nix/var/nix/profiles/default/bin"
    end
    if test -d "/opt/homebrew/bin"
      set -p fish_user_paths "/opt/homebrew/bin"
    end
    if test -d "/Applications/kitty.app/Contents/MacOS"
      set -p fish_user_paths "/Applications/kitty.app/Contents/MacOS"
    end

    if command --search --quiet "zoxide"
  zoxide init fish | source
end

# private config not under public source control
if test -e $HOME/.config/fish/private.fish
	source $HOME/.config/fish/private.fish
end

if command --search --quiet "nvim"
	set -gx EDITOR nvim
else if command --search --quiet "vim"
	set -gx EDITOR vim
else
	set -gx EDITOR nano
end
    source ~/.dotfiles/fish/.config/fish/aliases.fish
		'';
		shellAliases = {
			ll = "ls -lah";
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
		functions = {
			# Custom fish functions
		};
	};


	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
}
