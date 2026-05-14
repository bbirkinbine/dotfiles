# Repository context for Claude

This is a **public GitHub repository** (`github.com/bbirkinbine/dotfiles`). Treat every change as world-readable.

## Hard rules

- **No sensitive information.** Never commit (or suggest committing) secrets, API keys, tokens, private hostnames, internal IPs, personal email addresses, machine-specific paths that leak identity, work/employer details, or anything that wouldn't be safe on the open internet. If you spot something that looks sensitive in a diff, flag it before staging.
- **No co-author attribution in commits.** Do not append `Co-Authored-By: Claude ...` (or any other co-author trailer) to commit messages. Plain commit messages only.
- **No "Generated with Claude Code" footers** in commits or PR descriptions.
- **AI assistance is acknowledged once**, at the top level of `README.md`. Don't sprinkle AI-assist notices into individual files, commit messages, or comments.

## Scope

Personal shell/dev-environment dotfiles (`.zshrc`, `.zprofile`, `.gitconfig`, `.gitignore_global`, etc.). Anything machine-specific that shouldn't be shared belongs in a local untracked override, not in this repo.

## Before committing

Quick sanity pass on any diff:
1. No absolute paths that reveal identity beyond what's already public in git history.
2. No tokens, keys, or credentials — even commented-out ones.
3. No work-related aliases, hostnames, or context.
4. Commit message is plain — no trailers, no AI attribution.
