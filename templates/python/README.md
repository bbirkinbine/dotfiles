# Python agentic-workflow scaffolding

Drop-in scaffolding for new Python projects under `~/Downloads/src/`.
Mirrors the destination structure exactly — `bootstrap.sh` just `cp -r`s
the files into place.

This directory is the dotfiles mirror of the Obsidian source of truth
at `Research/Programming/Agentic Programming/starter-files/` in my
vault. Both should stay in sync; if a starter file evolves, update
both. The conventions and rationale behind each piece live at:

- `Research/Programming/Agentic Programming/00 Agentic Programming.md`
- `Research/Programming/Agentic Programming/02 Agentic Methodology Loop.md` (the loop diagram)
- `Research/Programming/Agentic Programming/04 MD Files for Coding Agents.md`

## What's in here

```
python/
├── README.md                              # this file (not copied to projects)
├── bootstrap.sh                           # the one-shot setup script
├── CLAUDE.md                              # project-root context for Claude Code
├── WORKFLOW.md                            # human-facing loop walkthrough (start here)
├── pyproject.toml                         # uv + ruff + mypy + pytest config
├── .pre-commit-config.yaml                # ruff + mypy on every commit
├── .claude/
│   ├── settings.json                      # PostToolUse hook: ruff + mypy
│   ├── agents/
│   │   ├── planner.md                     # Spec → markdown plan; read-only
│   │   ├── test-first.md                  # Write failing pytest tests; never implements
│   │   ├── reviewer.md                    # Independent diff reviewer (general)
│   │   └── optional/
│   │       ├── security-reviewer.md       # App-sec review (opt-in, not auto-copied)
│   │       └── performance-reviewer.md    # Perf review (opt-in, not auto-copied)
│   ├── commands/
│   │   ├── spec.md                        # /spec <name> — create docs/specs/NNNN-<slug>.md
│   │   ├── plan.md                        # /plan — invoke planner subagent
│   │   ├── test-first.md                  # /test-first — invoke test-first subagent
│   │   ├── review-check.md                # /review-check — local gate before /review
│   │   ├── review.md                      # /review — invoke reviewer subagent
│   │   ├── security.md                    # /security — invoke security-reviewer (if installed)
│   │   └── performance.md                 # /performance — invoke performance-reviewer (if installed)
│   └── skills/
│       ├── python-module-split/
│       │   └── SKILL.md                   # Auto-invoked when a .py file ≥ 300 lines
│       ├── python-docstrings/
│       │   └── SKILL.md                   # Auto-invoked on new public symbols
│       └── dependency-hygiene/
│           └── SKILL.md                   # Auto-invoked when pyproject.toml adds a dep
├── docs/specs/
│   └── README.md                          # Spec numbering + minimum shape
└── subdir-CLAUDE.md.example               # Per-area CLAUDE.md template
                                            # (copied manually, not by bootstrap)
```

## How to use

```bash
cd ~/Downloads/src/new-project
bash ~/Downloads/src/dotfiles/templates/python/bootstrap.sh
```

The script copies everything except this README, itself, and
`subdir-CLAUDE.md.example`. Existing files are skipped, not overwritten.

After bootstrap:

0. **Read [`WORKFLOW.md`](WORKFLOW.md)** — the human-facing loop
   walkthrough (day-zero setup, per-feature loop, where it goes wrong if
   you skip steps). Copied into every new project; this is the entry
   point for understanding the methodology.
1. Replace placeholders: `rg '\{\{' .`
2. Walk the rest of [`../new-project-checklist.md`](../new-project-checklist.md)
   — README acknowledgement, GitHub About sidebar, identity check.
3. `uv sync && uv run pre-commit install`
4. Write your first spec: `docs/specs/0001-<feature>.md`
5. For per-subdirectory rules: `cp subdir-CLAUDE.md.example src/<area>/CLAUDE.md`
   and edit heavily.
6. **If this project has a network surface, auth, or processes untrusted
   input** — add the opt-in security-reviewer:
   ```
   cp ~/Downloads/src/dotfiles/templates/python/.claude/agents/optional/security-reviewer.md \
      .claude/agents/security-reviewer.md
   ```
   See the [opt-in subagents](#opt-in-subagents) section below for what
   triggers a "yes" on this question.
7. **If this project has a hot path, async code, or runs under load** —
   add the opt-in performance-reviewer:
   ```
   cp ~/Downloads/src/dotfiles/templates/python/.claude/agents/optional/performance-reviewer.md \
      .claude/agents/performance-reviewer.md
   ```
   See the [opt-in subagents](#opt-in-subagents) section below for the
   trigger list.

## The agentic loop this scaffolding enables

`Spec → Plan → Test-first → Implement → Verify`, where:

| Phase | Driven by | Slash command |
|---|---|---|
| Spec | You write `docs/specs/NNNN-<feature>.md` | `/spec <name>` (scaffolds the file) |
| Plan | `planner` subagent (`.claude/agents/planner.md`) | `/plan [spec-path]` |
| Test-first | `test-first` subagent (`.claude/agents/test-first.md`) | `/test-first [spec-path]` |
| Implement | Main Claude session (CLAUDE.md tells it the rules) | — |
| Per-edit quality | PostToolUse hook (`.claude/settings.json`) runs ruff format + ruff check + mypy on every Edit/Write | — |
| Local quality gate (pre-review) | ruff lint + format + mypy + pytest, refuses pass on failure | `/review-check` |
| Verify | `reviewer` subagent (`.claude/agents/reviewer.md`) | `/review [<base>..<head>]` |
| Verify (security) | `security-reviewer` (opt-in subagent) | `/security [<base>..<head>]` |
| Verify (performance) | `performance-reviewer` (opt-in subagent) | `/performance [<base>..<head>]` |

Auto-invoked side-skills (load on demand based on what's happening in
the diff):

- `python-module-split` — fires when a `.py` file approaches 300 lines.
- `python-docstrings` — fires when a new public function, class, or
  module is added or touched without a compliant Google-style docstring.
- `dependency-hygiene` — fires when `pyproject.toml` adds a new dep;
  surfaces a check (maintenance, license, advisories, stdlib alternative)
  before the dep lands.

`CLAUDE.md` is the glue — its "Workflow expectations" section tells
Claude to route to each subagent based on task size (> 3 files: planner;
tests first: test-first; before commit: reviewer; > 5 files: stop and
ask). The slash commands above are the one-keystroke way to invoke each
phase explicitly when the agent doesn't auto-route.

## Opt-in subagents

`.claude/agents/optional/` holds subagents that are **not** copied by the
default bootstrap. Each is intended for projects where the cost of having
that subagent invoked routinely is worth it.

### `security-reviewer.md`

Application-security review of a diff. Distinct from the general
`reviewer` — focuses only on security-relevant findings (injection,
deserialization, auth/authz, crypto, path/file, SSRF, logging, secrets
in code). Output is structured like a pentest finding list (severity,
category, location, evidence, why-it-matters, suggested fix). Manual
review only — no `pip-audit` / `bandit` / `semgrep` shell-outs.

**Copy it in when the project has any of:**

- A network surface (HTTP server, MCP server with off-loopback bind,
  websocket, raw socket).
- Authentication or authorization logic.
- Processes untrusted input (user-supplied files, HTTP bodies,
  third-party API responses that pass through to internal use).
- Handles secrets — fetches, stores, rotates, or routes them.
- Deserializes external data (pickle, yaml, xml, jwt, custom binary).

To enable for a project:

```bash
cp ~/Downloads/src/dotfiles/templates/python/.claude/agents/optional/security-reviewer.md \
   .claude/agents/security-reviewer.md
```

Then add a one-line mention in your `CLAUDE.md` "Subagents" section so
Claude knows to invoke it before commits that touch a sensitive area.

### `performance-reviewer.md`

Performance review of a diff. Distinct from the general `reviewer` and
the `security-reviewer` — focuses only on perf-relevant findings (N+1
queries, accidental O(n²), sync I/O in async, missing pagination,
allocation churn, migration-locking patterns). Output is the same
Ghostwriter-style finding list. Recommends profiling commands (`py-spy`,
`scalene`, `pytest-benchmark`, `EXPLAIN ANALYZE`) per finding — the
human runs them.

**Copy it in when the project has any of:**

- A hot path (request handler, background worker that processes large
  batches, a CLI that runs over user-sized inputs).
- DB queries on tables that grow without bound, or any query in a loop.
- Async code (where sync I/O inside `async def` is a real footgun).
- Migrations against tables larger than a few thousand rows.
- Anything that runs under load or has a latency SLO.

To enable for a project:

```bash
cp ~/Downloads/src/dotfiles/templates/python/.claude/agents/optional/performance-reviewer.md \
   .claude/agents/performance-reviewer.md
```

Then add a one-line mention in your `CLAUDE.md` "Subagents" section.

## Don't

- Don't keep `{{PLACEHOLDER}}` strings in a committed file. A `CLAUDE.md`
  that still says `Project: {{PROJECT_NAME}}` is worse than no CLAUDE.md.
- Don't blanket-copy `subdir-CLAUDE.md.example` into every directory —
  use it where per-area conventions differ from the root.
- Don't paste these templates into a chat and ask Claude to "regenerate
  them for my project." Hand-edit. LLM-generated context files have been
  measured to *reduce* agent performance (Gloaguen et al., 2026) — see
  the rationale in
  `Research/Programming/Agentic Programming/04 MD Files for Coding Agents.md`.
