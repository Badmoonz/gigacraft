# Go Standards

- Pass `context.Context` explicitly where appropriate.
- Return errors clearly and avoid hiding them.
- Avoid goroutine leaks and unclear ownership.
- Keep interfaces small and justified by real use.
- Prefer straightforward package boundaries and minimal indirection.
- Add tests for nil cases, cancellation, retries, and timeout behavior when relevant.
