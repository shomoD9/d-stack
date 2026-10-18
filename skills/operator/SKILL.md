---
name: operator
description: Operate Claude Code and Codex as services when acting as an orchestrator or chat assistant. Load before starting work to choose direct action or delegation, write a self-contained prompt, monitor the job, verify its output, and report the result.
---

# Operator

Operate a coding agent. Keep execution inside Claude Code or Codex; own the
handoff, switching between surfaces, review, and communication with the user.
Treat the coding agent as a service with an explicit request and a checked result.

## Choose direct action or delegation

Do a task directly when it is brief and needs no investigation:

- Change a word or drop a line.
- Make a tiny config tweak whose effect is already understood.
- Run a quick read-only check.
- Complete a short browser step, such as opening a known page.

Delegate anything multi-step, any real code, search or research, analysis,
machine tasks, GitHub pushes, workflows, publishing, and video production.
Delegate long browser tasks too; Codex can drive a browser when browser tools
are available in its environment. State which browser surface it should use.
For video, delegate code-generated rendering or generative tooling and specify
the source assets, duration, format, and expected output location.

If a small task grows into investigation or several steps, hand it off.
Your own routine work is moving the request and evidence between surfaces.

## Choose the service and effort

Both services handle most jobs. Use these routing heuristics:

- Start with Codex at high effort for code and anything the user will see or judge.
- Use Claude Code when Codex stalls, for long writing, or for a second opinion.
- Prefer a service that already has the tools and access the task needs.

Use high effort for writing, design, public repositories, decisions, and other
judgment work the user will see. Use medium by default for routine work.
Use low only for mechanical throwaway work; never use it for judgment.
Configure the chosen service's supported effort setting explicitly when needed.
The Codex launch examples below select high effort.

## Write a self-contained prompt

The service has none of your chat context. Include everything it needs to act:

- Goal: the concrete outcome and intended audience.
- Context: working directory, repository and branch, relevant paths, links,
  source documents, prior decisions, and existing work to preserve.
- Constraints: scope, what to leave untouched, privacy, style, permissions,
  and whether pushing or publishing is authorized.
- Success criteria: observable behavior, required checks, and evidence of completion.
- Report: a short outcome, files changed, commit hash, links, checks and results,
  open issues, and anything not completed or verified.

Pass source paths and focused excerpts instead of asking the tool to infer history.
When the user's own wording exists in a source document, require verbatim copying
of that text into the deliverable rather than paraphrasing it.
Keep credentials out of prompts, logs, commits, and reports; pass access through
the service's configured credential mechanism.

Use this template, filling every field that affects the work:

```text
Goal: [Deliverable and intended outcome.]
Context: [Working directory, repo/branch, paths, links, decisions, source text.]
Constraints: [Scope, untouched files, privacy, style, authorized external actions.]
Success: [Behavior to demonstrate, tests/checks, evidence to retain.]
Verification: Use installed verification skills where available. Review the actual
artifact against these criteria, fix failures, and identify unverified claims.
Report: Give a short outcome, changed files, commit hash, proof links or check
results, open issues, and anything not done. Keep large artifacts in files.
```

For an installed verification workflow, name the skill and its path in the prompt.
pstack's prove-it skills and other installed verification or review skills may
be available in both tools. Check availability; do not assume installation.

## Launch the job

Use the service's configured authentication. These examples use
`~/.codex/config.toml` for Codex's default model and effort, and
`~/.claude_token` as an example Claude credential setup file. Adapt those
locations to the environment without printing their contents.
Use permission-bypass flags only within the user's authorized scope and an
environment approved for that access; the flags grant no additional authorization.

Codex:

```sh
codex exec --dangerously-bypass-approvals-and-sandbox -c model_reasoning_effort=high "<prompt>" </dev/null
```

Pass a prompt file and working directory (`-C <dir>`) when needed:

```sh
codex exec --dangerously-bypass-approvals-and-sandbox -c model_reasoning_effort=high -C "<dir>" "$(cat prompt.md)" </dev/null
```

Always close Codex's stdin with `</dev/null` for this launch pattern.
Leaving it open can hang the job waiting for input.

Claude Code:

```sh
. ~/.claude_token && claude -p --dangerously-skip-permissions "<prompt>"
```

Set Claude Code's working directory by launching it from that directory.
For a prompt file, replace `"<prompt>"` with `"$(cat prompt.md)"`.
Keep prompt contents in a quoted argument; do not evaluate them as shell code.

## Run long jobs in the background

Give each run its own log and completion record. For example:

```sh
(
  set +e
  codex exec --dangerously-bypass-approvals-and-sandbox -c model_reasoning_effort=high -C "<dir>" "$(cat prompt.md)" </dev/null
  job_status=$?
  printf '%s\n' "$job_status" > job.exit
  exit "$job_status"
) > job.log 2>&1 &
job_pid=$!
```

Use a terminal/session runner that survives the launch shell if the environment
terminates background children on disconnect. Record its session ID or job PID.
Use the same log and exit-status pattern for Claude Code, sourcing credentials
inside the background group before its command.

Check `tail -n 40 job.log` at useful intervals or on completion notifications.
Use the runner's process status, or `kill -0 "$job_pid"`, to check liveness.
Read `job.exit` after completion; missing status means completion is unconfirmed.
Use fresh filenames for retries so an old exit record cannot imply success.
Avoid constant polling and loading whole logs into chat context.

If a job makes no progress for about 15 minutes, stop it and confirm it stopped.
Switch a stalled Codex job to Claude Code with the same self-contained prompt.
Add a short handoff identifying partial changes and the last observed state.
Inspect existing side effects before retrying pushes, publishing, or workflows.
If the fallback also stalls, report the blocker and retained work instead of
starting an unbounded retry loop.

## Verify before delivery

Never deliver unreviewed output. Ask the service to retain evidence, then inspect
the actual artifact and compare it with every success criterion:

- Code: read the diff; run applicable tests, lint, and CI; exercise the changed behavior.
- UI: render it, inspect screenshots, and exercise the affected flow in a browser.
- Research and analysis: open cited sources, check facts and calculations,
  and distinguish sourced findings from inference.
- Writing: compare against the brief, style rules, and source documents;
  check that required user wording was copied verbatim.
- Links and publishing: open the destination and confirm the intended content is live.
- Workflows: inspect the run and final state, including failures and skipped steps.
- Video: play the rendered output; check duration, frames, audio, and export format.

A service's success message or zero exit code alone does not prove the deliverable.
Delegate fixes with the failed criterion and observed evidence, then recheck.
Mark anything inaccessible or untested as unverified.

## Commit, push, and confirm CI

For repository changes, have the service check the branch, worktree, and git
identity before committing. Preserve unrelated work and use the repository's
identity convention. Ask when no intended identity can be established.
Have the service commit the scoped changes with a clear message.

Push operational repository changes right away once reviewed and verified,
within the user's authorized repository and branch. Honor explicit instructions
to withhold pushes or publication. Never force-push or rewrite pushed
history without the user's approval.

After pushing, confirm the remote commit hash and CI for that exact commit.
Wait for required checks to finish. If they fail, delegate the fix, commit,
push, and verify the new run. If CI is absent or inaccessible, say so.

## Protect context and report the result

Have the service read large files, logs, and diffs and return a focused summary.
Ask for paths and line ranges when an excerpt needs review. Read the relevant
diff and evidence without importing unrelated artifacts or repeating the work.
Keep full reports and generated assets in files; request a short handoff in chat.

Report the outcome first. Include artifact links, commit hashes when applicable,
and the proof that meets the success criteria. State remaining issues, omitted
work, and verification limits. Keep the report short enough for the user to act on.
