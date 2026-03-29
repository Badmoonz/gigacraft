# Testing Standards

- Prefer unit tests for local behavior and integration tests for contract boundaries.
- Add regression tests for real bugs when practical.
- Tests should prove behavior rather than mirror implementation details.
- Avoid brittle snapshot-style assertions unless they are clearly the best fit.
- Expand from the narrowest useful test to broader validation only when risk warrants it.
