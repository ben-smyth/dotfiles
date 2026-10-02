{ inputs, pkgs, ... }:
let
  catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "flake-input";
    src = inputs.catppuccin-tmux;
  };

in
  {
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    disableConfirmationPrompt = true;
    keyMode = "vi";
    newSession = true;
    secureSocket = true;
    shortcut = "a";
    terminal = "screen-256color";

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      yank
      catppuccin
    ];

    extraConfig = ''
    # set-default colorset-option -ga terminal-overrides ",xterm-256color:Tc"
    set -as terminal-features ",xterm-256color:RGB"
    # set-option -sa terminal-overrides ",xterm*:Tc"
    set -g mouse on

    unbind C-b
    set -g prefix C-Space
    bind C-Space send-prefix

    # Vim style pane selection
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R
    bind -r Left  resize-pane -L 5   # shrink  ← 5 cells
    bind -r Right resize-pane -R 5   # grow    → 5 cells
    bind -r Up    resize-pane -U 3   # grow    ↑ 3 rows
    bind -r Down  resize-pane -D 3   # shrink  ↓ 3 rows

    # Start windows and panes at 1, not 0
    set -g base-index 1
    set -g pane-base-index 1
    set-window-option -g pane-base-index 1
    set-option -g renumber-windows on

    # Use Alt-arrow keys without prefix key to switch panes
    bind -n M-Left select-pane -L
    bind -n M-Right select-pane -R
    bind -n M-Up select-pane -U
    bind -n M-Down select-pane -D

    # Shift arrow to switch windows
    bind -n S-Left  previous-window
    bind -n S-Right next-window

    # Shift Alt vim keys to switch windows
    bind -n M-H previous-window
    bind -n M-L next-window

    # set vi-mode
    set-window-option -g mode-keys vi

    # theme
    set -g @catppuccin_flavour 'mocha'          # latte, frappe, macchiato, mocha
    set -g @catppuccin_window_tabs_enabled on   # move windows into centre tabs
    set -g @catppuccin_user off
    set -g @catppuccin_host off
    set -g @catppuccin_right_separator  ""
    set -g @catppuccin_left_separator ""

    # load the theme (must be *after* the settings above)
    run-shell ${catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux

    # Transparent calm status line.
    set -g status-style "fg=#cdd6f4,bg=default"
    set -g status-left-length 40
    set -g status-right-length 100
    set -g status-left "#[fg=#89b4fa,bg=default]󰆍 #S #[fg=#6c7086,bg=default]│ "
    set -g status-right "#[fg=#a6e3a1,bg=default] #{b:pane_current_path} "
    set -g window-status-separator " "
    set -g window-status-format "#[fg=#6c7086,bg=default]#I:#W"
    set -g window-status-current-format "#[fg=#89b4fa,bg=default]#I:#W"
    set -g pane-border-style "fg=#45475a,bg=default"
    set -g pane-active-border-style "fg=#89b4fa,bg=default"
    set -g message-style "fg=#cdd6f4,bg=default"
    set -g mode-style "fg=#11111b,bg=#89b4fa"

    # keybindings
    bind-key -T copy-mode-vi v send-keys -X begin-selection
    bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
    bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

    bind '"' split-window -v -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"
    bind c new-window -c "#{pane_current_path}"
    set -g default-shell  ${pkgs.zsh}/bin/zsh
    set -g default-command "${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace -l ${pkgs.zsh}/bin/zsh"
    '';
  };
}
