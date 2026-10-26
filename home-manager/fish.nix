{ config, lib, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    functions.fish_greeting = {
      body = "";
    };
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nix/";
      hms = "home-manager switch --flake ~/nix/";
      v = "nvim";
      sv = "sudo nvim";
      ls = "lsd";
      l = "ls -l";
      la = "ls -a";
      lla = "ls -la";
      lt = "ls --tree";
      cat = "bat";
      
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration  = true;
  };
}
