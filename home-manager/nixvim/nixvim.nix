{

  imports = [
    ./opts.nix
    ./keymaps.nix
    ./autocmds.nix
    ./plugins/plugins-bundle.nix
  ];

  programs.nixvim = {
    enable = true;

    defaultEditor = true;
    colorschemes.oxocarbon.enable = true;
  
    extraConfigLuaPre = ''
     vim.g.mapleader = " "
     vim.g.maplocalleader = " "
   '';
  };
}
