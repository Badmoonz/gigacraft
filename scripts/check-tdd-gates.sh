#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"

assert_contains() {
  local file="$1"
  local needle="$2"

  if ! rg -Fq -- "$needle" "$file"; then
    printf 'Missing required text in %s:\n%s\n' "$file" "$needle" >&2
    exit 1
  fi
}

assert_contains "skills/writing-plans/SKILL.md" "For every behavior-changing task, require an explicit test-first cycle: RED test, verify RED, GREEN code, verify GREEN, then refactor when needed."
assert_contains "skills/writing-plans/SKILL.md" "Do not leave the executor to invent the RED/GREEN sequence on the fly."

assert_contains "skills/test-driven-development/SKILL.md" 'Load `skills/test-driven-development/testing-anti-patterns.md` when writing or changing tests, adding mocks, or considering test-only production helpers.'
assert_contains "skills/test-driven-development/testing-anti-patterns.md" "NEVER test mock behavior"

assert_contains "skills/executing-plans/SKILL.md" 'For behavior-changing tasks, invoke `gigacraft:test-driven-development` before changing production code.'
assert_contains "skills/executing-plans/SKILL.md" "Before editing production code for a behavior change, write or update the narrowest useful test first and verify it fails for the expected reason."
assert_contains "skills/executing-plans/SKILL.md" "Do not treat tests as a final cleanup pass after implementation."

assert_contains "skills/subagent-driven-development/SKILL.md" 'For behavior-changing tasks, require the implementer handoff to follow `gigacraft:test-driven-development`.'
assert_contains "skills/subagent-driven-development/SKILL.md" "For behavior-changing tasks, dispatch and review explicit RED/GREEN progress: failing test first, then minimal code, then passing test."
assert_contains "skills/subagent-driven-development/implementer-dispatch.md" '- for behavior changes, follow `gigacraft:test-driven-development`, use `skills/test-driven-development/testing-anti-patterns.md` when relevant, and report the failing test you observed before changing production code'
assert_contains "skills/subagent-driven-development/implementer-dispatch.md" "- for behavior changes, follow a strict RED -> GREEN -> REFACTOR cycle and report the failing test you observed before changing production code"

assert_contains "agents/planner.md" "For every behavior-changing step, require an explicit RED -> GREEN -> REFACTOR sequence with named tests or validation commands."
assert_contains "agents/implementer.md" "For behavior changes, write or update the narrowest useful test first, watch it fail for the expected reason, then write the minimal production code to pass."

assert_contains "context/testing-standards.md" "- Prefer test-first changes: write the narrowest useful failing test before production code, then make it pass with the smallest implementation."

printf 'TDD gate checks passed.\n'
