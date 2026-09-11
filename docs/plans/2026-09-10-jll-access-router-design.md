# JLL Access Router Skill Design

## Goal

Create a shared agent skill that lets a high-capability manager on the Mac delegate operations requiring the corporate VPN, AWS SSO, or JLL SSO to a lower-cost T3 Code worker running on JL1. The JL1 worker may return raw corporate content. Read-only operations run automatically; corporate mutations require user approval.

## Location and distribution

Store the canonical skill at `dot_agents/skills/jll-access-router/` in the active chezmoi source repository. `chezmoi apply` installs it at `~/.agents/skills/jll-access-router/`, where compatible agents can discover it through the shared skill hub.

The manager-side skill is the only required skill. JL1 needs a reachable T3 Code environment through the relay and an inexpensive provider configured to execute delegated work. Worker behavior is supplied in each thread brief, so the first version does not require a companion skill on JL1.

## Control plane

Use the standalone `t3chief` CLI as the typed control plane. Configure the JL1 T3 environment under the stable name `jl1`. The skill must verify the environment, project, and live provider catalog instead of hard-coding project IDs, provider instance IDs, model slugs, or credentials.

The first version uses a pull-based result flow:

1. The Mac manager starts a scoped worker thread with `t3chief --environment jl1 thread start`.
2. The manager retains the returned thread ID.
3. The manager inspects fleet state and reads bounded results with `status` and `brief`.
4. Follow-up instructions go to the same thread with `thread send`.

This avoids requiring the JL1 environment to address a manager thread hosted by a different T3 environment. Cross-environment push replies can be added later if the control plane gains an environment-qualified reply address.

## Routing policy

Route an operation to JL1 whenever it requires any of these capabilities:

- the corporate VPN;
- AWS SSO, an AWS profile authenticated through JLL SSO, or AWS resources reachable only from the corporate environment;
- a JLL SSO-protected website, CLI, API, repository, or internal tool.

Keep general reasoning, planning, and synthesis on the Mac. Delegate the smallest useful operation rather than the manager's full conversation. When access requirements are uncertain, perform a read-only connectivity or identity check on JL1 rather than attempting to authenticate from the Mac.

Discover the cheapest adequate live JL1 route from `t3chief providers` and available quota data. Do not silently substitute an unverified provider or model.

## Authority policy

The manager may automatically delegate read-only actions such as listing, describing, fetching, querying, searching, inspecting logs, and downloading evidence.

For create, update, delete, deploy, publish, rotate, grant, revoke, or other state-changing operations:

1. Ask the JL1 worker to inspect current state and prepare the exact proposed mutation.
2. Return the proposal to the Mac manager.
3. Ask the user for approval.
4. After approval, instruct the same JL1 thread to execute and verify the change.

Credentials, browser sessions, SSO tokens, and VPN configuration stay on JL1. Retrieved corporate content and command output may be returned to the Mac without redaction.

## Delegation contract

Each worker brief must include:

- goal and reason for the request;
- exact operation and target;
- explicit read-only or approval-gated authority;
- constraints and out-of-scope work;
- required evidence;
- a structured completion format.

Workers return a status (`complete`, `blocked`, or `approval-required`), raw findings, evidence, proposed mutations, and open questions. The manager verifies evidence in proportion to the task, incorporates the result, and settles the worker only after its output has been consumed.

## Failure handling

- If the relay or JL1 environment is unavailable, report the dependency and preserve the task for retry. Do not run an access-dependent substitute on the Mac.
- If SSO has expired, have the JL1 worker report the exact login requirement. Do not copy credentials into prompts or logs.
- If a worker is blocked on interactive authentication, surface the block to the user and resume the same thread after authentication.
- If a task changes from read-only to mutating, stop at the proposal and request approval.
- If provider or model discovery fails, report the live configuration problem rather than guessing identifiers.

## Structure

- `SKILL.md`: concise trigger, routing rules, authority policy, and manager loop.
- `agents/openai.yaml`: discovery metadata generated from the skill.
- `references/delegation-protocol.md`: worker brief and result schemas, classification examples, follow-up behavior, and failure handling.
- `references/setup.md`: prerequisites for `t3chief`, relay pairing, the `jl1` environment name, validation commands, and installation guidance without credentials.

No custom scripts are required for the first version. `t3chief` provides environment selection, thread lifecycle, bounded reads, and typed mutations.

## Validation

- Validate the source skill with the skill creator's `quick_validate.py`.
- Search the package for tokens, credentials, relay URLs, account identifiers, and machine-specific secrets.
- Run `chezmoi diff` for only the new skill path, apply that target, and compare source and installed files.
- Confirm another compatible agent can discover the skill from `~/.agents/skills/`.
- If `t3chief` or the `jl1` environment is not configured, leave setup in a clearly reported pending state rather than fabricating a successful remote test.
