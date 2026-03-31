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

assert_contains "skills/brainstorming/SKILL.md" 'Do not mention `ReviewOptions`, `spec-reviewer`, `api-designer`, or `sre-skeptic` during requirements gathering or design-option discussion.'
assert_contains "skills/brainstorming/SKILL.md" 'Before the spec is written to disk, the only valid next-step language is about clarification, design options, approval, or writing the spec.'
assert_contains "skills/brainstorming/SKILL.md" 'Do not show `ReviewOptions`, draft reviewer prompts, or dispatch any review agent until the written spec artifact exists at its final path.'
assert_contains "skills/brainstorming/spec-reviewer-dispatch.md" "Never use this template before the spec exists on disk."
assert_contains "agents/spec-reviewer.md" "If the input describes an idea, requirements discussion, or unwritten design, stop and ask for the actual written spec path instead of reviewing."

printf 'Brainstorming review gate checks passed.\n'
