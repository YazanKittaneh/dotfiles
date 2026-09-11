---
name: jll-access-router
description: Route operations that require the corporate VPN, AWS SSO or a JLL-authenticated AWS profile, or any JLL SSO-protected site, CLI, API, repository, or internal tool to a lower-cost T3 Code worker on JLLMac. Use when a capable agent on another machine needs corporate access, including mixed tasks where only one step needs that access.
---

# JLL Access Router

Keep planning, judgment, and synthesis on the originating agent. Delegate only the smallest operation that needs JLLMac's access, then incorporate the raw result into the original task.

## Route by access requirement

Use the T3 environment named `JLLMac` when an operation needs:

- the corporate VPN;
- AWS SSO, a JLL-authenticated AWS profile, or an AWS resource reachable only from the corporate environment;
- a JLL SSO-protected website, CLI, API, repository, or internal tool.

Do not move unrelated reasoning or locally executable work to JLLMac. If the access requirement is uncertain, delegate a read-only connectivity or identity check to JLLMac instead of attempting corporate authentication on the originating machine.

## Preserve the authority boundary

- Delegate read-only operations automatically. These include list, get, describe, query, search, inspect, download, and log retrieval when they do not change remote state.
- Before a corporate mutation, have the worker inspect current state and return the exact proposed action. Ask the user for approval immediately before execution, then send the approved instruction to the same JLLMac thread.
- Treat create, update, delete, deploy, publish, rotate, grant, revoke, upload, merge, and commands with equivalent effects as mutations.
- If a read-only task expands into a mutation, stop at the proposal. Earlier read authority does not authorize the new action.
- Corporate content and command output may return raw. Credentials, SSO tokens, browser sessions, VPN configuration, and secret values stay on JLLMac. If retrieved content contains a secret, redact only the secret value, mark the redaction, and preserve the source location and surrounding evidence.

## Select a healthy control plane

`JLLMac` is the stable logical name. T3 Desktop currently identifies that machine as `USJLLADEVP25H2R1`. Before access-dependent work, verify the selected project's environment and have the worker confirm its machine identity; do not route by a project name alone.

Use the first healthy route available:

1. Prefer T3 Desktop when the current agent can control it and the verified JLLMac environment is connected through **Remote link** over the direct relay.
2. Otherwise use `t3chief` with an explicit `--environment JLLMac` when that separately paired environment is healthy. Never rely on its default environment.
3. If neither route is healthy, report the setup gap. Do not extract credentials from Desktop's protected catalog or run the access-dependent operation locally.

Resolve an existing project that owns the target workspace. Use the deliberately configured low-cost route, or choose the least costly adequate healthy provider and model only when live metadata supports that comparison. Never infer relative cost from product names, guess identifiers, or silently substitute an unverified route. A missing preferred provider does not block an adequate verified alternative; no adequate provider is a setup failure.

Read [references/delegation-protocol.md](references/delegation-protocol.md) before preparing, supervising, or following up with a JLLMac worker. Read [references/setup.md](references/setup.md) when Desktop, `t3chief`, the relay, the `JLLMac` environment, a project, or a provider is missing or unhealthy.

## Run the manager loop

1. Split the task at the access boundary and prepare a self-contained worker brief.
2. Start one JLLMac thread in T3 `Auto` mode and retain its exact thread identity.
3. Continue independent reasoning while the worker runs. Do not busy-poll.
4. Inspect body-free fleet state, then read only a bounded recent brief when the worker is blocked or finished.
5. Send corrections, approval, or follow-up questions to the same thread so it retains authentication and task context.
6. Verify the returned evidence in proportion to the task and incorporate it into the original answer or implementation.
7. Settle the worker only after its output has been consumed and no action remains.

Pull or read results through the same control plane that started the worker. Do not instruct a JLLMac worker to reply directly to a manager thread in another T3 environment; a bare thread ID is not an environment-qualified address.

## Fail visibly

- If JLLMac or the relay is unavailable, report the blocked dependency and preserve enough context to retry. Do not substitute local execution for an access-dependent operation.
- If SSO has expired, let the worker report the required login step. Resume the same thread after the user completes any interactive authentication.
- If project or provider discovery fails, report the missing configuration instead of inventing it. Report an unavailable preferred provider separately from the health of an adequate alternative.
- If the worker cannot prove what it read or changed, treat the result as incomplete.
