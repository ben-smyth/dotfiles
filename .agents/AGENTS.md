# Global Agent Instructions

## Scope

These instructions are personal defaults for agent sessions on this machine.
They should stay project-agnostic. Put repository-specific guidance in that
repository's `AGENTS.md`.

## Working Rules

- Default to review-first work. Inspect the relevant files and explain the
  proposed change before editing, unless the user explicitly asks for immediate
  implementation.
- Do not run `git` commands, create commits, push, pull, branch, rebase, reset,
  stage files, or use Git to inspect state unless the user explicitly asks for a
  Git operation.
- Read the relevant files before changing behavior. Prefer existing repo
  patterns over new structure.
- Preserve user work. The tree may be dirty; do not revert changes you did not
  make.
- Keep edits narrow and practical. Avoid unrelated cleanup.
- Prefer `rg` and `rg --files` for search.
- Do not commit secrets, machine state, histories, caches, sessions, logs, or
  SQLite databases.

## Global Agent Config

- `~/dotfiles/.agents/AGENTS.md` is the canonical global instruction source.
- Home Manager links this file into both global agent locations.
- `~/.codex/AGENTS.md` is the global Codex instruction file.
- `~/.claude/CLAUDE.md` is the global Claude Code instruction file.
- Edit the canonical `.agents/AGENTS.md` source, not the symlinked files under
  `~/.codex` or `~/.claude`.
- Do not copy live `~/.codex` or `~/.claude` directories into this repo.
- If global tool-specific instructions are needed later, put the versioned
  source under `.agents/` and keep live app state outside Git.

## Repo-Level Agent Instructions

When adding or updating repo-specific agent instructions:

- Prefer repo-root `AGENTS.md` as the canonical shared instruction file.
- For Claude Code, create repo-root `CLAUDE.md` as a symlink to `AGENTS.md`
  when possible. If symlinks are not suitable, use a tiny `CLAUDE.md` that
  imports `@AGENTS.md`.
- Do not use `.codex/` or `.claude/` as the only repo instruction location
  unless the user explicitly asks for a tool-specific setup.
- Do not overwrite a real `AGENTS.md`, `CLAUDE.md`, or `.claude/CLAUDE.md`
  without checking with the user first.
- Keep repo instruction files focused on project facts: layout, build and test
  commands, conventions, and project-specific constraints.
