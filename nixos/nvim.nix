{ config, lib, pkgs, ... }:

{
	programs.nixvim = {

		enable = true;
		defaultEditor = true;
		
		opts = {
			number = true;
			clipboard = "unnamedplus";
			relativenumber = true;

		};

		plugins = {
			neo-tree.enable = true;
			telescope.enable = true;

			treesitter = {
				enable = true;
				settings = {
					ensure_installed = [ "c" "lua" "python" "bash" "vim" "javascript" "html" "css" ];

				};
			};
			gitsigns.enable = true;


			lsp = {
				enable = true;
				servers = {
					pyright.enable = true;
					ts_ls.enable = true;
					clangd.enable = true;
					lua_ls.enable = true;
				};
	
			};
		};
	};

}
