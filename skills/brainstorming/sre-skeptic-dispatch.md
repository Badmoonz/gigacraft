# SRE Skeptic Dispatch Template

Use this template when dispatching the `sre-skeptic` agent on a written design/spec.

Purpose: run a compact pre-mortem on the spec before implementation planning starts.
Use this before the final `spec-reviewer` pass when the spec has meaningful operational risk.

Dispatch after the spec is written to `docs/gigacraft/specs/` or another agreed design-doc location.

This file is a prompt template, not the artifact to review.
Before dispatching, copy the template text into the agent request and replace every placeholder with concrete values.
Use the absolute path to the written spec file.
Never pass this template's own path or unresolved placeholder text such as `[SPEC_FILE_PATH]` to the agent.

## Template

```text
Review this written spec as a production-risk pre-mortem.

Spec to review: /absolute/path/to/docs/gigacraft/specs/YYYY-MM-DD-topic-design.md
Known constraints or rollout assumptions: none
Prior review findings: none

Assume the feature shipped and caused a Sev-1 incident within 72 hours.

What to check:

| Category | What to look for |
|----------|------------------|
| Failure modes | Unhandled states, partial success paths, bad fallback behavior |
| Concurrency and ordering | Races, duplicate work, ordering assumptions, unsafe retries |
| Data safety | Integrity gaps, idempotency holes, migration traps, irreversible writes |
| Capacity and latency | Bottlenecks, fan-out, hot paths, overload behavior, retry storms |
| Rollout safety | Weak feature gating, poor rollback shape, hard-to-reverse changes |
| Observability | Missing signals, weak alertability, blind spots during incident response |

Calibration:

- Focus on the 3 most plausible incident paths, not a brainstorm of every possible disaster.
- Only flag risks that are credibly implied by the spec.
- Prefer concrete failure stories over generic reliability advice.
- If the spec is operationally low-risk, say so clearly instead of inventing drama.
- Prefer section-specific findings over abstract commentary.

Return this format:

- Pre-mortem summary
- Top 3 likely incident paths
- Missing safeguards or signals
- Required spec fixes or open questions
- Overall operational risk: low, medium, or high
```

Checklist before send:

- Replace the spec path with the actual absolute path to the written spec.
- Replace optional fields with concrete text or the literal word `none`.
- Do not send bracketed placeholders to the agent.
