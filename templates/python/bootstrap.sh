#!/usr/bin/env bash
# Bootstrap a Python project with the agentic-workflow scaffolding from
# Brian's dotfiles. Run from the new project's root.
#
# Usage:
#   cd ~/Downloads/src/new-project
#   bash ~/Downloads/src/dotfiles/templates/python/bootstrap.sh
#
# What it does:
#   - Copies CLAUDE.md, AGENTS.md, pyproject.toml, .pre-commit-config.yaml
#     into the current directory (verbatim, with {{PLACEHOLDER}} slots).
#   - Copies the .claude/ tree: settings.json + the three default subagents
#     (planner / test-first / reviewer) + the python-module-split skill.
#   - Copies docs/specs/README.md so the specs convention is documented.
#   - Does NOT copy bootstrap.sh, README.md (this directory's index),
#     subdir-CLAUDE.md.example (copied manually into each src/<area>/),
#     or anything under .claude/agents/optional/ (opt-in subagents that
#     each project enables per-need — see Done message at the end).
#   - Will NOT overwrite existing files; prints a warning and skips each one.
#
# After running:
#   1. Walk the {{PLACEHOLDER}} slots in CLAUDE.md, AGENTS.md, pyproject.toml.
#      Verify with: rg '\{\{' .
#   2. Walk the rest of ~/Downloads/src/dotfiles/templates/new-project-checklist.md
#      for the README.md acknowledgement, GitHub About sidebar, and identity check.
#   3. uv sync && uv run pre-commit install

set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DST_DIR="$(pwd)"

if [[ "$SRC_DIR" == "$DST_DIR" ]]; then
  echo "ERROR: refusing to bootstrap into the dotfiles template directory itself."
  echo "       cd into the new project's root before running this script."
  exit 1
fi

echo "Bootstrapping Python agentic-workflow scaffolding"
echo "  from: $SRC_DIR"
echo "  into: $DST_DIR"
echo

# Files and directories to copy. Bootstrap.sh and the README/example are excluded.
copy() {
  local rel="$1"
  local src="$SRC_DIR/$rel"
  local dst="$DST_DIR/$rel"
  if [[ -e "$dst" ]]; then
    echo "  skip (exists): $rel"
    return
  fi
  mkdir -p "$(dirname "$dst")"
  if [[ -d "$src" ]]; then
    cp -R "$src" "$dst"
  else
    cp "$src" "$dst"
  fi
  echo "  copied: $rel"
}

copy CLAUDE.md
copy AGENTS.md
copy pyproject.toml
copy .pre-commit-config.yaml
copy .claude/settings.json
copy .claude/agents/planner.md
copy .claude/agents/test-first.md
copy .claude/agents/reviewer.md
copy .claude/skills/python-module-split/SKILL.md
copy docs/specs/README.md

# Intentionally NOT copied (opt-in per project):
#   .claude/agents/optional/security-reviewer.md  — copy manually when the
#   project has a network surface, auth, or processes untrusted input.
#   See $SRC_DIR/.claude/agents/optional/ for what's available.

echo
echo "Done. Next steps:"
echo "  1. Replace placeholders:  rg '\\{\\{' . | head"
echo "  2. Walk the rest of the new-project checklist:"
echo "     ~/Downloads/src/dotfiles/templates/new-project-checklist.md"
echo "  3. Install dev environment:"
echo "     uv sync && uv run pre-commit install"
echo "  4. Write your first spec:  docs/specs/0001-<feature>.md"
echo "  5. For per-subdir CLAUDE.md files:"
echo "     cp $SRC_DIR/subdir-CLAUDE.md.example src/<area>/CLAUDE.md"
echo "  6. If this project has a network surface, auth, or processes"
echo "     untrusted input, add the opt-in security-reviewer:"
echo "     cp $SRC_DIR/.claude/agents/optional/security-reviewer.md \\"
echo "        .claude/agents/security-reviewer.md"
