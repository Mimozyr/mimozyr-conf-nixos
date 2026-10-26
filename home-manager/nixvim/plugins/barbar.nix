{
  programs.nixvim.plugins.bufferline = {
    enable = true;
    settings = {
	options = {
		mode = "buffers";
		separetor_style = "slant";
		always_show_bufferline = true;
		diagnostics = "nvim_lsp";
		show_buffer_icons = true;
		show_buffer_close_icons = true;
		show_close_icon = true;
		show_tab_indicators = true;
	};
    };
  };
}
