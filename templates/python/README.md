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
├── AGENTS.md                              # portable equivalent (other agents)
├── pyproject.toml                         # uv + ruff + mypy + pytest config
├── .pre-commit-config.yaml                # ruff + mypy on every commit
├── .claude/
│   ├── settings.json                      # PostToolUse hook: ruff + mypy
│   ├── agents/
│   │   ├── planner.md                     # Spec → markdown plan; read-only
│   │   ├── test-first.md                  # Write failing pytest tests; never implements
│   │   ├── reviewer.md                    # Independent diff reviewer (general)
│   │   └── optional/
│   │       └── security-reviewer.md       # App-sec review (opt-in, not auto-copied)
│   └── skills/
│       └── python-module-split/
│           └── SKILL.md                   # Auto-invoked when a .py file ≥ 300 lines
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

## The agentic loop this scaffolding enables

`Spec → Plan → Test-first → Implement → Verify`, where:

| Phase | Driven by |
|---|---|
| Spec | You write `docs/specs/NNNN-<feature>.md` |
| Plan | `planner` subagent (`.claude/agents/planner.md`) |
| Test-first | `test-first` subagent (`.claude/agents/test-first.md`) |
| Implement | Main Claude session (CLAUDE.md tells it the rules) |
| Quality gate | PostToolUse hook (`.claude/settings.json`) runs ruff + mypy on every Edit/Write |
| Verify | `reviewer` subagent (`.claude/agents/reviewer.md`) |

Auto-invoked side-skill: when a `.py` file approaches 300 lines, the
`python-module-split` skill fires.

`CLAUDE.md` is the glue — its "Workflow expectations" section tells
Claude to route to each subagent based on task size (> 3 files: planner;
tests first: test-first; before commit: reviewer; > 5 files: stop and
ask).

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
