---
name: jll-access-router
description: Route operations that require the corporate VPN, AWS SSO or a JLL-authenticated AWS profile, or any JLL SSO-protected site, CLI, API, repository, or internal tool to a lower-cost T3 Code worker on JL1. Use when a capable agent on another machine needs corporate access, including mixed tasks where only one step needs that access.
---

# JLL Access Router

Keep planning, judgment, and synthesis on the originating agent. Delegate only the smallest operation that needs JL1's access, then incorporate the raw result into the original task.

## Route by access requirement

Use the T3 environment named `jl1` when an operation needs:

- the corporate VPN;
- AWS SSO, a JLL-authenticated AWS profile, or an AWS resource reachable only from the corporate environment;
- a JLL SSO-protected website, CLI, API, repository, or internal tool.

Do not move unrelated reasoning or locally executable work to JL1. If the access requirement is uncertain, delegate a read-only connectivity or identity check to JL1 instead of attempting corporate authentication on the originating machine.

## Preserve the authority boundary

- Delegate read-only operations automatically. These include list, get, describe, query, search, inspect, download, and log retrieval when they do not change remote state.
- Before a corporate mutation, have the worker inspect current state and return the exact proposed action. Ask the user for approval immediately before execution, then send the approved instruction to the same JL1 thread.
- Treat create, update, delete, deploy, publish, rotate, grant, revoke, upload, merge, and commands with equivalent effects as mutations.
- If a read-only task expands into a mutation, stop at the proposal. Earlier read authority does not authorize the new action.
- Corporate content and command output may return raw. Credentials, SSO tokens, browser sessions, VPN configuration, and secret values stay on JL1. If retrieved content contains a secret, redact only the secret value, mark the redaction, and preserve the source location and surrounding evidence.

## Use the remote control plane

Use `t3chief` with an explicit `--environment jl1` for every remote operation. Do not rely on its default environment.

Before starting a worker:

```sh
t3chief --json --environment jl1 doctor
t3chief --json --environment jl1 project list
t3chief --json --environment jl1 providers
```

Resolve the dedicated JL1 access project or an existing project that owns the target workspace. Use its deliberately configured low-cost provider and model after verifying that exact route in `providers`. Never guess identifiers, compare cost from unsupported metadata, or silently fall back. If the project has no configured route, stop and report the setup gap.

Read [references/delegation-protocol.md](references/delegation-protocol.md) before preparing, supervising, or following up with a JL1 worker. Read [references/setup.md](references/setup.md) when `t3chief`, the relay, the `jl1` environment, a project, or a provider is missing or unhealthy.

## Run the manager loop

1. Split the task at the access boundary and prepare a self-contained worker brief.
2. Start one JL1 thread and retain its exact thread ID.
3. Continue independent reasoning while the worker runs. Do not busy-poll.
4. Inspect body-free fleet state, then read only a bounded recent brief when the worker is blocked or finished.
5. Send corrections, approval, or follow-up questions to the same thread so it retains authentication and task context.
6. Verify the returned evidence in proportion to the task and incorporate it into the original answer or implementation.
7. Settle the worker only after its output has been consumed and no action remains.

The first version pulls results from JL1. Do not instruct a JL1 worker to reply directly to a manager thread in another T3 environment; a bare thread ID is not an environment-qualified address.

## Fail visibly

- If JL1 or the relay is unavailable, report the blocked dependency and preserve enough context to retry. Do not substitute local execution for an access-dependent operation.
- If SSO has expired, let the worker report the required login step. Resume the same thread after the user completes any interactive authentication.
- If project or provider discovery fails, report the missing configuration instead of inventing it.
- If the worker cannot prove what it read or changed, treat the result as incomplete.
