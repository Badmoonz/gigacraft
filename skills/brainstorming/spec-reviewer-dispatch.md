# Spec Reviewer Dispatch Template

Use this template when dispatching the `spec-reviewer` agent on a written design/spec.

Purpose: verify that the spec is complete, consistent, and concrete enough for implementation planning.
In the `brainstorming` workflow this is the default external review gate for every non-trivial written spec.

Dispatch after the spec is written to `docs/gigacraft/specs/` or another agreed design-doc location.
Never use this template before the spec exists on disk.

This file is a prompt template, not the artifact to review.
Before dispatching, copy the template text into the agent request and replace every placeholder with concrete values.
Use the absolute path to the written spec file.
Never pass this template's own path or unresolved placeholder text such as `[SPEC_FILE_PATH]` to the agent.

## Template

```text
Review this written spec as a planning-readiness gate.

Spec to review: /absolute/path/to/docs/gigacraft/specs/YYYY-MM-DD-topic-design.md
Prior review findings: none
Logical alternative for trade-off check: none

What to check:

| Category | What to look for |
|----------|------------------|
| Completeness | TODOs, placeholders, implicit decisions, incomplete sections |
| Consistency | Internal contradictions, mismatched constraints, incompatible claims |
| Clarity | Requirements ambiguous enough that two implementers could build different things |
| Scope | Too broad for one implementation plan, or mixing independent subsystems |
| Repository fit | Design conflicts with known package, module, service, or config boundaries |
| YAGNI | Unrequested features, speculative complexity, over-engineering |
| Readiness | Missing acceptance checks, validation notes, or operational expectations |

Calibration:

- Only flag issues that would cause real planning or implementation mistakes.
- Approve unless there is a blocker, real ambiguity, or a missing decision that would force silent reinterpretation later.
- Do not nitpick wording, formatting, or section length.
- If prior SRE findings seem unlikely, already mitigated, or too paranoid, say so clearly.
- Keep the trade-off matrix compact and decision-oriented. Use `n/a` when latency is not materially relevant.
- Prefer exact section references over general commentary.

Return this format:

- Verdict
- Blocker findings
- Major findings
- Minor findings
- Trade-off matrix: Complexity, Latency, Maintenance
- Readiness score: 1-10
- Required fixes or open questions
```

Checklist before send:

- Replace the spec path with the actual absolute path to the written spec.
- Replace optional fields with concrete text or the literal word `none`.
- Do not send bracketed placeholders to the agent.
