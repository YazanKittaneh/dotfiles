# JLLMac Environment Setup

Use this reference when the manager cannot discover or reach the remote control plane. Never store pairing credentials, access tokens, relay URLs containing secrets, AWS credentials, or JLL account identifiers in the skill or dotfiles repository.

## Required topology

- JLLMac runs T3 Code and exposes that environment through its configured relay over HTTPS/WSS.
- The originating Mac has either a connected T3 Desktop **Remote link** to JLLMac or a healthy, separately paired `t3chief` environment named exactly `JLLMac`.
- JLLMac has at least one enabled, installed, authenticated T3 provider suitable for low-cost mechanical work.
- JLLMac has a dedicated access project, or an existing T3 project that owns the target workspace, with a deliberately configured low-cost provider and model. Where practical, its AWS profile or role is technically read-only for automatic retrieval tasks.

The manager owns planning and synthesis. The provider process, VPN access, AWS SSO session, JLL SSO session, and access-dependent commands run on JLLMac.

## Configure T3 Desktop Remote link

Use T3 Desktop's **Settings → Connections → Add environment → Remote link** flow with the direct relay backend and a fresh pairing code or full pairing URL. This is not T3 Connect. Keep the credential in Desktop's protected connection catalog and never store it in the skill, dotfiles, shell history, or an agent transcript.

After pairing:

- confirm the remote environment is Connected;
- confirm a known project composer shows that environment;
- run a bounded read-only worker that reports `scutil --get ComputerName` and `hostname`;
- match the result to JLLMac's approved physical identity before using corporate access.

The currently verified physical identity is `USJLLADEVP25H2R1`. Treat it as runtime evidence that must be rechecked, not as a credential or a permanent network address.

## Configure optional headless control

Desktop connection state does not configure `t3chief`. Use this independent path when unattended thread management, scheduling, or typed CLI control is required.

Verify the local CLI:

```sh
command -v t3chief
t3chief --json environment list
```

If the executable is missing, install the `t3chief` control plane from its maintained repository. Follow its current installation instructions rather than copying a stale build command into an agent prompt.

Obtain a fresh pairing credential for this client from the JLLMac T3 environment through an authorized channel. Do not inspect, decrypt, copy, or reuse Desktop's encrypted connection catalog. Add the new credential through stdin so it does not enter shell history or process arguments:

```sh
printf '%s' "$PAIRING_CREDENTIAL" | \
  t3chief environment add JLLMac \
    --url 'https://RELAY_HOST' \
    --pairing-stdin
```

The values above are placeholders. Do not commit the actual URL when it embeds a credential, and do not write the pairing credential to disk. Follow the relay's current connection instructions when its public URL format differs.

Validate the environment:

```sh
t3chief --json --environment JLLMac doctor
t3chief --json --environment JLLMac status
t3chief --json --environment JLLMac project list
t3chief --json --environment JLLMac providers
```

Use the provider instance IDs and model slugs returned by `providers`. Confirm that the access project's configured route still exists and is healthy. Do not infer identifiers or relative cost from product names.

## Recovery

### Relay or environment unavailable

Confirm JLLMac is awake, T3 Code is running, and the relay reports a connected host. For Desktop, confirm the Remote link is Connected and the selected project resolves to the verified physical environment. For `t3chief`, retry `doctor` once after the connection is restored. Do not replace the remote target with the originating machine for an access-dependent operation.

### Pairing expired or revoked

Create a fresh scoped pairing credential on JLLMac and replace the affected Desktop Remote link or `t3chief` environment through its supported pairing flow. Do not inspect or edit T3's protected catalog or SQLite state directly.

### AWS or JLL SSO expired

Have the worker run a read-only identity check against the requested service. If it reports expired authentication, complete the interactive login on JLLMac, then continue the same T3 thread. Never transmit the SSO session or credentials to the originating machine. Do not treat `scutil --nc list` alone as proof of corporate connectivity because network-extension VPNs may not appear there.

### No suitable project

List projects and select the dedicated access project or the project whose workspace owns the task. If neither exists, ask before registering or creating a workspace; do not park work in an unrelated project. Configure its intended low-cost provider and model explicitly, then verify that route against `providers`.

### No suitable provider

Use the live Desktop choices or `t3chief providers` to distinguish disabled, missing, unavailable, or unauthenticated instances. A missing preferred provider is a configuration gap but need not block an adequate verified alternative. If no adequate provider exists, fix the provider on JLLMac and re-run discovery. Do not silently route the task to a different account, model, or environment.
