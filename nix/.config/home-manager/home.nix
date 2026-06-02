{ config, pkgs, ... }:

{
  home.username = "orca";
  home.homeDirectory = "/Users/orca";
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    awscli2
    cargo
    colima
    delta
    docker
    docker-buildx
    docker-compose
    docker-credential-helpers
    espeak-ng
    fd
    ffmpeg
    gdu
    gh
    ghostscript
    gnutar
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
    rclone
    ripgrep
    rsync
    rustc
    sad
    sox
    stow
    syncthing
    nerd-fonts._0xproto
    tmux
    tmuxPlugins.extrakto
    trash-cli
    uv
    vim
    zstd
  ];

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
        "--cpu" "6"
        "--memory" "16"
        "--disk" "100"
        "--vm-type" "vz"
        "--mount-type" "virtiofs"
        "--vz-rosetta"
        "--network-address"
      ];
    };
  };

  home.sessionVariables = {
    DOCKER_HOST = "unix://${config.home.homeDirectory}/.colima/default/docker.sock";
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
