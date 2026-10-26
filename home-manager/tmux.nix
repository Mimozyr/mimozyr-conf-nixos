{ pkgs, config, inputs, ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    baseIndex = 1;
    shell = "${pkgs.fish}/bin/fish";
    extraConfig = ''
      unbind -a -T root

      set -g pane-border-lines double
      set -g detach-on-destroy off    # при удалении сессии переходить в другую, а не отсоединяться

      set -g focus-events on

      set -sg escape-time 10

      bind -n M-s choose-tree -Zs     # список сессий
      bind -n M-n command-prompt -p "New session:" "new-session -d -s '%%' ; switch-client -t '%%'"
      bind -n M-, switch-client -p    # предыдущая сессия
      bind -n M-. switch-client -n    # следующая сессия
      bind -n M-Tab switch-client -l  # последняя использованная

      bind -n M-r source-file ~/.config/tmux/tmux.conf \; display 'Config reloaded!'
      bind -n M-Enter new-window

      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "${pkgs.wl-clipboard}/bin/wl-copy"
      bind -n M-u copy-mode

      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      bind -n M-h select-pane -L
      bind -n M-l select-pane -R
      bind -n M-k select-pane -U
      bind -n M-j select-pane -D

      bind -n M-S-h resize-pane -L 5
      bind -n M-S-l resize-pane -R 5
      bind -n M-S-k resize-pane -U 3
      bind -n M-S-j resize-pane -D 3

      bind -n M-z resize-pane -Z

      bind -n M-c kill-pane
      bind -n M-q kill-window
      bind -n M-d detach
      bind -n M-Q confirm-before -p 'Kill entire session? (y/n)' kill-session

      bind -n M-b split-window -v
      bind -n M-v split-window -h
      '';
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = tokyo-night-tmux;
        extraConfig = ''
          set -g @tokyo-night-tmux_theme night
          set -g @tokyo-night-tmux_window_id_style digital
          set -g @tokyo-night-tmux_show_wbg 1
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-hook-post-save-all 'sed -i --follow-symlinks -E "s,:/nix/store/[a-z0-9]+-neovim-unwrapped-[^/]+/bin/nvim( --cmd set [a-z]+\^=[^ ]+)*,:nvim," ~/.tmux/resurrect/last'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-save-interval '10'
          set -g @continuum-restore 'on'
        '';
      }
      tmux-fzf
];
  };
}
