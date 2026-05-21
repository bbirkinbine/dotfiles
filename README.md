# dotfiles

Personal shell and development-environment configuration for macOS.

> ## Status
>
> Published as a personal repo, not a managed product. Issues and PRs are welcome but won't get fast turnaround.
>
> **This repo is in-flight.**

Contents:
- `.zshrc` — interactive shell config (aliases, PATH, completions, direnv, vi mode)
- `.zprofile` — login shell config (Homebrew shellenv, OrbStack, JetBrains Toolbox)
- `.gitconfig` — git identity, aliases, and defaults
- `.gitignore_global` — global gitignore patterns
- [`templates/`](templates/) — reusable boilerplate (`CLAUDE.md`, `README.md`,
  GitHub About checklist, new-project checklist) for new repositories.
  See [`templates/README.md`](templates/README.md).

## Quick start — new project from this repo

**Python project with the agentic workflow:**

```bash
cd ~/Downloads/src/new-project
bash ~/Downloads/src/dotfiles/templates/python/bootstrap.sh
```

Then read [`templates/python/WORKFLOW.md`](templates/python/WORKFLOW.md) — day-zero checklist + per-feature loop walkthrough.

**Non-Python repo:** copy [`templates/CLAUDE.md.template`](templates/CLAUDE.md.template) and [`templates/README.md.template`](templates/README.md.template), fill the `{{placeholders}}`, then walk [`templates/new-project-checklist.md`](templates/new-project-checklist.md).

Either way: [`templates/README.md`](templates/README.md) is the flavor switchboard with more context.

## AI-assisted

Portions of this repository were authored or edited with the assistance of AI tools.
