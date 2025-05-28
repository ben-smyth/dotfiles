{ pkgs, ... }:
let
  catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "dreamsofcode-io";
      repo = "catppuccin-tmux";
      rev = "main";
      sha256 = "sha256-FJHM6LJkiAwxaLd5pnAoF3a7AE1ZqHWoCpUJE0ncCA8=";
    };
  };
  tokyo-night = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tokyo-night";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "janoamaral";
      repo = "tokyo-night-tmux";
      rev = "master";
      sha256 = "sha256-3rMYYzzSS2jaAMLjcQoKreE0oo4VWF9dZgDtABCUOtY=";
    };
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
      tokyo-night
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

    set -g @tokyo-night-tmux_window_id_style hsquare
    set -g @tokyo-night-tmux_show_datetime 0

    # set vi-mode
    set-window-option -g mode-keys vi

    # theme
    set -g @catppuccin_flavour 'mocha'          # latte, frappe, macchiato, mocha
    set -g @catppuccin_window_tabs_enabled on   # move windows into centre tabs
    set -g @catppuccin_date_time "%a %d %b %H:%M"
    set -g @catppuccin_user on
    set -g @catppuccin_host on
    set -g @catppuccin_right_separator  ""
    set -g @catppuccin_left_separator ""

    # load the theme (must be *after* the settings above)
    run-shell ${catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux

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
