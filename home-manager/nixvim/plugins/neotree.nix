{
  programs.nixvim = {
    enable = true;
    # Глобальные бинды для открытия плагинов
    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        options = { desc = "Toggle Neo-tree"; };
      }
      
      # Ваши Telescope бинды (если они здесь)
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>lua require('telescope.builtin').find_files()<cr>";
        options = { desc = "Find Files"; };
      }
    ];

    plugins = {
      neo-tree = {
        enable = true;
        
        settings = {
          filesystem = {
            follow_current_file = { enable = true; };
            filtered_items = {
              hide_dotfiles = false;
              hide_gitignored = false;
              hide_hidden = false;
            };
            group_empty_dirs = true;
          };

          closeIfLastWindow = true;

          window = {
            width = 35;
            position = "left";
            
            # Локальные бинды внутри Neo-tree
            mappings = {
              "<space>" = "toggle_node";
              "<cr>" = "open";
              "v" = "vsplit";
              "s" = "split";
              "d" = "delete";
              "r" = "rename";
              "c" = "copy";
              "m" = "move";
              "a" = "add";
              "A" = "add_directory";
            };
          };

          default_component_configs = {
            indent = {
              indent_size = 2;
              padding = 1;
              with_markers = true;
              with_expanders = true;
            };
            
            icon = {
              folder_closed = "";
              folder_open = "";
              folder_empty = "";
              default = "";
            };
            
            name = {
              trailing_slash = false;
              highlight_opened_files = true;
              use_git_status_colors = true;
              wrap = true;
            };
            
            git_status = {
              enabled = true;
            };
          };

          git = {
            enable = true;
          };
        };
      };
    };
  };
}
