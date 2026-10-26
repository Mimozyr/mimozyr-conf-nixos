{ pkgs, ... }:
{
  home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font Mono:size=12";
        prompt = "\"> \"";
        placeholder = "run...";
        icons-enabled = "no";       # без иконок, как в терминале
        width = 50;
        lines = 10;
        horizontal-pad = 20;
        vertical-pad = 14;
        inner-pad = 8;
        line-height = 20;
        letter-spacing = 0;
        terminal = "alacritty";          # замените на свой терминал
        layer = "overlay";
      };

      # формат цвета: RRGGBBAA, без решётки
      colors = {
        background        = "0a0a0aF2";
        text              = "c0caf5ff";
        prompt            = "7aa2f7ff";
        placeholder       = "565f89ff";
        input             = "c0caf5ff";
        match             = "7aa2f7ff";
        selection         = "7aa2f7ff";
        selection-text    = "0a0a0aff";
        selection-match   = "0a0a0aff";
        counter           = "565f89ff";
        border            = "7aa2f7ff";
      };

      border = {
        width = 2;
        radius = 0;                 # прямые углы
      };
    };
  };
}
