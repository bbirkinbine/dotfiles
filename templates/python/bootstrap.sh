#!/usr/bin/env bash
# Bootstrap a Python project with the agentic-workflow scaffolding from
# Brian's dotfiles. Run from the new project's root.
#
# Usage:
#   cd ~/Downloads/src/new-project
#   bash ~/Downloads/src/dotfiles/templates/python/bootstrap.sh
#
# What it does:
#   - Copies CLAUDE.md, WORKFLOW.md, AGENTS.md, pyproject.toml,
#     .pre-commit-config.yaml into the current directory (verbatim, with
#     {{PLACEHOLDER}} slots where applicable).
#   - Copies the .claude/ tree: settings.json + the default subagents
#     (planner / test-first / reviewer / reviewer-adversarial) + the
#     default skills (python-module-split / python-docstrings /
#     dependency-hygiene) + the default slash commands (spec,
#     specs-status, scope-check, plan, test-first, review-check, review,
#     review-adversarial, security, performance).
#   - Copies docs/specs/README.md so the specs convention is documented.
#   - Does NOT copy bootstrap.sh, README.md (this directory's index),
#     subdir-CLAUDE.md.example (copied manually into each src/<area>/),
#     or anything under .claude/agents/optional/ (opt-in subagents that
#     each project enables per-need — see Done message at the end).
#   - Will NOT overwrite existing files; prints a warning and skips each one.
#
# After running:
#   1. Walk the {{PLACEHOLDER}} slots in CLAUDE.md, pyproject.toml.
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
copy WORKFLOW.md
copy AGENTS.md
copy pyproject.toml
copy .pre-commit-config.yaml
copy .claude/settings.json
copy .claude/agents/planner.md
copy .claude/agents/test-first.md
copy .claude/agents/reviewer.md
copy .claude/agents/reviewer-adversarial.md
copy .claude/commands/spec.md
copy .claude/commands/specs-status.md
copy .claude/commands/scope-check.md
copy .claude/commands/plan.md
copy .claude/commands/test-first.md
copy .claude/commands/review-check.md
copy .claude/commands/review.md
copy .claude/commands/review-adversarial.md
copy .claude/commands/security.md
copy .claude/commands/performance.md
copy .claude/skills/python-module-split/SKILL.md
copy .claude/skills/python-docstrings/SKILL.md
copy .claude/skills/dependency-hygiene/SKILL.md
copy docs/specs/README.md

# Intentionally NOT copied (opt-in per project):
#   .claude/agents/optional/security-reviewer.md     — for projects with a network
#     surface, auth, untrusted input, secrets, or external deserialization.
#   .claude/agents/optional/performance-reviewer.md  — for projects with a hot path,
#     DB queries on user-sized data, async code, migrations on large tables, or any
#     latency SLO.
#   See $SRC_DIR/.claude/agents/optional/ for what's available.

echo
echo "Done. Next steps:"
echo "  0. Read WORKFLOW.md — the loop walkthrough with worked examples."
echo "  1. Replace placeholders:  rg '\\{\\{' . | head"
echo "  2. Walk the rest of the new-project checklist:"
echo "     ~/Downloads/src/dotfiles/templates/new-project-checklist.md"
echo "  3. Install dev environment:"
echo "     uv sync && uv run pre-commit install"
echo "  4. Write your first spec:  /spec <feature name>  (or by hand at docs/specs/0001-<feature>.md)"
echo "  5. For per-subdir CLAUDE.md files:"
echo "     cp $SRC_DIR/subdir-CLAUDE.md.example src/<area>/CLAUDE.md"
echo "  6. If this project has a network surface, auth, or processes"
echo "     untrusted input, add the opt-in security-reviewer:"
echo "     cp $SRC_DIR/.claude/agents/optional/security-reviewer.md \\"
echo "        .claude/agents/security-reviewer.md"
echo "  7. If this project has a hot path, async code, DB queries on"
echo "     user-sized data, or a latency SLO, add the opt-in"
echo "     performance-reviewer:"
echo "     cp $SRC_DIR/.claude/agents/optional/performance-reviewer.md \\"
echo "        .claude/agents/performance-reviewer.md"
echo
echo "Workflow loop (slash commands installed in .claude/commands/):"
echo "  /scope-check <desc>    OPTIONAL — five forcing questions before /spec"
echo "                         when goal/scope is ambiguous"
echo "  /spec <name>           create a spec under docs/specs/"
echo "  /specs-status [filter] print the status table for all specs"
echo "  /plan                  invoke the planner subagent on the latest spec"
echo "  /test-first            invoke the test-first subagent"
echo "  /review-check          run the local quality gate (ruff, format, mypy, pytest)"
echo "  /review                invoke the reviewer subagent on the current diff"
echo "  /review-adversarial    invoke reviewer-adversarial on the same diff;"
echo "                         pair with /review on meaningful features"
echo "  /security              invoke security-reviewer (if installed)"
echo "  /performance           invoke performance-reviewer (if installed)"
