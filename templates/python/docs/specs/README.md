# Specs

Short design docs for non-trivial features. Read these before implementing
or reviewing.

## Numbering

`NNNN-<kebab-name>.md`, zero-padded to four digits. New specs increment
the highest existing number. Once a number is assigned it doesn't change,
even if the spec is later superseded.

## Status header convention

Top of every spec:

```markdown
# NNNN — <Title>

**Status:** draft | shipping | shipped | superseded-by-NNNN
**Last updated:** YYYY-MM-DD
```

## Minimum spec shape

A spec doesn't need to be long. The minimum is:

```markdown
# NNNN — <Title>

**Status:** draft
**Last updated:** YYYY-MM-DD

## Goal

<One paragraph: what we're building and why.>

## Success criteria

- <Verifiable, behavior-level. Not "code is clean", but "GET /foo returns 200 with {bar} when X.">

## Non-goals

- <Things we're explicitly NOT doing in this spec. Prevents scope creep at plan time.>

## Sketch

<Optional: a few sentences on the approach. The planner subagent
expands this into a file-by-file plan; you don't need to pre-resolve
implementation details here.>
```

For larger features, add: dependencies, schema changes, migration plan,
test strategy, open questions. Keep it reviewable in < 10 minutes.

## How specs interact with the agentic loop

From `Research/Programming/Agentic Programming/02 Agentic Methodology Loop.md`:

1. **You write the spec.** ~5 minutes. One paragraph minimum.
2. **`planner` subagent reads the spec** + relevant code, produces a markdown plan with files-to-touch and ordering.
3. **`test-first` subagent reads the spec** + the plan, writes failing pytest tests.
4. Main session implements the minimum code to pass the tests.
5. **`reviewer` subagent reads the spec + the diff**, produces review notes before commit.

The spec is the artifact every other phase refers back to. If it changes
mid-flight, update the file before continuing — don't carry an updated
intent only in the chat session.
