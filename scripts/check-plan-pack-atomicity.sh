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

assert_contains "skills/writing-plans/SKILL.md" 'When `Ordered atomic tasks` spans multiple milestones or is meant for autonomous execution, do not use a bare numbered checklist.'
assert_contains "skills/writing-plans/SKILL.md" 'Use a repeated task block for each atomic task with this minimum shape:'
assert_contains "skills/writing-plans/SKILL.md" '### Task X.Y: <Short Title>'
assert_contains "skills/writing-plans/SKILL.md" '**Files:** `path/to/file`'
assert_contains "skills/writing-plans/SKILL.md" '**Outcome:** one independently verifiable result'
assert_contains "skills/writing-plans/SKILL.md" '**Prerequisite:** exact earlier task id, milestone, or `None`'
assert_contains "skills/writing-plans/SKILL.md" '**RED:** exact failing test or validation command and the expected failure signal'
assert_contains "skills/writing-plans/SKILL.md" '**GREEN:** smallest implementation change that should make the RED check pass'
assert_contains "skills/writing-plans/SKILL.md" '**Verification:** exact passing command or manual check'
assert_contains "skills/writing-plans/SKILL.md" 'Reject the plan if any multi-milestone or autonomous task omits `Files`, `Outcome`, `Prerequisite`, or `Verification`.'
assert_contains "skills/writing-plans/SKILL.md" 'Reject the plan if any behavior-changing task omits explicit `RED` and `GREEN` checks in the main implementation plan.'
assert_contains "skills/writing-plans/SKILL.md" 'Reject the plan if any milestone omits `Stop/Replan Rule`.'

assert_contains "agents/planner.md" 'For plans that span multiple milestones or are intended for autonomous execution, do not emit a bare numbered checklist under `Ordered atomic tasks`.'
assert_contains "agents/planner.md" 'Use a repeated task block with `Files`, `Outcome`, `Prerequisite`, `RED`, `GREEN`, and `Verification`.'
assert_contains "agents/planner.md" 'If a behavior-changing step lacks explicit RED and GREEN checks in the main implementation plan, the plan is incomplete.'

assert_contains "plans/0001-example-feature-plan.md" "## Milestones"
assert_contains "plans/0001-example-feature-plan.md" "### Task 1.1:"
assert_contains "plans/0001-example-feature-plan.md" "**Files:**"
assert_contains "plans/0001-example-feature-plan.md" "**RED:**"
assert_contains "plans/0001-example-feature-plan.md" "**GREEN:**"
assert_contains "plans/0001-example-feature-plan.md" "**Verification:**"
assert_contains "plans/0001-example-feature-plan.md" "**Stop/Replan Rule:**"

printf 'Plan-pack atomicity checks passed.\n'
