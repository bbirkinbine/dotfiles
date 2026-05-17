# Workflow — how to actually use this scaffolding

> Companion to `CLAUDE.md`. `CLAUDE.md` is the standing instructions the
> agent reads every turn — the rules. This file is the human-facing
> walkthrough — the loop, what each step is for, and where it goes wrong
> if you skip a checkpoint.

The scaffolding implements the agentic loop
`Spec → Plan → Test-first → Implement → Verify`. The slash commands and
subagents are checkpoints: the agent stops at each transition and surfaces
output rather than rolling forward. The human is the loop driver.

## Day zero (once per project)

```bash
mkdir ~/Downloads/src/myproj && cd ~/Downloads/src/myproj
git init
bash ~/Downloads/src/dotfiles/templates/python/bootstrap.sh
```

Then, in order:

1. **Walk placeholders.** `rg '\{\{' .` — fill in `CLAUDE.md` and
   `pyproject.toml`. A `CLAUDE.md` that still says `{{PROJECT_NAME}}`
   actively misleads the agent on every turn.
2. **Walk the new-project checklist.** See
   `~/Downloads/src/dotfiles/templates/new-project-checklist.md` — README
   AI acknowledgement line, GitHub About sidebar, identity check. The
   identity check is load-bearing: `git config user.email` is baked into
   the first commit forever, and a wrong value leaks once the repo flips
   public.
3. **Decide opt-in subagents up front, not retroactively.**
   - Network surface, auth, untrusted input, secrets, or external
     deserialization → copy `security-reviewer`.
   - Hot path, async, DB queries on user-sized data, or a latency SLO →
     copy `performance-reviewer`.
   - Add a one-line mention of each enabled subagent to the "Subagents"
     section of `CLAUDE.md` so the agent knows when to route to it.
4. **Install the dev environment.**
   ```bash
   uv sync
   uv run pre-commit install
   ```
   Verify the PostToolUse hook works by making a trivial edit; you should
   see `ruff format`, `ruff check`, and `mypy` run.

## Per-feature loop

Each step is a separate turn. The slash commands enforce that — every
subagent stops and surfaces output rather than continuing into the next
phase on its own. You decide whether to advance.

```
/spec add user authentication      # scaffolds docs/specs/NNNN-add-user-authentication.md
        ↓
[edit the spec]                    # goal, success criteria, non-goals;
                                   # one paragraph minimum
        ↓
/plan                              # planner subagent reads spec + codebase
        ↓
[review the plan]                  # files to touch, order, risks;
                                   # reviewable in < 5 minutes.
                                   # if the plan is wrong, fix the spec
                                   # or push back — don't proceed
        ↓
/test-first                        # writes failing pytest tests from the spec
        ↓
[confirm the failure mode]         # tests should fail with AttributeError /
                                   # NotImplementedError / AssertionError —
                                   # NOT ImportError on a typo. Wrong failure
                                   # mode = the test isn't pinning down behavior.
        ↓
[main session implements]          # CLAUDE.md tells it: minimum code to
                                   # pass tests, one concept per file,
                                   # ≤ 300 lines, type hints required
        ↓
/review-check                      # local gate: ruff lint + format + mypy + pytest;
                                   # refuses to pass on any failure
        ↓
/review                            # independent reviewer against spec + diff
   /security                       # if installed AND the diff trips a security trigger
   /performance                    # if installed AND the diff trips a performance trigger
        ↓
[commit, explicitly]               # CLAUDE.md forbids agent-initiated commits;
                                   # you write the commit message
```

## Where this goes wrong if you skip steps

- **Skipping the spec.** `/plan` becomes guess-the-feature; `/review`
  has no anchor to compare against. The reviewer's first check is "does
  the diff match the spec?" — with no spec, it can't run that check.
- **Skipping `test-first`.** You'll write the implementation first and
  then "tests" that match what you happened to build, not what the spec
  says. Tautological tests pass everything, including the bugs.
- **Running `/spec → /plan → /test-first → implement` in one shot
  without checkpoints.** The checkpoints exist so a wrong turn at the
  spec doesn't propagate through the plan and tests before you notice.
  Cost of catching it at the spec phase: edit a paragraph. Cost of
  catching it at review: redo the work.
- **Skipping `/review-check` before `/review`.** The reviewer's first
  action is `uv run pytest`; if tests fail, the review is wasted on
  broken code. Run the gate first.
- **Forgetting the opt-in subagent install.** `/security` and
  `/performance` print install instructions and stop if the subagent
  isn't in `.claude/agents/`. The check doesn't run. If you decided at
  day zero that the project warrants the opt-in, install it then —
  don't defer.

## When NOT to use the full loop

The scaffolding is sized for projects you intend to maintain. For a
throwaway one-off script (a `~/Downloads/scratch/` analysis, a
dead-by-Friday spike), the loop is overhead. Skip `bootstrap.sh`
entirely; just write the code. The judgment has to be honest about
which projects are which — most "throwaways" turn out not to be.

A reasonable middle path for small-but-real projects: bootstrap, write a
one-paragraph spec at `docs/specs/0001-<feature>.md`, skip `/plan` (the
codebase is too small to need it), use `/test-first` and `/review-check`,
skip `/review` if you're the only reviewer. Scale the loop to the work.

## Things that aren't obvious from the docs

- **`CLAUDE.md` is re-read every turn**, not just at session start. Edits
  to it take effect on the next prompt — use this to course-correct
  mid-feature ("add to don't-touch: `src/foo/legacy/`").
- **Subagents don't share memory with the main session.** That's the
  point — the reviewer hasn't seen the implementation reasoning, so it
  reads the code fresh. Don't try to "tell the reviewer" something via
  the main session; put it in the spec.
- **The PostToolUse hook can be loud.** If `ruff format` keeps fighting
  your editor, your editor is configured with different settings. Align
  them — `pyproject.toml` is the source of truth.
- **`docs/specs/` is permanent.** Specs aren't deleted after the feature
  ships — they're the project's design log. Future you, and `/review` on
  the next feature, will read them.
- **The opt-in subagents only invoke when you call them.** They are not
  auto-invoked even after you install them; the slash command is the
  trigger. Treat `/security` and `/performance` as a deliberate gate per
  PR, not a passive background check.

## Reference

- `CLAUDE.md` — the rules the agent follows every turn
- `docs/specs/README.md` — spec numbering + minimum shape
- `~/Downloads/src/dotfiles/templates/new-project-checklist.md` —
  pre-flight checklist for the day-zero setup
- Methodology background:
  `Research/Programming/Agentic Programming/02 Agentic Methodology Loop.md`
  in the Obsidian vault
