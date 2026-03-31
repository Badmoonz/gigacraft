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

assert_contains "skills/writing-plans/SKILL.md" 'If repository-navigation helper readiness is already known during planning, record that advisory note explicitly in the plan pack and tell execution to re-check it on activation.'
assert_contains "agents/planner.md" 'If repository-navigation helper readiness is already known during planning, record it as advisory context and tell execution to re-check it on activation.'
assert_contains "skills/executing-plans/SKILL.md" 'Before choosing repository-navigation commands, check whether `Serena` or `code-index` is ready in the current environment.'
assert_contains "skills/executing-plans/SKILL.md" 'If a repository-navigation helper is ready, record that decision and use it first for symbol lookup and file discovery before broad text-search fallback.'
assert_contains "skills/subagent-driven-development/SKILL.md" 'Before dispatching navigation-heavy work, check whether `Serena` or `code-index` is ready in the current environment.'
assert_contains "skills/subagent-driven-development/SKILL.md" 'If a repository-navigation helper is ready, record that decision, pass it to subagents, and use it first for symbol lookup and file discovery before broad text-search fallback.'
assert_contains "agents/implementer.md" 'If the dispatcher or status companion says `Serena` or `code-index` is ready, use it first for repository navigation and symbol lookup before broad grep-style fallback.'

printf 'Code-index readiness planning checks passed.\n'
