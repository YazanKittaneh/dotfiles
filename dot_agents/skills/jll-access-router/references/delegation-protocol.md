# JLLMac Delegation Protocol

Use this protocol to create a bounded T3 Code worker on JLLMac, retrieve its result, and continue the originating task without moving the manager's full conversation.

## Classify the operation

Read-only operations may run automatically when they do not change corporate or AWS state. Examples include:

- `aws sts get-caller-identity`;
- AWS `list-*`, `get-*`, and `describe-*` calls;
- CloudWatch log retrieval and read-only queries;
- reading JLL internal sites, APIs, repositories, tickets, or documentation;
- downloading an existing artifact for inspection.

Treat an operation as mutating when it creates, changes, or removes state, even if the tool uses an unusual verb. Examples include:

- AWS create, update, put, delete, start, stop, invoke, deploy, publish, attach, detach, tag, and permission changes, except read-only asynchronous query-job APIs described below;
- uploading files, editing tickets or documents, sending messages, merging code, or triggering a production workflow;
- commands that combine a read with a possible write or use flags such as `--force` or `--apply`.

Read-only asynchronous query jobs such as CloudWatch Logs Insights `start-query` and `get-query-results` do not mutate the queried resource. They may run automatically when the query, time window, result limit, and target log groups are bounded. Let a query complete normally; use `stop-query` only for an authorized timeout or cleanup because it changes the ephemeral query-job state. Do not generalize this exception to compute jobs, deployments, workflows, or service operations merely because they return results.

A worker may check its current identity automatically. If authentication has expired, return `blocked` with the exact non-secret login step the user must complete on JLLMac. Initiate `aws sso login` only when the user's instructions permit refreshing local authentication state; a strict “do not change anything” request does not.

## Resolve AWS targets without guessing

Before querying AWS, verify the selected profile and identity with a read-only call such as `aws sts get-caller-identity`. Match the returned account ID and principal to an expected target supplied by the user, established project context, or JLLMac's approved local configuration. Resolve the region, service, resource, and log groups through explicit context or bounded read-only discovery.

If more than one account, profile, region, service, or resource plausibly matches, return `blocked` with the candidates. Do not choose a production target from naming conventions alone.

Verify the capability the task actually needs. `scutil --nc list` detects traditional macOS VPN services but may miss corporate network extensions, so its output alone neither proves nor disproves corporate connectivity. For AWS, pair identity verification with a bounded read against the requested service when needed. For an internal site, CLI, API, repository, or tool, use a read-only reachability or identity check against that target.

## Build the worker brief

Pass a self-contained prompt by file or stdin. Do not paste the manager's full transcript. Include this information:

```yaml
goal: "The concrete result the manager needs"
why: "How the result will be used"
operation: "The exact lookup or proposed action"
target: "Account, region, service, URL, repository, or other target"
authority: "read-only | inspect-and-propose | approved-mutation"
constraints:
  - "Explicit boundaries and prohibited side effects"
evidence:
  - "Required commands, source URLs, UTC bounds, IDs, or output"
result_limits:
  max_rows: "A task-appropriate cap"
  max_bytes: "A task-appropriate cap"
  sampling: "Aggregation or sampling rule for large results"
completion:
  status: "complete | blocked | approval-required"
  result: "Raw findings"
  evidence: "Inspectable support for the result"
  proposed_mutations: "Exact commands or changes, or none"
  open_questions: "Unresolved decisions, or none"
```

Tell the worker not to expose credentials, tokens, cookies, browser-session material, or secret values. Raw non-secret corporate content is allowed. When source data contains a secret, replace only its value with `[REDACTED SECRET]` and retain the timestamp, source identifier, and non-secret surrounding context. Do not silently omit evidence.

Evaluate relative time windows before dispatch. For “the last hour,” include the exact UTC start and end, the evaluation time, account ID, region, resource or log groups, query text, result limits, and required query/result IDs. Prefer aggregation first and request a bounded sample only when individual records are needed.

## Choose the remote route

Use `JLLMac` as the logical name. The currently verified physical environment is `USJLLADEVP25H2R1`; confirm that identity before each access-dependent task because machine labels and connections can change. Prefer the product-native Desktop route when it is available, and use the independently paired `t3chief` route for unattended or headless operation.

### T3 Desktop Remote link

In T3 Desktop, confirm that the physical JLLMac environment is connected through **Remote link**, not merely that a similarly named project exists. Select the project whose workspace owns the task and verify that the composer shows the expected physical environment before sending the brief.

- Use **Current checkout** for read-only retrieval.
- Use a new worktree only for an authorized repository change.
- Inspect the live provider choices and use the deliberately configured low-cost route. Compare alternatives by cost only when live metadata supports it; do not infer relative cost from product names or hard-code a provider from a past test. If a preferred provider is unavailable, report why and use a verified adequate alternative when one exists.
- Set runtime mode to **Auto**, never Full access, for automatically delegated corporate work.
- Send the bounded brief, retain the resulting thread identity, monitor without repeatedly opening full message bodies, read the result, and follow up in the same thread when its context matters.

Desktop keeps its connection credential in a protected catalog. Never inspect, decrypt, copy, or reuse that credential to configure another client.

### Headless `t3chief`

The `t3chief` environment is independent of Desktop. Before starting a headless worker, run:

```sh
t3chief --json --environment JLLMac doctor
t3chief --json --environment JLLMac project list
t3chief --json --environment JLLMac providers
```

Discover the project, provider instance, and model first. Use a deliberately configured low-cost route and verify its exact provider instance and model in the live catalog. If no adequate route is configured, stop rather than estimating cost or choosing a model by name. Then start the thread with those exact values:

```sh
t3chief --json --environment JLLMac thread start \
  --project PROJECT_ID \
  --title 'Concrete access task' \
  --provider PROVIDER_INSTANCE \
  --model MODEL_SLUG \
  --runtime-mode auto \
  --prompt-file /tmp/jllmac-worker-brief.md
```

The dedicated access worker uses T3's `auto` runtime mode: routine operations proceed while provider-classified risky actions request approval. Providers without an equivalent may fall back to supervised approvals. Never use `full-access` for an automatic corporate-access worker. Where available, also use a technically read-only AWS role or profile for read-only tasks. Do not use `--reply-to` for a manager hosted by a different T3 environment. Record the returned thread ID; titles are not unique identifiers.

If a provider pauses for an approval, inspect the exact request. Approve only a read-only operation already authorized by the brief; present any mutation to the user first.

Use `--worktree --base-branch BRANCH` only when the worker will modify a repository and the user has authorized that work. An information-retrieval thread does not need a worktree.

## Monitor without flooding context

For Desktop, inspect the target thread's state in the sidebar and open its bounded result only after it is blocked, failed, or complete. For `t3chief`, inspect fleet state without loading message bodies:

```sh
t3chief --json --environment JLLMac status
```

When the target thread is blocked, failed, or complete, retrieve a bounded view:

```sh
t3chief --json --environment JLLMac brief THREAD_ID --turns 10
```

Increase the turn window only when the decision requires older context. Do not repeatedly fetch a full transcript or run a tight polling loop.

## Handle approval-gated writes

For an unapproved mutation, the worker must stop after inspecting current state and return:

- the exact target and current state;
- the exact command, API call, or edit it proposes;
- expected effects and a verification command;
- any meaningful rollback or recovery step.

Present that proposal to the user. After approval, continue the same Desktop thread, or send a narrow `t3chief` continuation to the same headless thread:

```sh
t3chief --json --environment JLLMac thread send THREAD_ID \
  --prompt-file /tmp/jllmac-approved-action.md
```

The continuation must identify the approved action and require post-change evidence. Approval for one action does not authorize adjacent cleanup, deployment, or permission changes.

## Consume and close

Check that the result addresses the requested goal and includes the required evidence. Incorporate raw findings into the manager's reasoning without claiming stronger certainty than the evidence supports.

Follow up in the same thread when authentication state, working directory, or prior inspection matters. Start a new thread when the target or authority boundary changes materially.

Settle only after the manager has consumed the outcome and the worker has no pending approval, interaction, or background work. Settle the specific Desktop thread directly. For headless bulk settlement, preview the candidates:

```sh
t3chief --json --environment JLLMac settle-ready
```

Review the dry-run output before applying any bulk settlement.
