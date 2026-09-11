# JL1 Environment Setup

Use this reference when the manager cannot discover or reach the remote control plane. Never store pairing credentials, access tokens, relay URLs containing secrets, AWS credentials, or JLL account identifiers in the skill or dotfiles repository.

## Required topology

- The originating Mac has the `t3chief` executable on `PATH`.
- JL1 runs T3 Code and exposes that environment through its configured relay over HTTPS/WSS.
- The Mac's `t3chief` configuration contains a paired environment named exactly `jl1`.
- JL1 has at least one enabled, installed, authenticated T3 provider suitable for low-cost mechanical work.
- JL1 has a dedicated access project, or an existing T3 project that owns the target workspace, with a deliberately configured low-cost provider and model. Where practical, its AWS profile or role is technically read-only for automatic retrieval tasks.

The manager owns planning and synthesis. The provider process, VPN access, AWS SSO session, JLL SSO session, and access-dependent commands run on JL1.

## Verify the local CLI

```sh
command -v t3chief
t3chief --json environment list
```

If the executable is missing, install the `t3chief` control plane from its maintained repository before using this skill. Follow its current installation instructions rather than copying a stale build command into an agent prompt.

## Pair the JL1 relay environment

Obtain a fresh pairing credential from the JL1 T3 environment through an authorized channel. Add it through stdin so it does not enter shell history or process arguments:

```sh
printf '%s' "$PAIRING_CREDENTIAL" | \
  t3chief environment add jl1 \
    --url 'https://RELAY_HOST' \
    --pairing-stdin
```

The values above are placeholders. Do not commit the actual URL when it embeds a credential, and do not write the pairing credential to disk. Follow the relay's current connection instructions when its public URL format differs.

Validate the environment:

```sh
t3chief --json --environment jl1 doctor
t3chief --json --environment jl1 status
t3chief --json --environment jl1 project list
t3chief --json --environment jl1 providers
```

Use the provider instance IDs and model slugs returned by `providers`. Confirm that the access project's configured route still exists and is healthy. Do not infer identifiers or relative cost from product names.

## Recovery

### Relay or environment unavailable

Confirm JL1 is awake, T3 Code is running, and the relay reports a connected host. Retry `doctor` once after the connection is restored. Do not replace the remote target with the Mac for an access-dependent operation.

### Pairing expired or revoked

Create a fresh scoped pairing credential on JL1 and replace the environment configuration through the supported `t3chief` environment commands. Do not inspect or edit T3's SQLite state directly.

### AWS or JLL SSO expired

Have the worker run a read-only identity check. If it reports expired authentication, complete the interactive login on JL1, then continue the same T3 thread. Never transmit the SSO session or credentials to the Mac.

### No suitable project

List projects and select the dedicated access project or the project whose workspace owns the task. If neither exists, ask before registering or creating a workspace; do not park work in an unrelated project. Configure its intended low-cost provider and model explicitly, then verify that route against `providers`.

### No suitable provider

Use `providers` to distinguish disabled, missing, unavailable, or unauthenticated instances. Fix the provider on JL1 and re-run discovery. Do not silently route the task to a different account, model, or environment.
