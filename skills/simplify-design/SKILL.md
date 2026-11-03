---
name: simplify-design
description: Simplify a product, screen, or codebase toward the standard of Linear's website or Apple Notes. Use when designing, reviewing, or refactoring UI, architecture, or implementation and the goal is fewer elements, labels, and moving parts without breaking anything.
---

# Simplify design

The owner's brief, kept as written:

> I want this to be as perfect as Linear's website or Apple Notes: simple purpose, simple architecture, simple design, simple implementation. Cut taglines, helper text and secondary labels. If a screen needs them to make sense, fix the layout. Every decision should elevate the user experience (UX), developer experience (DX) and agent experience (AX) at once, without breaking anything.

## How to apply it

Work on the task in front of you, then hold it against the brief.

1. **Purpose.** State the one purpose in a sentence. Anything that does not serve it is a candidate for removal.
2. **Architecture.** Prefer the structure with fewer parts, fewer layers, and fewer concepts to learn.
3. **Design.** Cut taglines, helper text, and secondary labels. If a screen needs them to make sense, fix the layout (hierarchy, grouping, naming, order) instead of explaining it.
4. **Implementation.** Prefer the smaller, plainer implementation that a newcomer, or an agent, can read in one pass.
5. **Three audiences.** For each decision, check UX, DX, and AX. Keep it only if it elevates all three at once. If it helps one by hurting another, find a different decision.
6. **Nothing breaks.** Before removing anything, find what depends on it (users, callers, tests, docs, scripts). Verify after the change by running the real thing, not by assuming.

## Report

Say what was cut, what replaced it, and how you confirmed nothing broke. If you could not verify something, say so.
