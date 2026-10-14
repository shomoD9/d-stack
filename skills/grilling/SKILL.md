---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

## Elicitation

Always use the AskQuestion tool or elicitation tool for each question — never ask grooming/design questions only in prose. Put the recommended answer in the option label (mark it **Recommended**) and in the prompt body.

For each round, call AskQuestion with one entry per frontier question. Each question's `options` should cover the real choices; label the recommended option **Recommended**. Use `allow_multiple: true` when a question legitimately has more than one answer. Number questions in titles or bodies (`Q1`, `Q2`, …) so the round stays easy to follow.

After the user answers, summarise what landed in a short prose recap if helpful — but the questions themselves always go through AskQuestion, not prose alone.

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.
