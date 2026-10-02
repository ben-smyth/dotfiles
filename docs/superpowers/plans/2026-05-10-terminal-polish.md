# Terminal Polish Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Improve the shell MOTD, tmux status styling, and Markview Markdown rendering while keeping the changes narrow and dotfiles-native.

**Architecture:** Keep the existing Home Manager and linked-dotfile structure. MOTD logic stays in `.ben_scripts.sh`; tmux remains configured through `nix/config/tmux.nix`; Markview remains a lazy.nvim plugin spec with explicit options and highlight setup.

**Tech Stack:** zsh, Home Manager/Nix, tmux, Neovim Lua, lazy.nvim, Markview.nvim, Catppuccin tmux theme.

---

### Task 1: MOTD Bash Tip Source

**Files:**
- Modify: `dotfiles/.ben_scripts.sh`

- [ ] **Step 1: Add a curated passive bash tip source**

Add `_printBashTip` near the existing MOTD helpers. It should define a local array of `name|example|description` records and print one random entry using the same `TIL` format as existing helpers.

- [ ] **Step 2: Prefer bash tips before tldr**

Update `getCheatSheet` so it calls `_printBashTip` first, then keeps the existing `tldr` and local cheat fallbacks.

- [ ] **Step 3: Verify zsh parsing**

Run: `zsh -n dotfiles/.ben_scripts.sh`

Expected: exit code `0`.

### Task 2: Transparent Minimal tmux

**Files:**
- Modify: `nix/config/tmux.nix`

- [ ] **Step 1: Remove unused Tokyo Night theme plugin**

Remove the `tokyo-night` local plugin definition, remove it from the plugin list, and remove Tokyo Night options from `extraConfig`.

- [ ] **Step 2: Make Catppuccin status transparent and compact**

Keep Catppuccin loaded, but set transparent/default status styling, simple separators, compact icon-led `status-left` and `status-right`, subdued pane borders, and no dense widgets.

- [ ] **Step 3: Verify generated tmux config is syntactically plausible**

Run a focused text check by reading the edited Nix file and then run a Nix parse/build check if practical.

Expected: no obvious tmux syntax issues, and Nix formatting remains valid.

### Task 3: Softer Markview Rendering

**Files:**
- Modify: `dotfiles/.config/nvim/lua/custom/lazyPlugins/markview.lua`

- [ ] **Step 1: Configure Markview explicitly**

Change the plugin spec to load eagerly, use `nvim-web-devicons`, use Markview simple presets for headings/rules/tables, configure transparent-friendly preview options, and add a toggle keymap.

- [ ] **Step 2: Add subtle highlight overrides**

Add an `init` or `config` callback that defines transparent-friendly Markview highlight groups using thin accents rather than filled blocks.

- [ ] **Step 3: Verify Lua parsing**

Run: `luac -p dotfiles/.config/nvim/lua/custom/lazyPlugins/markview.lua`

Expected: exit code `0`.

### Task 4: Repository Cleanup and Verification

**Files:**
- Modify if needed: `.gitignore`
- Generated-only cleanup: `.superpowers/brainstorm/...`

- [ ] **Step 1: Ignore visual companion artifacts if any remain**

Add `.superpowers/` to `.gitignore` if the brainstorming artifacts remain in the workspace.

- [ ] **Step 2: Run narrow verification**

Run:

```bash
zsh -n dotfiles/.ben_scripts.sh
luac -p dotfiles/.config/nvim/lua/custom/lazyPlugins/markview.lua
nix eval .#darwinConfigurations.bennym4p.config.programs.tmux.enable
```

Expected:

```text
true
```

for the Nix eval command, and exit code `0` for all commands.

- [ ] **Step 3: Run build-only check if practical**

Run: `nix/scripts/update_system.sh bennym4p --no-update --build-only`

Expected: build completes successfully. If it is too slow or fails due sandbox/network/environment, report that accurately.
