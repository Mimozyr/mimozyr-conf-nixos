{ pkgs, ... }:
{
  home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  services.fnott = {
    enable = true;
    settings = {
      main = {
        # --- положение и размеры ---
        anchor = "top-right";
        stacking-order = "top-down";
        layer = "overlay";
        edge-margin-vertical = 20;
        edge-margin-horizontal = 20;
        notification-margin = 10;
        min-width = 320;
        max-width = 420;
        padding-vertical = 14;
        padding-horizontal = 16;

        # --- рамка: прямые углы, как у fuzzel и локскрина ---
        border-size = 2;
        border-radius = 0;

        # --- шрифты ---
        title-font   = "JetBrainsMono Nerd Font Mono:size=9";
        summary-font = "JetBrainsMono Nerd Font Mono:weight=bold:size=12";
        body-font    = "JetBrainsMono Nerd Font Mono:size=11";

        # --- форматы: приложение в скобках, заголовок с приглашением ---
        title-format   = "[%a%A]";
        summary-format = "<b>> %s</b>\\n";
        body-format    = "%b";

        # --- цвета (RRGGBBAA, без #), палитра Tokyo Night ---
        background     = "0a0a0af2";
        border-color   = "7aa2f7ff";
        title-color    = "565f89ff";
        summary-color  = "7aa2f7ff";
        body-color     = "c0caf5ff";
        progress-color = "7aa2f7ff";
        progress-style = "bar";
        progress-bar-height = 8;

        # --- без иконок для строгого вида ---
        max-icon-size = 0;

        # --- исчезновение через 5 секунд ---
        default-timeout = 5;
        max-timeout = 5;
      };

      low = {
        background    = "0a0a0af2";
        border-color  = "565f89ff";
        title-color   = "3b4261ff";
        summary-color = "565f89ff";
        body-color    = "565f89ff";
      };

      normal = {
        background   = "0a0a0af2";
        border-color = "7aa2f7ff";
      };

      critical = {
        background    = "0a0a0af2";
        border-color  = "f7768eff";
        title-color   = "f7768eff";
        summary-color = "f7768eff";
        body-color    = "c0caf5ff";
      };
    };
  };
}
