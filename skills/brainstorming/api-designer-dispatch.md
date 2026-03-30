# API Designer Dispatch Template

Use this template when dispatching the `api-designer` agent on a written design/spec.

Purpose: review the API or contract surface of the spec before implementation planning starts.
Use this before the final `spec-reviewer` pass when the spec changes an API or integration contract.

Dispatch after the spec is written to `docs/gigacraft/specs/` or another agreed design-doc location.

This file is a prompt template, not the artifact to review.
Before dispatching, copy the template text into the agent request and replace every placeholder with concrete values.
Use the absolute path to the written spec file.
Never pass this template's own path or unresolved placeholder text such as `[SPEC_FILE_PATH]` to the agent.

## Template

```text
Review this written spec as an API and contract design check.

Spec to review: /absolute/path/to/docs/gigacraft/specs/YYYY-MM-DD-topic-design.md
Relevant existing API conventions or analogous endpoints: none
Prior review findings: none

What to check:

| Category | What to look for |
|----------|------------------|
| Resource and operation design | Clear resource boundaries, sane operation set, no accidental RPC sprawl |
| Contract clarity | Request/response shapes, field semantics, naming consistency, explicit invariants |
| Compatibility | Safe evolution path, versioning, deprecation shape, migration expectations |
| Auth and access boundaries | Authentication expectations, authorization shape, tenant and scope boundaries |
| Error and retry behavior | Error model, idempotency, retry safety, partial failure semantics |
| Query ergonomics | Pagination, filtering, sorting, batching, search, payload limits |
| Async and integrations | Webhooks, events, callbacks, delivery semantics, contract ownership |
| Developer experience | Example completeness, discoverability, consistency with existing conventions |

Calibration:

- Only flag issues that would cause real API misuse, compatibility risk, or planning confusion.
- Prefer repository-fit guidance over generic API best-practice lectures.
- If the spec only lightly touches an interface and the contract looks fine, say so clearly.
- Prefer exact section references over abstract commentary.

Return this format:

- Verdict
- Blocker findings
- Major findings
- Minor findings
- Backward compatibility and versioning notes
- Required fixes or open questions
```

Checklist before send:

- Replace the spec path with the actual absolute path to the written spec.
- Replace optional fields with concrete text or the literal word `none`.
- Do not send bracketed placeholders to the agent.
