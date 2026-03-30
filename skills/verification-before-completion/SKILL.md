---
name: verification-before-completion
description: Use before claiming work is complete, fixed, or ready; require fresh verification evidence from the current workspace state before making success claims.
---

# Verification Before Completion

## Goal

Prevent false completion claims by requiring fresh verification evidence before saying work is complete, fixed, passing, or ready for handoff.

## Iron Law

No completion claim without fresh verification evidence.

If you did not run the relevant check against the current workspace state, do not claim success.

## Verification Gate

Before any success claim:

1. Identify the exact claim you are about to make.
2. Identify the narrowest command or check that can prove that claim.
3. Run that check now.
4. Read the actual output and exit status instead of assuming the result.
5. Report the result with evidence.
6. If the check could not run, say that explicitly and report the remaining risk instead of claiming completion.

## Evidence By Claim

| Claim | Required evidence | Not sufficient |
|-------|-------------------|----------------|
| Tests pass | Exact test command with passing result and no relevant failures | Older run, partial test subset, "should pass" |
| Build succeeds | Build or typecheck command exits cleanly | Lint passing, code looking correct |
| Linter is clean | Lint command shows no blocking errors | Build passing, manual inspection |
| Bug is fixed | Reproduce the original failing path and verify it no longer fails | Code change only, guessed reasoning |
| Requirements are met | Compare the result against the spec, plan, or checklist and call out any gaps | Tests alone |
| Subagent work is done | Inspect the produced changes and run independent verification | Trusting the subagent report |

## Red Flags

- "should", "probably", "seems", or similar hedging used as a substitute for verification
- Partial verification presented as full verification
- Relying on stale output from before the latest changes
- Moving to commit, PR, handoff, or next task without rerunning relevant checks
- Trusting agent or subagent success reports without independent validation

## Rules

- Prefer the narrowest useful verification first, then expand only if task risk justifies it.
- When you make a success claim, include the exact check you ran and the key result.
- If verification fails, report the failure plainly and stop claiming completion.
- If verification cannot run, say what blocked it and what risk remains.
- Missing verification means incomplete work, not implied success.
- For delegated work, verify independently before reporting status upward.
- For specs, plans, or docs, verify the artifact exists at the intended path and that any required review gate actually happened before claiming completion.
