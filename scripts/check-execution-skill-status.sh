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

assert_contains "skills/executing-plans/SKILL.md" "Derive companion paths from the approved plan path before doing implementation work."
assert_contains "skills/executing-plans/SKILL.md" 'If `<plan base>-status.md` exists, read it before choosing the next task and treat it as the source of truth for resume state.'
assert_contains "skills/executing-plans/SKILL.md" "After each completed task or validation attempt, update the status companion immediately before moving on."

assert_contains "skills/subagent-driven-development/SKILL.md" "Derive companion paths from the approved plan path before dispatching any subagent."
assert_contains "skills/subagent-driven-development/SKILL.md" 'If `<plan base>-status.md` exists, read it before choosing the next task and treat it as the source of truth for resume state.'
assert_contains "skills/subagent-driven-development/SKILL.md" "After each completed task, review pass, or validation attempt, update the status companion immediately before dispatching the next task."

assert_contains "skills/writing-plans/SKILL.md" "Use the exact section headings below for the status companion so execution skills can resume deterministically:"
assert_contains "skills/writing-plans/SKILL.md" "## Execution Log"

printf 'Execution skill status companion checks passed.\n'
