# Backend Standards

## General

- Prefer backward-compatible changes by default.
- Keep changes small, reviewable, and easy to validate.
- Favor explicitness over clever abstractions.
- Preserve existing naming, package, and module conventions where possible.
- Avoid introducing heavy dependencies or new frameworks without clear justification.

## Validation

- Run the smallest useful validation step first.
- Expand validation only when local changes or risk justify it.
- Treat changed behavior as a signal to add or update tests.

## Operational Safety

- Consider logging, metrics, tracing, config defaults, and rollback paths.
- For persistence changes, think about migration order and partial rollout behavior.
- For distributed behavior, think about retries, idempotency, and timeout boundaries.
