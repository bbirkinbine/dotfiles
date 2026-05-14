# AGENTS.md

> Project context for AI coding agents. See https://agents.md/ for the
> format. Brian's stack is Claude-first; this file is here for portability
> across other agents (Cursor, Codex, Aider) and as a symlink target if
> using `ln -sf AGENTS.md CLAUDE.md`. For the full Claude-specific rules
> (subagents, hooks, skills), see `CLAUDE.md`.

## Project

{{ONE_PARAGRAPH_DESCRIPTION}}

This repo is public on GitHub, or will become public after the first
feature lands. Treat every change as world-readable from commit #1.

## Setup

```bash
uv sync
uv run pytest    # smoke check
```

## Build / test / lint

| Task | Command |
|---|---|
| Test | `uv run pytest` |
| Lint | `uv run ruff check .` |
| Format | `uv run ruff format .` |
| Type-check | `uv run mypy src/` |

## Code style

- Python 3.12, type hints required
- Files ≤ 300 lines; one concept per file
- pytest fixtures, no setup/teardown methods
- Google-style docstrings
- structlog for logging, never `print`

## Workflow expectations

- Before implementation: write failing tests, show output, then implement.
- Stop and ask before touching `pyproject.toml [tool.uv]` or any
  vendored / generated files.
- If a change would touch > 5 files, propose a plan first.

## Commit policy

- No `Co-Authored-By:` trailers (AI or human) unless the named person
  has explicitly signed off. AI assistance is acknowledged once in
  `README.md`.
- No "Generated with Claude Code" footers.
- Treat the repo as public from commit #1. No secrets, no internal
  hostnames, no coworker/employer references, no private-tracker IDs.

## Don't touch

- {{ADD_PROJECT_SPECIFIC_DONT_TOUCH}}
- `pyproject.toml` `[tool.uv]` section
- Anything under `vendor/` or `_generated/`
