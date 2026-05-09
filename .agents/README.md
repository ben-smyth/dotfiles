# Agent Config

This directory contains versioned, human-written instructions for coding agents.

Keep here:

- Shared repo guidance such as `AGENTS.md`.
- Small tool-specific instruction files when they are safe to commit.
- Notes about how agent config is linked into the repo.

Keep out of Git:

- `~/.codex/auth.json`, histories, logs, sessions, caches, SQLite files, and
  generated plugin or skill caches.
- `~/.claude` histories, sessions, caches, downloads, paste/file history, and
  generated plugin state.
- Any credentials, tokens, private conversations, or machine-local runtime
  state.

Repo-root `AGENTS.md` and `CLAUDE.md` files should not live in this dotfiles
repo unless the dotfiles repo needs project-specific overrides. Home Manager
links `.agents/AGENTS.md` into global locations instead:

- `~/.codex/AGENTS.md`
- `~/.claude/CLAUDE.md`

For other repositories, prefer this pattern:

- `.agents/AGENTS.md` as the canonical repo-specific source.
- `AGENTS.md -> .agents/AGENTS.md` for Codex and other AGENTS-compatible tools.
- `CLAUDE.md -> .agents/AGENTS.md` for Claude Code, unless that repo already
  uses `.claude/CLAUDE.md`.
