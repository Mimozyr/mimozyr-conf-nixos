{ pkgs, config, inputs, ... }: {
  programs.git = {
    enable = true;
    settings.user = {
      name = "Kut4b4re";
      email = "kut4b4re@proton.me";
    };
  };
}
