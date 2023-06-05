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
      alacritty
      bat
      cod # broken in 22.05
      delta
      diff-so-fancy
      emacs
      fd
      fishPlugins.done
      fishPlugins.fzf-fish
      fishPlugins.forgit
      fishPlugins.hydro
      fzf
      gh
      kakoune
      # kitty
      luajit
      lsd
      mpv
      neovim
      nodejs
      openssl
      ripgrep
      tex
      # starship
      tmux
      tmuxPlugins.extrakto
      ghostscript
      graphicsmagick
      imagemagick
      pandoc
      vim
      vscode # needs nixpkgs.config.allowUnfree
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
