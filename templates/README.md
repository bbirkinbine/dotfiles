# Project templates

Reusable boilerplate for new repositories under `~/Downloads/src/`. Two
flavors depending on whether the new repo is a Python project (and
should use the full agentic-workflow scaffolding) or something else
(infra, FPGA, shell, etc.) that just needs the basic conventions.

## Two flavors

### Python projects — use [`python/`](python/)

The full agentic-workflow scaffolding: CLAUDE.md with the
Spec → Plan → Test-first → Implement → Verify loop wired up, the three
subagents (planner, test-first, reviewer), the python-module-split
skill, the PostToolUse hook (ruff + mypy), pyproject.toml, pre-commit,
and a docs/specs/ convention.

Run [`python/bootstrap.sh`](python/bootstrap.sh) from a new repo's
root and everything drops into place.

See [`python/README.md`](python/README.md) for the full inventory and
the agentic-loop mapping.

### Non-Python repos — use the top-level templates

- [`CLAUDE.md.template`](CLAUDE.md.template) — generic project context
  for Claude Code (and any other AI coding agent). No Python
  assumptions; fill in the stack section per repo. Includes the
  no-co-author rule and the strengthened public-repo hygiene section
  (treat-as-public-from-commit-#1).
- [`README.md.template`](README.md.template) — human-facing GitHub
  landing page with Status block and AI-tools Acknowledgements.
- [`github-about.md`](github-about.md) — checklist for the GitHub repo's
  "About" sidebar (description, website, topics — specifically the
  `ai-assisted` tag).

### Both flavors use [`new-project-checklist.md`](new-project-checklist.md)

The authoritative step-by-step for any new repo — identity check,
GitHub About sidebar, first-commit hygiene, and the pre-flip
private→public checklist. This mirrors the Obsidian source at
`Research/Programming/New Project Setup.md` in my vault.

## How to use

**For a Python project:**

```bash
cd ~/Downloads/src/new-project
bash ~/Downloads/src/dotfiles/templates/python/bootstrap.sh
# then walk the rest of new-project-checklist.md
```

**For a non-Python repo:**

```bash
cd ~/Downloads/src/new-project
cp ~/Downloads/src/dotfiles/templates/CLAUDE.md.template  ./CLAUDE.md
cp ~/Downloads/src/dotfiles/templates/README.md.template  ./README.md
# Replace every {{...}} placeholder:  rg '{{' .
# then walk the rest of new-project-checklist.md
```

The Obsidian vault has the authoritative checklist with extra context
and *why* notes; this directory is the version that lives next to the
actual template files so the dotfiles repo stands alone on machines
without the vault.
