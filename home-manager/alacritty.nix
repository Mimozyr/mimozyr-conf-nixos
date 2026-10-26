{ config , pkgs, lib, ... }:
{

  programs.alacritty = {

    enable = true;
    settings = {
      window = {
        decorations = "None";
      };

      terminal = {
        shell = "fish";
      };

      colors.primary = {
        background = "#000000";
      };

      cursor = {
        style = "Beam";
      };

      font = {
        normal = {
          family = "FantasqueSansM Nerd Font Mono";
          style = "Regular";
        };

        bold = {
          family = "FantasqueSansM Nerd Font Mono";
          style = "Bold";
        };

        italic = {
          family = "FantasqueSansM Nerd Font Mono";
          style = "italic";
        };

        bold_italic = {
          family = "FantasqueSansM Nerd Font Mono";
          style = "Bold Italic";
        };
        size = 13.0;
      };
    };
  };

}
