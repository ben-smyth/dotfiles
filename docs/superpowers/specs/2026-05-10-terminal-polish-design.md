# Terminal Polish Design

## Goal

Improve the daily terminal/editor experience in three focused areas:

- Make the shell MOTD feel like a useful passive bash cheat sheet, including both general bash techniques and examples that pipe commands together.
- Make tmux visually quieter, more transparent, and icon-led without losing useful session context.
- Make Markview in Neovim less blocky and more readable for Markdown.

## Existing Context

The shell MOTD is printed once per interactive zsh session from `dotfiles/.zshrc`, which calls `getCheatSheet` in `dotfiles/.ben_scripts.sh`. That function currently prefers `tldr` examples, then falls back to personal examples in `dotfiles/.cheats.txt`.

tmux is managed through Home Manager in `nix/config/tmux.nix`. It currently loads both Tokyo Night and Catppuccin tmux plugins, then explicitly runs Catppuccin and overrides `status-right` to show the current folder.

Markview is configured in `dotfiles/.config/nvim/lua/custom/lazyPlugins/markview.lua`. It currently installs `OXY2DEV/markview.nvim` with default rendering and lazy-loads on Markdown filetype.

## MOTD Design

Keep the MOTD passive: one concise `TIL` line per new interactive shell. Do not add an interactive launcher as the primary experience.

The MOTD source order should become:

1. A curated set of general bash and pipeline tips.
2. `tldr` examples for installed tools.
3. Personal dotfile examples from `.cheats.txt`.

The curated tip set should live with the existing MOTD code in `.ben_scripts.sh`, not as a standalone manual. It should include general bash techniques such as command substitution, process substitution, brace expansion, history expansion, `set -euo pipefail`, `trap`, `for` loops, `while read`, globs, redirection, subshells, exit status checks, and parameter expansion. It should also include pipeline examples such as `rg | fzf | xargs`, `ps | sort | head`, `find | xargs`, `jq | sort | uniq`, and `curl | jq`.

The output stays visually compact:

```text
TIL bash - loop over command output safely
  $ rg -l TODO | while read -r file; do nvim "$file"; done
```

## tmux Design

Use the "Transparent Calm" direction from the visual comparison:

- Transparent/default status background so the terminal opacity shows through.
- Keep Catppuccin as the color palette, but remove chunky separators and dense widgets.
- Prefer a small number of Nerd Font icons where they improve scanning.
- Show compact session/window context on the left.
- Show compact current directory context on the right.
- Keep pane borders low contrast, with a slightly brighter active pane border.
- Keep existing navigation, copy-mode, split, shell, and macOS reattach behavior unchanged.

Tokyo Night should be removed from active tmux plugins unless it is still needed elsewhere, because the config currently loads both themes but only Catppuccin is intentionally run.

## Markview Design

Configure Markview explicitly instead of relying on defaults:

- Load Markview eagerly so it initializes after the colorscheme, matching upstream guidance.
- Use `nvim-web-devicons` as the icon provider.
- Use simple Markview presets for headings, horizontal rules, and tables where possible.
- Prefer thin accents over filled blocks for headings, quotes, and code blocks.
- Add small custom highlight groups after the colorscheme is active so rendered Markdown remains transparent-friendly.
- Add a simple keymap to toggle Markview if there is no conflicting local convention.

The target look is readable Markdown preview with subtle structure, not a fully boxed document renderer.

## Verification

Use narrow checks first:

- Run a Lua syntax check for touched Neovim Lua files if available.
- Run a tmux config parse check where practical.
- Run a Nix build-only check with `nix/scripts/update_system.sh <configuration> --no-update --build-only` if practical and not too slow.

Do not run Git commands unless the user explicitly asks for a Git operation.

## Out of Scope

- Replacing zsh or Powerlevel10k.
- Adding an interactive cheatsheet widget as the primary MOTD experience.
- Reworking the whole Neovim colorscheme.
- Large tmux theme/plugin migrations beyond removing unused theme noise.
- Turning `.cheats.txt` into a full manual.
