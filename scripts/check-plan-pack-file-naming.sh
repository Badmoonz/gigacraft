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

assert_contains "skills/writing-plans/SKILL.md" 'Do not append suffixes such as `-implementation`, `-plan`, `-design`, `-spec`, `-status`, or `-test-plan` to `<topic>`.'
assert_contains "skills/writing-plans/SKILL.md" 'When companions exist, every file in the plan pack must share the exact same base name: `YYYY-MM-DD-<topic>.md`, `YYYY-MM-DD-<topic>-status.md`, and `YYYY-MM-DD-<topic>-test-plan.md`.'
assert_contains "skills/writing-plans/SKILL.md" 'If the main plan is `docs/gigacraft/plans/YYYY-MM-DD-<topic>.md`, the companions must be exactly `docs/gigacraft/plans/YYYY-MM-DD-<topic>-status.md` and `docs/gigacraft/plans/YYYY-MM-DD-<topic>-test-plan.md`.'
assert_contains "skills/writing-plans/SKILL.md" 'Do not mix bases inside one plan pack, for example `...-implementation.md` with `...-test-plan.md`.'
assert_contains "skills/writing-plans/SKILL.md" 'Reject the plan if the main plan path bakes artifact-type suffixes into `<topic>`, or if the main plan, status companion, and test-plan companion do not share one exact base name.'

assert_contains "agents/planner.md" 'Do not append suffixes such as `-implementation`, `-plan`, `-design`, `-spec`, `-status`, or `-test-plan` to the main plan base name.'
assert_contains "agents/planner.md" 'When companions exist, keep one exact shared base name across the full pack: `.../<date>-<topic>.md`, `.../<date>-<topic>-status.md`, and `.../<date>-<topic>-test-plan.md`.'
assert_contains "agents/planner.md" 'Do not mix bases inside one pack, for example a main plan ending in `-implementation.md` with companions derived from a different base.'
assert_contains "agents/planner.md" 'If the main plan path, status companion path, and test-plan companion path do not share one exact base name, the plan pack is malformed.'

printf 'Plan-pack file naming checks passed.\n'
