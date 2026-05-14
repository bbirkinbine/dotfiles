# dotfiles

Personal shell and development-environment configuration for macOS.

Contents:
- `.zshrc` — interactive shell config (aliases, PATH, completions, direnv, vi mode)
- `.zprofile` — login shell config (Homebrew shellenv, OrbStack, JetBrains Toolbox)
- `.gitconfig` — git identity, aliases, and defaults
- `.gitignore_global` — global gitignore patterns
- [`templates/`](templates/) — reusable boilerplate (`CLAUDE.md`, `README.md`,
  GitHub About checklist, new-project checklist) for new repositories.
  See [`templates/README.md`](templates/README.md).

## Git identity policy

`user.email` in `.gitconfig` is set to the GitHub noreply address
(`585281+bbirkinbine@users.noreply.github.com`) so commits to any public
repo carry that address by default. Personal email is **not** used for git
operations — if a per-repo `.git/config` is ever discovered overriding the
global, fix it before the next commit. See
[`templates/new-project-checklist.md`](templates/new-project-checklist.md)
for the verification step at repo creation time.

## AI-assisted

Portions of this repository were authored or edited with the assistance of AI tools (e.g., Claude Code).
