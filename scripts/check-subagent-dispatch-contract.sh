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

assert_contains "skills/subagent-driven-development/SKILL.md" 'Do not merely say you are delegating. The skill is not active until an `implementer` subagent has actually been dispatched for the current task.'
assert_contains "skills/subagent-driven-development/SKILL.md" 'If this environment cannot dispatch subagents, stop, tell the user that `subagent-driven-development` cannot run here, and explicitly offer `executing-plans` as the fallback.'
assert_contains "skills/subagent-driven-development/SKILL.md" 'When dispatching `implementer`, use `skills/subagent-driven-development/implementer-dispatch.md` and send the template text with real values, not the file path.'
assert_contains "skills/subagent-driven-development/SKILL.md" 'When dispatching `code-reviewer`, use `skills/subagent-driven-development/code-reviewer-dispatch.md` and send the template text with real values, not the file path.'

assert_contains "skills/subagent-driven-development/implementer-dispatch.md" 'Task id:'
assert_contains "skills/subagent-driven-development/implementer-dispatch.md" 'Files you may edit:'
assert_contains "skills/subagent-driven-development/code-reviewer-dispatch.md" 'Implementation task id:'
assert_contains "skills/subagent-driven-development/code-reviewer-dispatch.md" 'Files to review:'

printf 'Subagent dispatch contract checks passed.\n'
