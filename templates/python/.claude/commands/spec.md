---
description: Create a new spec at docs/specs/NNNN-<slug>.md with goal / success / non-goals scaffolding.
argument-hint: <feature name>
---

Create a new spec file under `docs/specs/`.

Procedure:

1. List existing files in `docs/specs/` (excluding `README.md`). Find the highest 4-digit prefix; the new file's prefix is that + 1, zero-padded.
2. Derive a slug from `$ARGUMENTS` (lowercase, hyphen-separated, no punctuation).
3. Title-case `$ARGUMENTS` for the H1.
4. Write the file at `docs/specs/NNNN-<slug>.md` using this skeleton:

```markdown
# <Title-cased feature name>

## Goal

<one paragraph: what we're building and why>

## Success criteria

- <observable, testable outcome>
- <observable, testable outcome>

## Non-goals

- <thing we are explicitly not doing>

## Notes

- <optional: known risks, dependencies, open questions>
```

Stop after writing the file. Do NOT proceed to planning or implementation. The human reviews and edits the spec before any other phase. Surface the path of the file you wrote.
