{
  programs.nixvim.plugins.auto-session = {
    enable = true;
  };

  programs.nixvim = {
    opts.sessionoptions = "buffers,curdir,tabpages,winsize,folds";
  };
  programs.nixvim.autoCmd = [
  {
    event = [ "BufWritePost" "FocusLost" ];
    callback.__raw = ''
      function()
        if vim.api.nvim_buf_get_name(0) ~= "" then
          vim.cmd("silent! SessionSave")
        end
      end
    '';
  }
];
}
