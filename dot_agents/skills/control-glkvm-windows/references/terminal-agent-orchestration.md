# Terminal Coding-Agent Orchestration

## Contents

1. Establish context
2. Agree on a bounded plan
3. Handle approval prompts
4. Monitor execution
5. Verify completion
6. Handoff format

## Establish context

Treat the terminal agent as a capable collaborator whose current internal state may be incomplete or stale. Start with questions rather than a large implementation command.

Ask it to report:

- Repository root, current branch, and working-tree status
- Current objective and the last completed unit of work
- Files already modified and whether the changes predated the session
- Application architecture and test commands discovered
- Running services and required local dependencies
- Failing tests, blockers, and pending approval prompts

Ask for read-only inventory first: manifests, routes, entry points, test configuration, existing test suites, and recent diffs. Preserve unrelated user changes.

## Agree on a bounded plan

Define success in observable terms. For a testing task, name the live surfaces, test layers, required local dependencies, isolation strategy, and exact commands that must pass.

Require the terminal agent to:

1. Distinguish live code paths from obsolete or dead ones.
2. Offer two or three implementation approaches when architecture is uncertain.
3. State exclusions and follow-ups explicitly.
4. Work in the smallest coherent batch that can be verified independently.
5. Pause when new evidence would materially change the agreed scope.

## Handle approval prompts

Broad permission to approve questions covers routine, scoped operations; it does not remove the need to inspect prompts.

Approve without interruption only when already authorized and low risk, such as:

- Reading repository files
- Running status, diff, search, or local test commands
- Inspecting local Docker state
- Creating tests and implementation files inside the agreed repository scope

Escalate or reject prompts involving:

- Destructive deletion, force reset, history rewriting, or broad cleanup
- Credentials, secrets, authentication state, or security controls
- Publishing, deployment, pushing, pull requests, or external messages
- Unrelated repositories or user files
- Scope expansion with material time or behavior impact
- Production or shared external systems

## Monitor execution

After each batch, ask for:

- The exact behavior covered
- Files changed
- Commands run and their exit status
- Remaining failures or skipped checks
- The next smallest batch

Do not let repeated narration substitute for progress. If the agent stalls, ask for the current terminal output and one concrete next command. If a command is long-running, inspect incremental output instead of restarting it blindly.

## Verify completion

Independently inspect the working tree and important code paths. Re-run proportionate verification rather than relying only on the terminal agent's summary.

For testing work:

1. Confirm tests assert behavior rather than merely execute code.
2. Confirm test data is isolated and does not depend on execution order.
3. Run the narrow suite for the changed area.
4. Run the repository's broader required suite.
5. Re-run newly added end-to-end tests to expose obvious flakiness.
6. Record skipped checks and environmental limitations plainly.

Declare completion only when the agreed behavior is implemented, required checks pass, and no approval prompt or unverified change remains.

## Handoff format

Provide the next agent with:

- Objective and approved scope
- Current branch and working-tree state
- Services and dependencies verified in this session
- Completed batches with file paths
- Exact test commands and outcomes
- Pending prompts, failures, and next smallest action
- Assumptions that must be revalidated

Never include passwords, tokens, or reusable session credentials.
