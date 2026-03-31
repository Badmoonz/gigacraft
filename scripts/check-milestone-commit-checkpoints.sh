#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"

assert_contains() {
  local file="$1"
  local needle="$2"

  if ! rg -Fq "$needle" "$file"; then
    printf 'Missing required text in %s:\n%s\n' "$file" "$needle" >&2
    exit 1
  fi
}

assert_contains "skills/writing-plans/SKILL.md" "Each milestone must state its definition of done, validation gate, rollback boundary, stop/replan rule, and commit checkpoint."
assert_contains "skills/writing-plans/SKILL.md" "At milestone boundaries, say whether execution should create a git commit before moving on and what that commit should capture."

assert_contains "skills/executing-plans/SKILL.md" "When a milestone or phase is complete and its validation gate passes, create one non-interactive git commit before starting the next milestone."
assert_contains "skills/executing-plans/SKILL.md" "If the worktree contains unrelated changes, missing validation, or no meaningful diff for the completed milestone, stop and surface that instead of forcing a commit."

assert_contains "skills/subagent-driven-development/SKILL.md" "When a milestone or phase is complete, reviewed, and validated, create one non-interactive git commit before dispatching work for the next milestone."
assert_contains "skills/subagent-driven-development/SKILL.md" "If the worktree contains unrelated changes, missing validation, or no meaningful diff for the completed milestone, stop and surface that instead of forcing a commit."

printf 'Milestone commit checkpoint checks passed.\n'
