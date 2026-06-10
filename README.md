# dotfiles

Personal shell and development-environment configuration for macOS.

> ## Status
>
> Published as a personal repo, not a managed product. Issues and PRs are welcome but won't get fast turnaround.
>
> **This repo is in-flight.**

Contents:
- `.zshrc` — interactive shell config (aliases, PATH, completions, history, direnv, vi mode, fzf/zoxide/starship integration)
- `.zprofile` — login shell config (Homebrew shellenv, OrbStack, JetBrains Toolbox)
- `.gitconfig` — git identity, aliases, and defaults
- `.gitignore_global` — global gitignore patterns
- `Brewfile` — packages the dotfiles expect (`brew bundle --file Brewfile` on a new machine)

The project-bootstrap templates (`CLAUDE.md`/`README.md` boilerplate,
new-project checklist, Python agentic-workflow scaffolding) that used to
live under `templates/` here have moved to their own repo,
`agentic-scaffold`. Their development history up to the move remains in
this repo's git history.

## AI-assisted

Portions of this repository were authored or edited with the assistance of AI tools.
