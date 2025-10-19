{ config, pkgs, ... }:

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  let
    tex = (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-basic
      xetex wrapfig xcolor microtype fontspec fontawesome fontawesome5 etoolbox enumitem titlesec amsmath ulem hyperref capt-of;
      #(setq org-latex-compiler "lualatex")
      #(setq org-preview-latex-default-process 'dvisvgm)
    });
    in
{
    environment.systemPackages = with pkgs;
    [
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
      # kakoune
      # kitty
      lazygit
      luajit
      lsd
      mpv
      neovim
      nil # nix language server
      nixpkgs-fmt
      nodejs
      pandoc
      pyright
      ripgrep
      sad
      tex
      # starship
      tmux
      tmuxPlugins.extrakto
      vim
      vscode # needs nixpkgs.config.allowUnfree
      zoxide
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
	nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
