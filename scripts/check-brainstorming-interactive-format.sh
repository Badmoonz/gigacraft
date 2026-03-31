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

assert_contains "skills/brainstorming/SKILL.md" 'Emit the actual `AskUserQuestion` message as raw plain text, not inside a markdown code fence.'
assert_contains "skills/brainstorming/SKILL.md" 'Do not put any prose, bullets, headings, or commentary before `AskUserQuestion` in the actual assistant message.'
assert_contains "skills/brainstorming/SKILL.md" 'Emit the actual `ReviewOptions` message as raw plain text, not inside a markdown code fence.'
assert_contains "skills/brainstorming/SKILL.md" 'Do not put any prose, bullets, headings, or commentary before `ReviewOptions` in the actual assistant message.'

printf 'Brainstorming interactive format checks passed.\n'
