{
  programs.nixvim.plugins = {

    treesitter = {
      enable = true;
      nixGrammars = true;
      settings = {
	      ensure_installed = [ "python" "nix" "lua" "bash" "markdown" "json" "c" "cpp" "html" "css" "javascript" "markdown" "markdown_inline" ];
	      highlight = {
		      enable = true;
	      };
	      indent = {
		      enable = true;
	      };
      };
    };

    lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
        pyright.enable = true;
        clangd.enable = true;
        html.enable = true;
        cssls.enable = true;
        jsonls.enable = true;
        marksman.enable = true;
        rust_analyzer.enable = true;
        ts_ls.enable = true;
        bashls.enable = true;
        
      };
    };

  };
}

