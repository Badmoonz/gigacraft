# Gigacraft Helper Guidance Refinement Design

- Status: Approved for planning
- Date: 2026-03-29
- Target: Prompt and docs refinement for optional MCP helper guidance
- Source context: `QWEN.md`, `README.md`, `agents/*.md`, `qwen_superpowers_agent_draft.md`

## 1. Problem Statement

Refine `gigacraft` so the extension no longer reads as if a specific MCP helper is required for normal use, while still documenting practical helper options for repository navigation and version-sensitive documentation lookup.

The desired outcome is:

- lower perceived setup burden
- less coupling to one specific MCP stack
- explicit support for both Serena and `code-index-mcp` as alternatives
- no change to the extension's default workflow or installation surface

## 2. Current-State Observations

- The shipped extension is already lightweight and works without bundling any MCP server.
- `QWEN.md` is currently generic and does not hard-require Serena, but it also does not describe optional helper usage clearly.
- The strongest tool-specific language currently lives in `qwen_superpowers_agent_draft.md`, which still frames Serena and Context7 as primary building blocks.
- The draft uses stage-by-stage MCP preferences that lean Serena-first.
- The user wants to minimize requirements and keep both Serena and `code-index-mcp` as valid alternatives.
- The user does not want a strict priority encoded in `QWEN.md`.

## 3. Goals

- Minimize core requirements in the main extension guidance.
- Keep `QWEN.md` neutral and lightweight.
- Remove hard Serena-first wording from shipped agent prompts where applicable.
- Document optional helper guidance clearly in `README.md`.
- Keep both Serena and `code-index-mcp` positioned as valid repository-navigation alternatives.
- Keep Context7 framed as an optional helper for version-sensitive docs lookup.
- Update the source draft so it reflects the same neutral stance.

## 4. Non-Goals

- Do not add MCP configuration files, setup scripts, or bundled helper manifests.
- Do not integrate `code-index-mcp` into the extension itself.
- Do not change the default workflow:
  - spec
  - plan
  - implement
  - review
- Do not redesign the prompt architecture.
- Do not change the extension manifest or release surface.

## 5. Constraints And Assumptions

- `QWEN.md` should remain concise and should not become a long helper catalog.
- Helper guidance in `QWEN.md` should be capability-oriented rather than vendor-oriented.
- The README can be more explicit than `QWEN.md`.
- The draft should be updated because it is still the source material for future evolution.
- Serena and `code-index-mcp` should be presented as alternatives, not as required dependencies.

## 6. Design Options

### Option A: Full neutralization in all files

Remove all concrete helper names from `QWEN.md`, agents, README, and draft, and speak only in capability language.

Pros:

- Lowest vendor lock-in
- Shortest prompts

Cons:

- Less practical for users who want concrete setup guidance
- Hides the intended helper ecosystem too much

### Option B: Neutral core, explicit docs `(recommended)`

Keep `QWEN.md` and agent prompts generic, while documenting Serena, `code-index-mcp`, and Context7 in README and revising the draft to match.

Pros:

- Minimizes core requirements
- Keeps prompts clean
- Still gives users actionable guidance
- Fits the user's preference to avoid a hard priority in `QWEN.md`

Cons:

- Guidance is split between core prompt files and docs

### Option C: Explicit dual-tool guidance everywhere

Mention Serena and `code-index-mcp` directly in `QWEN.md`, agents, README, and draft.

Pros:

- Very visible ecosystem guidance

Cons:

- More prompt noise
- More coupling to current tool choices
- Harder to keep concise

## 7. Recommended Design

Choose **Option B: Neutral core, explicit docs**.

### `QWEN.md`

Add a short helper guidance block that says:

- MCP helpers are optional
- repository-aware or semantic navigation helpers can be used when available
- documentation lookup helpers can be used when framework or library behavior is version-sensitive

Do **not** encode a strict priority between Serena and `code-index-mcp`.

### `agents/*.md`

Where agent prompts currently imply a specific helper preference, replace that with capability-oriented wording such as:

- use repository-aware navigation when available
- use version-aware documentation lookup when needed

The prompts should describe what kind of tool is useful, not require one named product.

### `README.md`

Add an explicit optional helper section, with concrete examples:

- Serena and `code-index-mcp` as alternatives for repository navigation
- Context7 as an optional helper for version-sensitive docs lookup

This section should be clearly labeled optional so it does not look like a prerequisite.

### `qwen_superpowers_agent_draft.md`

Revise the draft so it no longer reads as Serena-first. Specifically:

- soften the opening tool list
- replace “Use Serena first” phrasing with neutral navigation-helper phrasing
- replace stage-by-stage MCP preference rules with softer recommended-helper language
- keep Context7 optional and scoped to version-sensitive docs lookup

## 8. Impacted Areas

- Root prompt:
  - `QWEN.md`
- User-facing docs:
  - `README.md`
- Agent prompts:
  - `agents/*.md`
- Source draft:
  - `qwen_superpowers_agent_draft.md`
- Internal planning/docs, if needed for consistency:
  - `docs/superpowers/specs/*.md`
  - `docs/superpowers/plans/*.md`

## 9. Risks

- Over-neutralizing may make setup guidance too abstract.
- Leaving too many named-tool references in the draft could reintroduce the same confusion later.
- If helper guidance is duplicated in too many places, it may drift out of sync.
- If the README language is too strong, users may still read optional helpers as prerequisites.

## 10. Open Questions

There are no blocking open questions for this refinement.

Intentional follow-ups for later, not this task:

- decide whether helper examples should eventually include concrete config snippets
- decide whether Gemini-facing docs should mirror the same helper guidance model
