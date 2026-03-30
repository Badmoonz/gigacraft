---
name: using-gigacraft
description: Use when starting work in a repository that follows the gigacraft structured backend workflow; route to the right workflow skill before coding and keep slash commands as manual fallback.
---

# Using Gigacraft

## Purpose

`gigacraft` is a skills-first backend workflow for Qwen Code.

Your job at the start of work is to route into the correct workflow stage instead of immediately writing code.

## Rules

- Prefer the skills-first path over slash commands.
- Use `brainstorming` when the user is describing a feature, change, or design problem that is not already specified.
- Use `writing-plans` when there is an approved spec and the next job is implementation planning.
- Use `subagent-driven-development` or `executing-plans` only after a written implementation plan or plan pack has been reviewed and explicitly approved by the user.
- Use `requesting-code-review` before declaring merge readiness.
- Use `verification-before-completion` before claiming work is done or fixed.
- Honor explicit user requests for slash-command stages as manual fallbacks.
- Keep commands available as recovery paths, not the primary workflow.

## Stage Map

1. Brainstorm and approve a design.
2. Turn the approved design into a detailed implementation plan or plan pack and get user approval on the written artifacts.
3. Execute the plan.
4. Review the changes.
5. Verify before completion.

## Routing Guidance

- If the next stage is obvious from the conversation, move into that skill.
- If the next stage is ambiguous, ask one narrow clarifying question.
- If automatic routing is not enough, tell the user which slash command is the manual fallback.
