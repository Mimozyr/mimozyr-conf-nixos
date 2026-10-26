{
  programs.nixvim.plugins.lualine = {
    enable = true;
    
    settings = {
      globalstatus = true;
      options = {
        theme = "auto";
        icons_enabled = true;
        # Убираем globalstatus для простоты
      };

      sections = {
        lualine_a = ["mode"];
        lualine_b = ["branch"];
        lualine_c = ["filename" "diff"];
        lualine_x = ["diagnostics" "filetype"];
        lualine_y = ["progress"];
        lualine_z = ["location"];
      };
    };
  };
}
