{ config, lib, ... }: {
  programs.nixvim = {
    globals = {
      mapleader = "\\";
      maplocalleader = "\\";
    };

    keymaps = [
	{
		key = "<leader>ff";
		action = "<cmd>Telescope find_diles<cr>";
		options = {
			silent = true;
			desc = "Find files";
		};
	}
	{
		key = "<leader>n";
		action = ":Neotree<CR>";
		options = {
			silent = true;
			desc = "Open Neotree";
		};
	}
	{
		key = "<esc>";
		action = ":noh<CR>";
		mode = "n";
		options = {
			silent = true;
			desc = "Clear search highlight";
		};
	}
	{
		key = "Y";
		action = "y$";
		mode = "n";
		options = {
			silent = true;
			desc = "Yank to end of line";
		};
	}
	{
		key = "<C-c>";
		action = ":b#<CR>";
		mode = "n";
		options = {
			silent = true;
			desc = "Switch to previous buffer";
		};
	}
	{
		key = "<C-x>";
		action = "<cmd>bdelete<cr>";
		mode = "n";
		options = {
			silent = true;
			desc = "Close buffer";
		};
	}
	{
		key = "<leader>s";
		action = ":w<CR>";
		mode = "n";
		options = {
			silent = true;
			desc = "Save file";
		};
	}
	{
		key = "<leader>S>";
		action = ":w<CR>";
		mode = "n";
		options = {
			silent = true;
			desc = "Save file";
		};
	}
	{
		key = "<leader>h";
		action = "<C-w>h";
		mode = "n";
		options = {
			silent = true;
			desc = "Go to left window";
		};
	}
	{
		key = "<leader>j";
		action = "<C-w>j";
		mode = "n";
		options = {
			silent = true;
			desc = "Go to down window";
		};
	}
	{
		key = "<leader>k";
		action = "<C-w>k";
		mode = "n";
		options = {
			silent = true;
			desc = "Go to up window";
		};
	}
	{
		key = "<leader>l";
		action = "<C-w>l";
		mode = "n";
		options = {
			silent = true;
			desc = "Go to right window";
		};
	}
	{
		key = "<C-Up>";
		action = ":resize -2<CR>";
		mode = "n";
		options = {
			silent = true;
			desc = "Decrease window height";
		};
	}
	{
		key = "<C-Down>";
		action = ":resize +2<CR>";
		mode = "n";
		options = {
			silent = true;
			desc = "Increase window height";
		};
	}
	{
		key = "<C-Left>";
		action = ":vertical resize +2<CR>";
		mode = "n";
		options = {
			silent = true;
			desc = "Increase window wifth";
		};
	}
	{
		key = "<C-Right";
		action = ":vertical resize -2<CR>";
		mode = "n";
		options = {
			silent = true;
			desc = "Decrease window width";
		};
	}
	{
		key = "<M-k>";
		action = ":move-2<CR>";
		mode = "n";
		options = {
			silent = true;
			desc = "Move line up";
		};
	}
	{
		key = "<M-j>";
		action = ":move+<CR>";
		mode = "n";
		options = {
			silent = true;
			desc = "Move line down";
		};
	}
	{
		key = "K";
		action = ":m '<-2<CR>gv=gv";
		mode = "n";
		options = {
			silent = true;
			desc = "Move selection up";
		};
	}
	{
		key = "J";
		action = ":m '>+1<CR>gv=gv";
		mode = "n";
		options = {
			silent = true;
			desc = "Move selection down";
		};
	}
	{
		key = "<Tab>";
		action = "<cmd>BufferLineCycleNext<cr>";
		mode = "n";
		options = {
			silent = true;
			desc = "Next buffer";
		};
	}
	{
		key = "<S-Tab>";
		action = "<cmd>BufferLineCyclePrev<cr>";
		mode = "n";
		options = {
			silent = true;
			desc = "Previous buffer";
		};
	}
    ];
      
  };
}
