{ config, pkgs, inputs, ... }: {
  programs.obsidian = {
    enable = true;

    vaults.notes.target = "/nix/home-manager/Obsidian";
    defaultSettings.app = {
      alwaysUpdateLinks = true;
      spellcheck = true;
    };

    defaultSettings.corePlugins = [
      {
        name = "daily-notes";
        settings = {
          folder = "Daily";
          format = "DD-MM-YY";
        };
      }
      {
        name = "templates";
        settings.folder = "Templates";
      }
      "backlink"
      "bookmarks"
      "file-explorer"
      "global-search"
    ];
    defaultSettings = {
      appearance = {
        cssTheme = "obsiddy-in-terminal";
        theme = "dark";
        baseFontSize = 20;
      };
      communityPlugins = with pkgs.obsidianPlugins; [
        dataview 
        obsidian-git 
        obsidian-importer 
        vim-yank-highlight
        obsidian-excalidraw-plugin
      ];
      themes = with pkgs.obsidianThemes; [
        obsiddy-in-terminal
      ];
    };
  };
}
