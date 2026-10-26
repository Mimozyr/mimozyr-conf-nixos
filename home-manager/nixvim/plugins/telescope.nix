{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>lua require('telescope.builtin').find_files()<cr>";
        options = { desc = "Find Files"; };
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>lua require('telescope.builtin').buffers()<cr>";
        options = { desc = "Find Buffers"; };
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>lua require('telescope.builtin').live_grep()<cr>";
        options = { desc = "Live Grep"; };
      }
      {
        mode = "n";
        key = "<leader>gf";
        action = "<cmd>lua require('telescope.builtin').git_files()<cr>";
        options = { desc = "Git Files"; };
      }
      {
        mode = "n";
        key = "<leader>of";
        action = "<cmd>lua require('telescope.builtin').oldfiles()<cr>";
        options = { desc = "Recent Files"; };
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>lua require('telescope.builtin').help_tags()<cr>";
        options = { desc = "Help Tags"; };
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = ":bwipeout<CR>";
        options = { desc = "Wipeout Buffer"; };
      }
    ];

    plugins = {
      telescope = {
        enable = true;

        settings = {
          defaults = {
            file_ignore_patterns = [
              "^%.git/"
              "^%.mypy_cache/"
              "^__pycache__/"
              "^output/"
              "^data/"
              "%.ipynb"
            ];
            set_env = { COLORTERM = "truecolor"; };
          };
          pickers = {
            buffers = {
              show_all_buffers = false;
              sort_lastused = true;
              theme = "dropdown"; 
            };
          };
        };
      };
    };
  };
}
