# Dotfiles Repo Instructions

## Scope

These instructions apply when working in `~/dotfiles`.

## Dotfiles

- Home Manager dotfile links are defined in `nix/modules/home/files.nix`.
- Prefer out-of-store symlinks for editable dotfiles.
- Use `nix/scripts/update_system.sh <configuration> --no-update --build-only`
  for build-only checks when practical.
- Avoid leaving Nix `result*` links in the repo.

## Agent Config

- Global agent instructions live in `.agents/AGENTS.md`.
- Home Manager links `.agents/AGENTS.md` into both `~/.codex/AGENTS.md` and
  `~/.claude/CLAUDE.md`.
- Edit `.agents/AGENTS.md` for global personal defaults.
- Edit this repo-root `AGENTS.md` for dotfiles-specific instructions.
- `CLAUDE.md` should remain a compatibility symlink to `AGENTS.md` for Claude
  Code.
- Do not copy live `~/.codex` or `~/.claude` directories into this repo.
