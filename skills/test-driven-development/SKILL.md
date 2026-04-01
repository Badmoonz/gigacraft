---
name: test-driven-development
description: Use as an execution overlay for behavior-changing work; enforce RED -> GREEN -> REFACTOR before any production-code edit.
---

# Test-Driven Development

## Goal

Make each behavior change through the smallest observable RED -> GREEN -> REFACTOR cycle.

## Process

1. Isolate one behavior unit from the current approved task.
2. Write or update the narrowest useful test for that behavior before changing production code.
3. Run the narrowest useful command and verify RED for the expected reason.
4. Write the smallest production change needed to reach GREEN.
5. Re-run the relevant test command and verify GREEN.
6. Refactor only while staying green.
7. Repeat for the next behavior unit.
8. Load `skills/test-driven-development/testing-anti-patterns.md` when writing or changing tests, adding mocks, or considering test-only production helpers.

## Rules

- No production-code edit before an observed failing test for the current behavior unit.
- If the first test run passes, tighten or replace the test before changing production code.
- If the first test run errors for the wrong reason, fix the test or setup first; RED must be meaningful.
- Prefer real behavior checks over mock-heavy assertions.
- Keep tests scoped to one behavior and name that behavior explicitly.
- Use the exact RED and GREEN commands in status updates, subagent handoffs, or final verification notes.
- Only bypass this overlay when the approved task is explicitly configuration-only, generated-output-only, or the user says not to use TDD.
