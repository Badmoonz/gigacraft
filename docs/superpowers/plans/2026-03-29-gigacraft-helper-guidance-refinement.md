# Gigacraft Helper Guidance Refinement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refine `gigacraft` so helper guidance is lower-friction, neutral in core prompts, and explicit-but-optional in docs while keeping Serena and `code-index-mcp` as alternatives.

**Architecture:** Keep the core prompt surface small and capability-oriented: `QWEN.md` should describe optional helper capabilities without naming a preferred MCP, `README.md` should carry explicit optional helper guidance, and `qwen_superpowers_agent_draft.md` should be normalized away from Serena-first stage rules. Shipped agent and command files stay unchanged unless a final sweep finds named-helper requirements that still contradict the approved design.

**Tech Stack:** Markdown prompt files, ripgrep-based validation, local Qwen extension smoke checks

---

## Assumptions

- The main shipped files expected to change are `QWEN.md`, `README.md`, and `qwen_superpowers_agent_draft.md`.
- Current shipped agent prompts are already mostly capability-oriented and may not require edits.
- No automated test suite exists for prompt semantics; validation will rely on exact text checks, diff review, and a Qwen extension smoke check.
- The extension manifest does not need to change for this refinement.

## Planned File Structure

### Primary modifications

- Modify: `QWEN.md`
  - Add a short neutral block that describes optional helper capabilities without encoding a strict tool priority.
- Modify: `README.md`
  - Add an explicit optional helper section naming Serena and `code-index-mcp` as navigation alternatives and Context7 as optional docs lookup help.
- Modify: `qwen_superpowers_agent_draft.md`
  - Replace Serena-first guidance with softer recommended-helper wording that preserves Serena and `code-index-mcp` as alternatives.

### Validation-only targets

- Inspect: `agents/architect.md`
- Inspect: `agents/planner.md`
- Inspect: `agents/implementer.md`
- Inspect: `agents/reviewer.md`
- Inspect: `commands/*.md`
  - Only modify these files if the final validation sweep finds named-helper requirements that contradict the approved design.

## Validation Sequence

1. Core-prompt validation
- Confirm `QWEN.md` contains optional helper language.
- Confirm `QWEN.md` does not contain a strict Serena-first or `code-index-mcp`-first rule.

2. README validation
- Confirm README has an explicit optional helper section.
- Confirm the section names Serena, `code-index-mcp`, and Context7 as optional helpers rather than prerequisites.

3. Draft validation
- Confirm hard-priority phrases like `Use Serena first` and `Context7 first` are removed from the draft.
- Confirm the draft still mentions Serena and `code-index-mcp` as alternatives.

4. Extension smoke validation
- Run `qwen extensions list`
- Confirm `gigacraft` still appears as the linked extension after the prompt/docs edits

## Task 1: Add Neutral Optional Helper Guidance To `QWEN.md`

**Files:**
- Modify: `QWEN.md`

- [ ] **Step 1: Verify the new helper block does not exist yet**

Run:

```bash
rg -n "MCP helpers are optional|repository-aware or semantic navigation helpers|documentation lookup helpers" QWEN.md
```

Expected: no matches

- [ ] **Step 2: Add a short helper guidance block**

Insert a concise section into `QWEN.md` with wording along these lines:

```md
## Optional Helpers

- MCP helpers are optional.
- Use repository-aware or semantic navigation helpers when available.
- Use documentation lookup helpers when framework or library behavior is version-sensitive.
```

- [ ] **Step 3: Verify the helper block is now present**

Run:

```bash
rg -n "MCP helpers are optional|repository-aware or semantic navigation helpers|documentation lookup helpers" QWEN.md
```

Expected: matches for the new helper guidance

- [ ] **Step 4: Verify no strict priority leaked into `QWEN.md`**

Run:

```bash
rg -n "Serena first|code-index-mcp first|Context7 first|Use Serena first" QWEN.md
```

Expected: no matches

- [ ] **Step 5: Commit the root prompt refinement**

```bash
git add QWEN.md
git commit -m "docs: soften helper guidance in QWEN"
```

## Task 2: Document Optional Helper Setup In `README.md`

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Verify the optional helper section is not already present**

Run:

```bash
rg -n "Optional Helper|Serena|code-index-mcp|Context7" README.md
```

Expected: either no helper section, or no complete optional-helper guidance block

- [ ] **Step 2: Add an explicit optional helper section**

Write a new README section with content equivalent to:

```md
## Optional Helpers

You can use optional MCP helpers if you want stronger navigation or docs lookup:

- Serena or `code-index-mcp` for repository navigation
- Context7 for version-sensitive framework or library docs lookup

These are optional helpers, not prerequisites for using `gigacraft`.
```

- [ ] **Step 3: Verify all three helper names are documented**

Run:

```bash
rg -n "Serena|code-index-mcp|Context7|optional helpers|not prerequisites" README.md
```

Expected: matches for all helper references and the non-prerequisite wording

- [ ] **Step 4: Verify README does not turn helpers into requirements**

Run:

```bash
rg -n "required|must install|required setup|prerequisite" README.md
```

Expected: no new requirement language introduced by the helper section

- [ ] **Step 5: Commit the README helper docs**

```bash
git add README.md
git commit -m "docs: add optional helper guidance"
```

## Task 3: Normalize Helper Guidance In The Source Draft

**Files:**
- Modify: `qwen_superpowers_agent_draft.md`

- [ ] **Step 1: Capture the current hard-priority guidance**

Run:

```bash
rg -n "Use Serena first|Use Serena before|Context7 first|Recommended MCP preference by stage|Serena \\+|Serena / Context7|Serena second" qwen_superpowers_agent_draft.md
```

Expected: multiple matches showing Serena-first and stage-priority wording

- [ ] **Step 2: Rewrite the opening tool list and stage guidance**

Update the draft so it:

- describes MCP helpers as optional support rather than core requirements
- keeps Serena and `code-index-mcp` as alternatives for repository navigation
- keeps Context7 as optional for version-sensitive docs lookup
- removes hard stage-by-stage priority wording

- [ ] **Step 3: Replace hard-priority phrases with neutral capability wording**

Use wording like:

```md
- Use repository-aware navigation helpers when available.
- Use version-aware documentation lookup when framework or library behavior is sensitive.
```

Preserve concrete helper names only where they are useful as examples or alternatives.

- [ ] **Step 4: Verify Serena-first language is gone while alternatives remain**

Run:

```bash
rg -n "Use Serena first|Context7 first|Serena second" qwen_superpowers_agent_draft.md
rg -n "Serena|code-index-mcp|code-index|Context7" qwen_superpowers_agent_draft.md
```

Expected:
- first command returns no matches
- second command still returns meaningful optional-helper references

- [ ] **Step 5: Commit the draft normalization**

```bash
git add qwen_superpowers_agent_draft.md
git commit -m "docs: normalize helper guidance in draft"
```

## Task 4: Run Final Consistency Sweep And Smoke Validation

**Files:**
- Inspect: `agents/architect.md`
- Inspect: `agents/planner.md`
- Inspect: `agents/implementer.md`
- Inspect: `agents/reviewer.md`
- Inspect: `commands/*.md`
- Modify only if needed: any file that still contains hard named-helper requirements

- [ ] **Step 1: Audit shipped agent and command files for named-helper requirements**

Run:

```bash
rg -n "Use Serena first|Use Serena|Context7 first|code-index-mcp first|Serena / Context7" agents commands
```

Expected: no hard-priority helper wording in shipped agent and command files

- [ ] **Step 2: If any matches remain, update only the matching files**

If matches are found, rewrite them to capability-oriented wording and re-run the grep until it returns no matches.

- [ ] **Step 3: Run a focused cross-file consistency check**

Run:

```bash
rg -n "Serena first|Context7 first|code-index-mcp first|must install|required setup" QWEN.md README.md agents commands qwen_superpowers_agent_draft.md
```

Expected: no matches for hard-priority or helper-prerequisite wording

- [ ] **Step 4: Run the extension smoke check**

Run:

```bash
qwen extensions list
```

Expected: `gigacraft` still appears in the list as the linked extension

- [ ] **Step 5: Commit any final consistency fixes**

```bash
git add QWEN.md README.md agents commands qwen_superpowers_agent_draft.md
git commit -m "docs: finalize optional helper guidance"
```
