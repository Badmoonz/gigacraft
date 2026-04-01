# Testing Anti-Patterns

Load this reference when writing or changing tests, adding mocks, or considering test-only helpers in production code.

## Iron Laws

1. NEVER test mock behavior.
2. NEVER add test-only methods to production code.
3. NEVER mock a dependency until you understand which side effects the test needs.
4. NEVER use partial mocks for data structures that downstream code may read more deeply.

## Anti-Pattern 1: Testing Mock Behavior

Smell:
- The assertion proves that a mock rendered, was called, or exists, but does not prove user-visible or contract-visible behavior.

Prefer:
- Assert on real behavior, public outputs, or integration boundaries.
- If a mock is required for isolation, assert on the surrounding unit's behavior, not the mock's existence.

Gate:
- Ask: "Am I testing the system behavior, or just the mock?"

## Anti-Pattern 2: Test-Only Production Helpers

Smell:
- Adding a method, flag, or branch to production code only so tests can inspect or clean something up.

Prefer:
- Put cleanup, builders, fixtures, and probes in test utilities.
- Keep lifecycle ownership in the real component that already owns it.

Gate:
- Ask: "Would this API still deserve to exist if tests did not need it?"

## Anti-Pattern 3: Mocking Without Understanding

Smell:
- Mocking a high-level dependency before confirming which side effects the test relies on.

Prefer:
- Run with the real implementation first when practical.
- Mock lower-level slow or external operations while preserving the behavior the test depends on.

Gate:
- Ask: "What side effects does the real dependency provide, and does this test need any of them?"

## Anti-Pattern 4: Incomplete Mocks

Smell:
- Mocking only the fields the current assertion touches, while real downstream code may read more of the structure.

Prefer:
- Mirror the real schema completely enough for downstream consumers.
- Use real fixtures or documented payload shapes when available.

Gate:
- Ask: "Does this mock match the real contract, or only the slice I remembered?"

## Anti-Pattern 5: Tests As Cleanup After Implementation

Smell:
- Production code is already written and tests are being added afterwards to "confirm" it.

Prefer:
- RED first, then minimal GREEN, then refactor.

Gate:
- Ask: "Did I observe the failing test before I changed production code?"
