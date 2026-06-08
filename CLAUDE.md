# CLAUDE.md — dotfiles

> **Purpose.** Persistent project context for Claude Code (and other AI
> coding agents) working in this repository. Read this before suggesting
> changes. `README.md` is for humans landing on the GitHub page; this file
> is for the agent that opens the repo and starts working.

---

## What this repo is

Personal shell and development-environment dotfiles for macOS — `.zshrc`,
`.zprofile`, `.gitconfig`, `.gitignore_global` — plus a `templates/`
directory of reusable boilerplate (`CLAUDE.md`, `README.md`, GitHub About
checklist, new-project checklist) used when bootstrapping new repos under
`~/Downloads/src/`.

This repo is **public** on GitHub (`github.com/bbirkinbine/dotfiles`) as
of 2026-06-08 — it was private from 2026-06-05 until then, and public
before that. Treat it as world-readable: the public-repo hygiene rules
below are the default posture, not defense-in-depth. Machine-specific
config that only makes sense on one host — homelab node names
(`NODES`), the KeePass/YubiKey vars — lives in an untracked override
(`~/.zshrc.local`) that `.zshrc` sources at runtime; it is never
committed here. Live secret **values** likewise live only in `~/.env`
(outside this repo); `.zshrc` may *reference* those local files but
never contains their values. See "Secrets and public-repo hygiene"
below.

---

## Stack / scope

zsh + git on macOS (Apple Silicon, Homebrew). No build, no test suite, no
deploy target — files here are consumed in place by the shell and by git.
The `templates/` directory is the project-bootstrap surface; changes
there propagate (by copy) to every new repo created from this machine, so
treat edits in `templates/` as standards-setting rather than ad-hoc.

**Out of scope:** machine-specific config (anything that wouldn't be safe
on the open internet, anything that only makes sense on one host),
application configs that maintain their own versioning under
`~/.config/<tool>/`, and work-related aliases, hostnames, or shortcuts.
Anything machine-specific belongs in a local untracked override, not
here.

---

## Commits and pushes require explicit approval

Don't run `git commit` or `git push` without an explicit "commit" or
"push" instruction from the user in this conversation. Phrases like
"looks good," "the diff is clean," or "ready to ship" are **not**
approval — they're acknowledgement that the change is correct, not
permission to write history.

The workflow is: make the change, show `git status` and `git diff`,
then wait. Each commit needs its own sign-off; prior approval applies
to *that* commit, not to follow-up commits in the same session.

Pushes are gated more tightly than commits:

- Never push without being explicitly asked.
- Never push to `main` (or any protected branch) on the strength of an
  ambiguous "push it" — confirm the target branch first.
- Never use `--force` or `--force-with-lease` without a direct ask.

---

## Code / commit style

- **No `Co-Authored-By: Claude` (or any AI co-author) trailers** in commit
  messages. The top-level `README.md` already acknowledges AI tooling —
  that is the single source of attribution. This overrides Claude Code's
  default behavior.
- **No "Generated with Claude Code" footers** in commits or PR
  descriptions for the same reason.
- AI assistance is acknowledged **once**, at the top of `README.md`. Do
  not sprinkle AI-assist notices into individual files, commit messages,
  or comments.
- Match the existing log style: short imperative subject, body explaining
  the *why* when non-obvious. No conventional-commits prefixes
  (`feat:`, `fix:`, `chore:`) unless the existing log already uses them.
- Avoid emojis in repo files.
- Avoid the words *genuinely*, *straightforward*, *actually* in prose.
- Direct, technical tone.

---

## Secrets and public-repo hygiene

**Treat this repo as public from commit #1, even if it is currently (or
was recently) private.** Many of my repos start private and flip to
public after a feature lands. Rewriting history after that flip is
destructive — every commit SHA changes, existing clones break, and the
old state may already be archived by forks, GitHub's network view, or
anyone who cloned before the rewrite. The cheapest fix is to never commit
the thing in the first place.

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
  values). Gitignore `.env.*` with an explicit `!.env.*.example` whitelist.
- Internal hostnames, IPs, subnets, internal URLs, VPN endpoints,
  private Slack/Discord links, IRC channels.
- Names of coworkers, managers, customers, or anyone else who hasn't
  opted in to having their name attached to this repo. "Alice asked me
  to fix this" → "fix the foo bug."
- Private-tracker identifiers — Linear/Jira/Asana ticket IDs, internal
  doc URLs, Notion share links. They look anonymous but reveal both the
  tool in use and the existence/structure of internal work.
- Employer references in commit messages, comments, or repo metadata,
  unless the work was deliberately published with the employer's
  awareness.
- File paths that leak identity or employer —
  `/Users/firstname.lastname/Work/<EmployerName>/...`. Use `~/` or
  relative paths in docs; sanitize screenshots that show file pickers,
  terminal prompts, or editor title bars before pasting into PRs.
- Personal info — home address, phone, personal email, ID numbers.

**Things that quietly slip through:**

- `Co-Authored-By:` trailers naming real people. If a private-phase
  commit attaches a coworker's email as a co-author, flipping public
  exposes that forever. Treat the no-AI-coauthor rule from the §Code /
  commit style section as part of the same hygiene: no co-author
  trailers, period, unless the named person has explicitly signed off.
- Author email on early commits. If a clone on a different machine had
  the wrong global `user.email`, every commit before the fix carries
  it. Verify before the first commit — see
  [`templates/new-project-checklist.md`](templates/new-project-checklist.md).
- CI logs. Echoed env vars, full filesystem paths, and stack traces are
  all visible to anyone the moment the repo is public.
- Screenshots embedded in PRs or `docs/`. Crop or blur anything showing
  real data, real hostnames, or filesystem layout.

The pre-flip checklist in
[`templates/new-project-checklist.md`](templates/new-project-checklist.md)
applies here too — pre-flip scrubbing is cheap; post-flip scrubbing is
expensive and incomplete.

---

## Validation gates before claiming done

No build or test cycle. Sanity checks for any change:

```bash
zsh -n .zshrc                          # syntax check
zsh -n .zprofile                       # syntax check
git config --file .gitconfig --list    # confirms .gitconfig parses
```

Don't claim a change is "ready" without at least:

1. A clean run of the checks above for the affected file(s).
2. An updated `README.md` if the change affects how the repo is used or
   what it contains (e.g., a new top-level file or a new section).

---

## Don't touch

- `.git/` — obviously.
- Files in `templates/` are standards-setting: a change there propagates
  to every new repo bootstrapped from this machine. Edit deliberately
  and explain the rationale in the commit message; don't tweak template
  language casually.

---

## Open work / current state (updated 2026-05-21)

In-flight, not stable. The shell/git dotfiles see occasional tweaks
(new tool on `PATH`, alias change); `templates/` is the more active
surface as the project-bootstrap pattern evolves.
