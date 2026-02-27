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
	home.stateVersion = "25.11"; # Please read the comment before changing.

	# The home.packages option allows you to install Nix packages into your
	# environment.
	home.packages = with pkgs; [
	        act
		awscli2
		bat
		colima
		delta
		direnv
		docker
                docker-compose
                docker-buildx
	        docker-credential-helpers # Essential for macOS keychain auth
		emacs-macport
		espeak-ng
		elan
		fd
		ffmpeg
		fzf
		gdu
		gh
		ghostscript
		go
		gping
		graphicsmagick
		imagemagick
		jq
		lazygit
		localsend
		luajit
		lsd
		mpv
		neovim
		nodejs
		pandoc
		pnpm
		postgresql
		pyright
		rbenv
		ripgrep
		rustc
		rsync
		cargo
		sad
		sox  # for audio recording
		stow
		syncthing
		nerd-fonts._0xproto
		# starship
		tmux
		tmuxPlugins.extrakto
		uv
		vim
		whisper-cpp
		# vscode # needs nixpkgs.config.allowUnfree
		zed-editor
		zoxide
	];

	  # Manually define the LaunchAgent to enforce M4 Pro flags on startup
  launchd.agents.colima = {
    enable = true;
    config = {
      Label = "com.github.abiosoft.colima";
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${config.home.homeDirectory}/.colima/default/daemon.log";
      StandardErrorPath = "${config.home.homeDirectory}/.colima/default/daemon.err";
      EnvironmentVariables = {
        PATH = "${pkgs.lib.makeBinPath [ pkgs.colima pkgs.docker pkgs.qemu ]}:/usr/bin:/bin:/usr/sbin:/sbin";
      };
      ProgramArguments = [
        "${pkgs.colima}/bin/colima"
        "start"
        "--foreground"
        "--verbose"
        # M4 Pro "Golden" Flags
        "--cpu" "6"
        "--memory" "16"
        "--disk" "100"
        "--vm-type" "vz"
        "--mount-type" "virtiofs"
        "--vz-rosetta"
        "--network-address" # Optional: gives the VM its own IP
      ];
    };
  };



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
	DOCKER_HOST = "unix://${config.home.homeDirectory}/.colima/default/docker.sock";
		# EDITOR = "emacs";
	};

	programs.fish = {
		enable = true;
				interactiveShellInit = ''
			# Define the separator function manually here to ensure it's registered
			function print_log_separator --on-event fish_postexec
			    # Don't draw if the command was 'clear' or clear-like
			    if test "$argv" != "clear"
			        set -l term_width $COLUMNS
			        set_color 444
			        string repeat -n $term_width "─"
			        set_color normal
			    end
			end
		'';
		shellInit = ''
    # Your fish initialization here
    if test -d "$HOME/.cargo/bin"
      set -p fish_user_paths "$HOME/.cargo/bin"
    end
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
	if test -d "/usr/local/sessionmanagerplugin"
	  set -p fish_user_paths "/usr/local/sessionmanagerplugin/bin"
	end
	if test -d "$HOME/.local/bin"
      set -p fish_user_paths "$HOME/.local/bin"
    end
    fish_add_path /Users/orca/.opencode/bin

    if test -d "$HOME/.config/emacs/bin"
      set -p fish_user_paths "$HOME/.config/emacs/bin"
    end
    if command --search --quiet "zoxide"
		zoxide init fish | source
	end

	if command --search --quiet "direnv"
		direnv hook fish | source
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
    source ~/.dotfiles/fish/.config/fish/gists.fish
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
