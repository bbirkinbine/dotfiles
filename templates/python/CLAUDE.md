# Project: {{PROJECT_NAME}}

{{ONE_PARAGRAPH_DESCRIPTION}}

This repo is **public** on GitHub (`github.com/bbirkinbine/{{PROJECT_NAME}}`)
or will become public after the first feature lands. Treat every change
as world-readable from commit #1. See the "Secrets and public-repo
hygiene" section below.

An `AGENTS.md` stub sits alongside this file as a portable pointer for
non-Claude agents (Codex, Cursor, Gemini, etc.) that look for that
filename by convention. `CLAUDE.md` is the source of truth; `AGENTS.md`
points back here.

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
in my Obsidian vault. The human-facing walkthrough with worked examples
lives in `WORKFLOW.md` at the repo root. Honor each phase — don't run
open-ended.

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
- **Verify.** Before invoking the `reviewer` subagent, run
  `/review-check` to confirm the local quality gate passes (ruff lint,
  ruff format, mypy, pytest). Then use the `reviewer` subagent on the
  diff. It has not seen the implementation reasoning and reads only the
  diff + spec. For meaningful features, also run `/review-adversarial`
  on the same diff and read both side-by-side. Add `/security` and/or
  `/performance` if the relevant opt-in subagent is installed and the
  diff trips its triggers.
- **Phase handoff on multi-day features.** If the loop spans more than
  one session, append a `## Phase handoff` section to the spec at each
  phase boundary (state + entry conditions for the next phase), then
  run `/clear` and resume in a fresh session. Main-session context past
  the U-curve degrades review quality; the handoff section is how the
  fresh session picks up without re-deriving context from the chat.
- If a change would touch > 5 files, stop and ask first.

## Subagents (in `.claude/agents/`)

- `planner` — read-only; produces a plan in markdown.
- `test-first` — writes failing pytest tests from a spec; never writes
  implementation.
- `reviewer` — independent diff reviewer; checks spec match, test
  quality, edge cases, file size, public-repo hygiene.
- `reviewer-adversarial` — independent diff reviewer with adversarial
  framing; argues against the change rather than for it. Use alongside
  `reviewer` on meaningful features for A/B comparison. Same section
  structure as `reviewer` so both can be read side-by-side.

Opt-in subagents (copy from
`~/Downloads/src/dotfiles/templates/python/.claude/agents/optional/`
into `.claude/agents/` per project):

- `security-reviewer` — application-security review of a diff. Enable
  when the project has a network surface, auth, processes untrusted
  input, handles secrets, or deserializes external data.
- `performance-reviewer` — performance review of a diff (N+1, accidental
  O(n²), sync I/O in async, missing pagination, allocation churn,
  migration-locking patterns). Enable when the project has a hot path,
  DB queries on user-sized data, or runs under load.

## Skills (in `.claude/skills/`)

- `python-module-split` — auto-invoked when a `.py` file approaches 300
  lines. Splits a module into a package while preserving the public API.
- `python-docstrings` — auto-invoked when a new public function, class,
  or module is added or touched. Enforces Google-style docstrings; bans
  tautological docs and missing `Raises:` sections.
- `dependency-hygiene` — auto-invoked when a new entry is added to
  `[project] dependencies` or `[tool.uv] dev-dependencies` in
  `pyproject.toml`. Flags abandoned packages, single-maintainer risk,
  license conflicts, stdlib alternatives, and advisories before the
  dep is added.

## Slash commands (in `.claude/commands/`)

One-keystroke entry points to the workflow loop. The commands invoke
the subagents and quality gate so the methodology is muscle memory
instead of manual invocation.

- `/scope-check <feature description>` — optional pre-spec phase. Five
  forcing questions to clarify goal and scope on ambiguous features.
  Output feeds the spec's `## Goal` and `## Non-goals` sections. Skip
  on features where the goal is already concrete.
- `/spec <feature name>` — creates `docs/specs/NNNN-<slug>.md` with
  status header + goal / success / non-goals scaffolding; stops there
  for human edit.
- `/specs-status [filter]` — prints the status table for every spec
  under `docs/specs/` (draft / shipping / shipped / paused / abandoned).
  Read-only aggregator over the `**Status:**` field in each spec.
- `/plan [spec-path]` — invokes the `planner` subagent on the named
  spec, or the most recent one if blank.
- `/test-first [spec-path]` — invokes the `test-first` subagent.
- `/review [<base>..<head>]` — invokes the `reviewer` subagent on the
  current diff (or the named range).
- `/review-adversarial [<base>..<head>]` — invokes the
  `reviewer-adversarial` subagent on the same diff. Pair with `/review`
  on meaningful features for A/B comparison; same output schema.
- `/security [<base>..<head>]` — invokes `security-reviewer` if
  installed; otherwise tells you how to enable it.
- `/performance [<base>..<head>]` — invokes `performance-reviewer` if
  installed; otherwise tells you how to enable it.
- `/review-check` — runs the local quality gate (ruff lint, ruff
  format, mypy, pytest) and refuses to declare the gate passed on any
  failure. Run before `/review`. Does not mean "feature done" — only
  "local checks pass."

## Hooks

`.claude/settings.json` runs `ruff format`, `ruff check`, and `mypy`
after every `Edit`/`Write` via a PostToolUse hook. Fix lint/type errors
immediately rather than declaring victory with a broken build.

The full local gate (lint + format + types + tests) is gated behind the
explicit `/review-check` slash command, not the auto-hook — tests are
too slow to run on every edit but they're non-optional before invoking
`/review`.

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
