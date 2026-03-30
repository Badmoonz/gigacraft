---
name: brainstorming
description: Use before implementation when the user is exploring a feature, change, migration, or design decision that is not already fully specified.
---

# Brainstorming

## Goal

Turn a rough request into an approved design that fits the current repository before implementation planning starts.

## Process

1. Inspect the relevant repository context first.
2. Restate the problem in repository terms, including observed constraints, assumptions, and unknowns.
3. If the request spans multiple independent subsystems, decompose it and brainstorm only the first bounded slice.
4. Ask clarifying questions one at a time. Prefer narrow or multiple-choice questions when possible.
5. Present two or three viable design options when trade-offs matter.
6. Recommend one option and explain why it fits the current repository, boundaries, and conventions.
7. Present the design in reviewable sections scaled to the task size.
8. Get explicit user approval before writing the spec.
9. Save the approved design to `docs/gigacraft/specs/YYYY-MM-DD-<topic>-design.md`.
10. Run self-review on the written spec.
11. Show the user a `ReviewOptions` checklist with the recommended external review run and wait for their response.
12. Run the external review gate on the written spec using the confirmed review set:
   - always include `spec-reviewer` unless the user explicitly chooses a fast path
   - dispatch `api-designer` before `spec-reviewer` when API or contract surfaces change
   - dispatch `sre-skeptic` before `spec-reviewer` when operational risk is material
13. Apply the strongest findings inline and re-run only the minimum necessary final review pass if the spec changed materially.
14. Ask the user to confirm the written and reviewed spec.
15. Stop after the design is approved, written, and reviewed; the next workflow stage is `writing-plans`.

## Design Focus

- Prefer small, evolvable designs over clever or speculative ones.
- Follow existing package, module, service, and config boundaries unless the current task needs a targeted change.
- Keep reasoning grounded in repository code, docs, contracts, tests, and tool output.
- Cover the parts that matter for the touched area: interfaces, data flow, failure modes, testing, and operational impact.
- For backend work, consider API contracts, persistence, config, observability, rollout, and rollback.
- Keep the design concrete enough for planning, but do not drift into step-by-step implementation.
- Use `docs/gigacraft/specs/` as the default spec location. Do not improvise alternate default paths such as `docs/specs/` or `docs/plans/`.

## Clarifying Question Format

During the clarifying-question phase, ask exactly one question per assistant message and wait for the user's reply before asking the next one.

Use this format:

```text
AskUserQuestion
Question: <one concrete question>
Options:
- <option A>
- <option B>
- <option C>
```

If multiple-choice options would be artificial, use:

```text
AskUserQuestion
Question: <one concrete open question>
```

Rules for this phase:

- The whole message should contain exactly one question.
- Do not include a heading like `Clarifying questions:` or `Уточняющие вопросы:`.
- Do not number multiple questions in one message.
- Do not combine a question with context summary, design proposal, or next-step narration.
- Options are for the same question only, not hidden sub-questions.
- If you already have enough information, stop asking questions and move to design options instead.

## Review Options Format

After the spec is written and self-reviewed, but before dispatching external reviewers, show a short review selection message and wait for the user's reply.

Use this format:

```text
ReviewOptions
Recommended review run for this spec:
- [x] spec-reviewer (required unless fast path)
- [ ] api-designer
- [ ] sre-skeptic

Reply with one of:
- approve
- add <agent>
- remove <agent>
- fast path
```

Adjust the checked boxes to match the spec:

- `spec-reviewer` should be checked for every non-trivial spec.
- Check `api-designer` when the spec changes HTTP APIs, service contracts, webhooks, event schemas, or external integrations.
- Check `sre-skeptic` when the spec has meaningful operational risk.
- Do not preselect more than two optional specialists.

Rules for this phase:

- Show this once per written spec before external review starts.
- Wait for the user's reply before dispatching any external review agent.
- Treat `approve` as approval of the currently checked review set.
- Let the user add or remove optional specialists.
- Do not remove `spec-reviewer` unless the user explicitly chooses `fast path`.
- If the user chooses `fast path`, say you are skipping external review and continue only if that is allowed by the current task context.
- Do not combine `ReviewOptions` with unrelated questions, design prose, or the final written-spec confirmation.

## After the Design

Run a short review loop after the spec is written. This is especially useful for Qwen models because a second narrow pass often catches ambiguity that the drafting pass missed.

### Self-Review

Do this every time:

1. Placeholder and ambiguity scan: remove `TODO`, `TBD`, vague nouns, and overloaded terms.
2. Internal consistency check: make sure goals, constraints, design choice, and impacted areas do not contradict each other.
3. Scope check: confirm the spec is still small enough for one implementation plan; split it if needed.
4. Validation and operations check: confirm the spec says enough about testing, failure modes, observability, rollout, and rollback for the touched area.

### External Review Gate

Do this after self-review for every non-trivial written spec:

- Self-review is not a substitute for external review.
- Dispatch `spec-reviewer` on the written spec as the default final review gate.
- The review phase is not complete until at least one external review agent has returned findings or a clear approval verdict.
- For small or obviously local specs, skip specialized reviewers and run only `spec-reviewer`.
- Only skip all external review if the user explicitly asks for a fast path or the spec is a tiny local note and you clearly say you are taking that fast path.
- Before running external review, present the `ReviewOptions` checklist and wait for the user's response.

### Focused Subagent Review

When the spec needs extra pressure-testing, use up to two narrow specialist passes before `spec-reviewer`:

- Let the spec author do the drafting and self-review first.
- Use `api-designer` when the spec introduces or changes HTTP APIs, service contracts, webhooks, event schemas, or external integration surfaces.
- Use `sre-skeptic` when the spec touches production safety concerns such as public APIs, persistence, concurrency, migrations, background jobs, rollout, rollback, or complex failure handling.
- Use `spec-reviewer` as the mandatory final readiness gate after any specialized review.
- Specialized reviewers should usually run from contract and interface concerns to operational concerns, then finish with `spec-reviewer`.
- Common order for API-facing specs: author, `api-designer`, fix, `sre-skeptic`, fix, `spec-reviewer`, fix.
- Common order for non-API but operationally risky specs: author, `sre-skeptic`, fix, `spec-reviewer`, fix.
- Common order for ordinary repository-local specs: author, `spec-reviewer`, fix.
- If a separate drafting pass is helpful, use the `architect` subagent for authoring and revision, not as a reviewer.
- Give review agents the written spec and any prior findings, not raw session history.
- When dispatching `api-designer`, use `skills/brainstorming/api-designer-dispatch.md` to keep API review concrete and repository-aware.
- When dispatching `sre-skeptic`, use `skills/brainstorming/sre-skeptic-dispatch.md` to keep the pre-mortem focused and bounded.
- When dispatching `spec-reviewer`, use `skills/brainstorming/spec-reviewer-dispatch.md` to keep the prompt calibrated and artifact-based.
- Replace dispatch placeholders with the actual absolute spec path before sending. Never pass `_dispatch.md` paths or unresolved tokens like `[SPEC_FILE_PATH]`.
- Compose the agent request from the dispatch template text, not by sending the `_dispatch.md` file path itself.
- Ask for findings only, not rewrites and not implementation planning.
- Keep the loop bounded: one pass per specialized reviewer by default, then one final `spec-reviewer` pass. Re-dispatch only after material spec changes, and stop after three external review passes before surfacing the remaining issues to the user.

Apply the strongest findings inline, then ask the user to review the written spec before moving to `writing-plans`.

## Rules

- Do not write production code.
- Do not invoke implementation skills before the design is approved.
- Do not skip user approval for the design.
- Do not skip the design step just because the task looks simple; keep the design short instead.
- Distinguish observed facts from assumptions.
- Do not propose unrelated refactoring; include only changes that support the current goal.
- Prefer concise questions and design sections that fit the model's working context.
- During clarification, enforce the `AskUserQuestion` format strictly.
- Before external review, enforce the `ReviewOptions` format strictly.
- Prefer checklist-style review over open-ended critique when reasoning is limited.
- After writing the spec, dispatch `spec-reviewer` unless you are taking an explicit fast path.
- Do not treat self-review as a substitute for `spec-reviewer`.
- Do not spawn specialized review agents for trivial or obviously local changes.
- Prefer artifact-based review prompts because Qwen works better with narrow, explicit context than with broad conversation replay.
- Treat `spec-reviewer` as the required last external reviewer when specialized reviewers are used.
- Use the `architect` subagent when a separate focused spec-writing pass will help.
- If the user explicitly asks for `/write-spec`, honor that as a manual fallback.
