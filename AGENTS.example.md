# AGENTS.example.md

This file is a template for a local, untracked `AGENTS.md` used when developing the `gigacraft` extension itself.

## Local-Only Rule

- Keep the real `AGENTS.md` out of git.
- Add `AGENTS.md` to `.git/info/exclude` in your local clone before using it.

## What Belongs Here

- Maintainer notes for evolving `gigacraft`
- Local workflow preferences for working on the extension repo
- Comparison notes against `obra/superpowers`
- Reminders that `skills/` is the primary workflow layer and `commands/` is the manual fallback layer

## What Does Not Belong Here

- User-facing runtime behavior that should ship in the extension
- Rules that belong in `QWEN.md`, `skills/`, `agents/`, `commands/`, or `context/`
