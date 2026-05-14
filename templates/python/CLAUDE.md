# Project: {{PROJECT_NAME}}

{{ONE_PARAGRAPH_DESCRIPTION}}

This repo is **public** on GitHub (`github.com/bbirkinbine/{{PROJECT_NAME}}`)
or will become public after the first feature lands. Treat every change
as world-readable from commit #1. See the "Secrets and public-repo
hygiene" section below.

## Stack

- Python 3.12 (managed by `uv`)
- {{ADD_PROJECT_SPECIFIC_LIBS — e.g., FastAPI / Pydantic v2 / SQLAlchemy 2.0 / httpx / lxml / structlog}}
- pytest + pytest-asyncio
- ruff (lint + format) + mypy (strict)

## How to run things

- Install: `uv sync`
- Run app: `uv run python -m {{PACKAGE_NAME}}.main` (or `uv run {{ENTRY_POINT}}`)
- Run tests: `uv run pytest`
- Lint: `uv run ruff check . && uv run ruff format --check .`
- Type-check: `uv run mypy src/`
- Single test: `uv run pytest path/to/test.py::test_name -xvs`

## Conventions

- **Files ≤ 300 lines.** Split aggressively; one concept per file. The
  `python-module-split` skill auto-invokes when a file approaches this.
- **Type hints required** on every function signature. `Any` requires a
  comment justifying it.
- **No bare `except:`**. Catch specific exceptions or `Exception` with a
  re-raise/log.
- **Docstrings:** Google-style. One-liner for trivial helpers; full
  args/returns/raises for public functions.
- **Imports:** absolute imports inside the package; relative only inside
  `__init__.py`.
- **Logging:** `structlog`, not `print` or `logging` directly. Get a
  logger via `log = structlog.get_logger()`.

## Workflow expectations (Spec → Plan → Test-first → Implement → Verify)

This is the agentic loop documented in
`Research/Programming/Agentic Programming/02 Agentic Methodology Loop.md`
in my Obsidian vault. Honor each phase — don't run open-ended.

- **Spec.** Before any non-trivial work, write a short spec under
  `docs/specs/NNNN-<feature>.md` (see `docs/specs/README.md` for the
  numbering convention). One paragraph minimum: goal, success criteria,
  non-goals.
- **Plan.** For tasks that touch > 3 files: use the `planner` subagent
  first. It reads the spec + relevant code and produces a markdown
  plan. Review the plan before any writes happen.
- **Test-first.** Tests come before implementation. Use the `test-first`
  subagent to write failing pytest tests from the spec. Show me the
  failing-test output. Only then proceed to implementation.
- **Implement.** Main session writes the minimum code to make the
  tests pass.
- **Verify.** Use the `reviewer` subagent on the diff before commit. It
  has not seen the implementation reasoning and reads only the diff +
  spec.
- If a change would touch > 5 files, stop and ask first.

## Subagents (in `.claude/agents/`)

- `planner` — read-only; produces a plan in markdown.
- `test-first` — writes failing pytest tests from a spec; never writes
  implementation.
- `reviewer` — independent diff reviewer; checks spec match, test
  quality, edge cases.

## Skills (in `.claude/skills/`)

- `python-module-split` — auto-invoked when a `.py` file approaches 300
  lines. Splits a module into a package while preserving the public API.

## Hooks

`.claude/settings.json` runs `ruff check` and `mypy` after every
`Edit`/`Write` via a PostToolUse hook. Fix lint/type errors immediately
rather than declaring victory with a broken build.

## Don't-touch list

- `pyproject.toml` `[tool.uv]` section — ask first
- {{ADD_PROJECT_SPECIFIC_DONT_TOUCH — e.g., `src/{{PACKAGE_NAME}}/migrations/` if Alembic; vendored upstream files under `sources/`; generated artifacts under `out/`}}

## Code / commit style

- **No `Co-Authored-By: Claude` (or any AI co-author) trailers** in
  commit messages. The top-level `README.md` already acknowledges AI
  tooling — that is the single source of attribution. This overrides
  Claude Code's default behavior.
- **No "Generated with Claude Code" footers** in commits or PR
  descriptions for the same reason.
- AI assistance is acknowledged **once**, at the top of `README.md`. Do
  not sprinkle AI-assist notices into individual files, commit
  messages, or comments.
- Match the existing log style: short imperative subject, body
  explaining the *why* when non-obvious. No conventional-commits
  prefixes (`feat:`, `fix:`, `chore:`) unless the existing log already
  uses them.
- Reference the spec under `docs/specs/` when applicable.
- Avoid emojis in repo files.
- Avoid the words *genuinely*, *straightforward*, *actually* in prose.
- Direct, technical tone.

## Secrets and public-repo hygiene

**Treat this repo as public from commit #1, even if it is currently (or
was recently) private.** Many of my repos start private and flip to
public after a feature lands. Rewriting history after that flip is
destructive — every commit SHA changes, existing clones break, and the
old state may already be archived by forks, GitHub's network view, or
anyone who cloned before the rewrite. The cheapest fix is to never
commit the thing in the first place.

The rules below apply across every public surface, not just file
contents:

- File contents and diffs
- Commit messages (subject + body) and tag annotations
- Branch names and tag names
- PR titles, descriptions, review comments
- Issue titles, bodies, comments; Discussions; wiki pages; release notes
- CI workflow logs (echoed env vars, full paths, stack traces are all
  public for public repos)
- Author + committer email on every commit — history is forever

**Never commit:**

- Live credentials of any kind — API tokens, passwords, private keys,
  signing keys, OAuth secrets, session cookies, JWTs. If one ever lands
  in a commit, **rotate it immediately**; assume any value that touched
  history is compromised the moment it lands.
- `.env*` files other than `.env.*.example` (which must contain no real
  values). Gitignore `.env.*` with an explicit `!.env.*.example`
  whitelist.
- Internal hostnames, IPs, subnets, internal URLs, VPN endpoints,
  private Slack/Discord links, IRC channels.
- Names of coworkers, managers, customers, or anyone else who hasn't
  opted in to having their name attached to this repo.
- Private-tracker identifiers — Linear/Jira/Asana ticket IDs, internal
  doc URLs, Notion share links.
- Employer references in commit messages, comments, or repo metadata.
- File paths that leak identity or employer.
- Personal info — home address, phone, personal email, ID numbers.

If the repo is currently private and a flip to public is on the table,
walk the pre-flip checklist in
`~/Downloads/src/dotfiles/templates/new-project-checklist.md` before
clicking "Change visibility."

## Open work / current state (updated {{YYYY-MM-DD}})

- {{WHAT_IS_IN_PROGRESS_OR_BLOCKED}}
- {{WHAT_THE_NEXT_SPEC_IS — e.g., "Spec for the next feature lives at `docs/specs/0001-<feature>.md`"}}
