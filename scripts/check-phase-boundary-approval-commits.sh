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

assert_contains "skills/brainstorming/SKILL.md" 'After explicit approval, if the approved spec artifact still has an uncommitted diff, create one non-interactive git commit that stages only the approved spec artifact before moving to `writing-plans`.'
assert_contains "skills/brainstorming/SKILL.md" 'If the worktree contains unrelated changes or there is no meaningful diff for the approved spec artifact, stop and surface that instead of forcing a boundary commit.'

assert_contains "skills/writing-plans/SKILL.md" 'After explicit user approval, if the approved plan artifact set still has an uncommitted diff, create one non-interactive git commit that stages only the main plan and any companion plan-pack files before offering execution.'
assert_contains "skills/writing-plans/SKILL.md" 'If the worktree contains unrelated changes or there is no meaningful diff for the approved plan artifact set, stop and surface that instead of forcing a boundary commit.'

assert_contains "skills/using-gigacraft/SKILL.md" 'Use `writing-plans` when there is an approved written spec and the next job is implementation planning; before leaving `brainstorming`, commit the approved spec artifact if it changed.'
assert_contains "skills/using-gigacraft/SKILL.md" 'Use `subagent-driven-development` or `executing-plans` only after a written implementation plan or plan pack has been reviewed, explicitly approved by the user, and boundary-committed if it changed.'
assert_contains "skills/using-gigacraft/SKILL.md" '1. Brainstorm, review, approve, and commit a written design.'
assert_contains "skills/using-gigacraft/SKILL.md" '2. Turn the committed design into a detailed implementation plan or plan pack, get user approval on the written artifacts, and commit them.'

printf 'Phase-boundary approval commit checks passed.\n'
