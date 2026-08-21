---
name: control-glkvm-windows
description: Control the GLKVM-hosted Windows computer through Vivaldi, recover unreliable remote mouse or keyboard input, inspect or restart its Docker services, and supervise Claude Code or another terminal coding agent running there. Use when connecting to the configured GLKVM endpoint, operating the remote Windows desktop, handling GLKVM pointer-lock or stale-window failures, orchestrating a coding or testing session in its terminal, or resuming the Florida Exchange testing-suite exercise.
---

# Control GLKVM Windows

Operate the remote computer deliberately. Treat the browser window, GLKVM canvas, Windows session, and terminal agent as separate stateful layers that each require verification.

## Load the relevant context

- Read [references/glkvm-runbook.md](references/glkvm-runbook.md) before connecting, changing GLKVM settings, controlling Windows, or managing Docker.
- Read [references/terminal-agent-orchestration.md](references/terminal-agent-orchestration.md) before supervising a coding agent in the remote terminal.
- Read [references/florida-exchange-handoff.md](references/florida-exchange-handoff.md) when resuming the Florida Exchange test-suite work. Treat every recorded runtime state as historical and re-check it.

## Follow the control loop

1. Obtain the endpoint credential from the user or an authorized secure session. Never write it into commands, files, logs, commits, or chat summaries.
2. Open a dedicated Vivaldi window for GLKVM. Ask the user to leave Vivaldi alone or use a different browser during control.
3. Refresh application state immediately before each UI action.
4. Verify that the active window title and visible page belong to GLKVM before clicking or typing.
5. Focus the remote canvas, then prefer keyboard navigation and terminal commands over coordinate-sensitive mouse actions.
6. Inspect current Windows, Docker, repository, and terminal-agent state before changing anything.
7. Make one bounded change at a time and verify its effect through visible UI state or terminal output.
8. Re-query state after a user-driven window change, stale-state error, unexpected page, or focus loss. Do not reuse stale coordinates.
9. Report the final state, evidence collected, approvals made, and anything still uncertain.

## Supervise the terminal agent

1. Ask the agent to summarize its current objective, progress, working tree, running services, failing tests, and blockers.
2. Restate the agreed scope and success criteria before authorizing implementation.
3. Approve routine, scoped, reversible inspections when authorized.
4. Review every prompt. Escalate destructive operations, credential access, publishing, external communication, security changes, or scope expansion even if routine approvals were broadly authorized.
5. Keep the agent working in small testable batches. Request exact files changed and commands run after each batch.
6. Verify important claims independently through repository inspection, diffs, and test output before declaring completion.

## Recover safely

- If the browser reports that the user changed Vivaldi, refresh state and reacquire the GLKVM window.
- If remote clicks miss, stop clicking. Confirm pointer lock, set mouse mode to Absolute, enable the local cursor, fit the remote image to the viewport, and reacquire state.
- If macOS or Vivaldi intercepts system shortcuts, use GLKVM's virtual keyboard.
- If TLS trust requires a browser interstitial, hand control to the user for the trust decision unless the session already has authorized trust state.
- If credentials are unavailable or the active page cannot be verified, stop before typing.
