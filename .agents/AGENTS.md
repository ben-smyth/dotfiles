# Global Agent Instructions

## Scope

These instructions are personal defaults for agent sessions on this machine.
Project-level instruction files may add more specific guidance.

## Working Rules

- Read the relevant files before changing behavior. Prefer existing repo
  patterns over new structure.
- Preserve user work. The tree may be dirty; do not revert changes you did not
  make.
- Keep edits narrow and practical. Avoid unrelated cleanup.
- Prefer `rg` and `rg --files` for search.
- Do not commit secrets, machine state, histories, caches, sessions, logs, or
  SQLite databases.

## Agent Config

- `~/dotfiles/.agents/AGENTS.md` is the canonical shared instruction file.
- Home Manager links this file into global agent locations.
- `~/.codex/AGENTS.md` is the global Codex instruction file.
- `~/.claude/CLAUDE.md` is the global Claude Code instruction file.
- Edit the canonical `.agents/AGENTS.md` source, not the symlinked files under
  `~/.codex` or `~/.claude`.
- Do not copy live `~/.codex` or `~/.claude` directories into this repo.
- If tool-specific instructions are needed later, put them under `.agents/`
  and keep live app state outside Git.

## Repo-Level Agent Instructions

When adding or updating repo-specific agent instructions:

- Prefer `.agents/AGENTS.md` as the canonical source inside the repo.
- If `.agents/AGENTS.md` is missing and repo-specific guidance is requested,
  create it before adding compatibility links.
- For Codex and AGENTS-compatible tools, create a repo-root `AGENTS.md` symlink
  to `.agents/AGENTS.md` when one does not already exist.
- For Claude Code, create a repo-root `CLAUDE.md` symlink to
  `.agents/AGENTS.md`, unless the repo already uses `.claude/CLAUDE.md`.
- Do not overwrite a real `AGENTS.md`, `CLAUDE.md`, or `.claude/CLAUDE.md`
  without checking with the user.
- Make instruction updates in `.agents/AGENTS.md`, not in symlink files or live
  `.codex` / `.claude` state directories.

## Dotfiles Repo

When working in `~/dotfiles`:

- Home Manager dotfile links are defined in `nix/modules/home/files.nix`.
- Prefer out-of-store symlinks for editable dotfiles.
- Use `nix/scripts/update_system.sh <configuration> --no-update --build-only`
  for build-only checks when practical.
- Avoid leaving Nix `result*` links in the repo.
