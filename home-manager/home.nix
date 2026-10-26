{ config, pkgs, inputs, ... }: {
	home = {
		username = "mimozyr";
		homeDirectory = "/home/mimozyr";
    stateVersion = "26.05";

    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  nixpkgs.overlays = [
    inputs.obsidian-extensions.overlays.default 
  ];

	programs.home-manager.enable = true;

	home.packages = with pkgs; [
  	(btop.override { cudaSupport = true; })
  	unzip
  	inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  	tmux
  	superfile
  	fastfetch
  	libreoffice
  	fish
  	alacritty
  	vesktop
    foliate
    bat
    lsd
    fd
    fzf
    ripgrep
    zoxide
    steam
    git
    obsidian
    localsend
    wireshark
    fuzzel
    calibre
    fnott
    hyprlock
    bibata-cursors
    awww
    ciscoPacketTracer9
    libnotify
	];
}
