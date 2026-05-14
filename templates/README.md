# Project templates

Reusable boilerplate for new repositories under `~/Downloads/src/`. Drop the
relevant file into a fresh repo and fill in the `{{PLACEHOLDER}}` slots.

## Files

- [`CLAUDE.md.template`](CLAUDE.md.template) — top-level project context for
  Claude Code (and any other AI coding agent). Includes the standard
  no-co-author and no-AI-footer rules.
- [`README.md.template`](README.md.template) — human-facing GitHub landing
  page. Includes the standard Status block and AI-tools Acknowledgements.
- [`github-about.md`](github-about.md) — checklist for the GitHub repo's
  "About" sidebar (description, website, topics — specifically the
  `ai-assisted` tag).
- [`new-project-checklist.md`](new-project-checklist.md) — copy of the
  Obsidian checklist, mirrored here so the dotfiles repo is self-contained
  even if you're working on a machine without the vault.

## How to use

1. `cd` into the new project directory.
2. Copy whichever templates you need:
   ```
   cp ~/Downloads/src/dotfiles/templates/CLAUDE.md.template  ./CLAUDE.md
   cp ~/Downloads/src/dotfiles/templates/README.md.template  ./README.md
   ```
3. Replace every `{{...}}` placeholder. Search the file with
   `rg '{{' .` to make sure none are left behind.
4. Walk the rest of `new-project-checklist.md` — GitHub About sidebar,
   identity check, license file, etc.

The Obsidian vault has the authoritative checklist with extra context and
*why* notes; this directory is the version that lives next to the actual
template files.
