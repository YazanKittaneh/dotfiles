# JLL Access Router: Desktop-First Hybrid Design

## Goal

Route VPN-, AWS SSO-, and JLL SSO-dependent work to the corporate Mac through the direct relay connection that is already usable in T3 Desktop, while retaining `t3chief` as the unattended control plane when separately paired.

## Environment identity

`JLLMac` is the stable logical name used by agents and documentation. T3 Desktop currently reports that machine as `USJLLADEVP25H2R1`. A worker must verify its machine identity before access-dependent work; the physical hostname is evidence, not a replacement for the stable alias and must not be treated as a secret.

## Control-plane selection

Use the first healthy route available:

1. Prefer the product-native T3 Desktop route when the current agent can control Desktop and JLLMac is connected through a direct Remote link/relay.
2. Use `t3chief --environment JLLMac` when that separate headless environment is configured and healthy.
3. If neither route is healthy, report the setup dependency without attempting the operation locally.

The Desktop route is a real supported path, not a degraded test mode. The headless route remains valuable for unattended management, scheduling, and typed thread lifecycle operations.

## Desktop worker lifecycle

For the Desktop route, select a project whose workspace is explicitly hosted on the verified JLLMac environment. Use the current checkout for read-only work and create a worktree only for authorized repository changes. Choose T3 `Auto` runtime mode rather than Full access. Start a bounded thread, retain its identity, read its result, follow up in the same thread when context matters, and settle it only after consuming the result.

## Provider selection

Choose the least costly healthy provider/model that is adequate for the bounded operation from the choices actually available on JLLMac. Do not hard-code a provider or claim relative cost without supported evidence. A missing preferred provider is reported as a configuration gap but does not block an adequate verified alternative. During the initial live test, Claude Sonnet 5 was available while Codex was unavailable because its CLI was not on JLLMac's `PATH`; those observations are current-state evidence, not permanent routing rules.

## Access verification

Verify the capability needed by the task rather than relying on a generic VPN indicator. `scutil --nc list` detects traditional macOS VPN services but may miss corporate network extensions. For AWS work, validate the current principal with `aws sts get-caller-identity` and then perform a bounded read against the requested service when needed. For an internal site or tool, use a read-only reachability or identity check against that target. Never initiate authentication when the authority is strictly read-only.

## Authority and content boundaries

Read-only operations may be delegated automatically. Corporate mutations require an exact inspect-and-propose result followed by user approval immediately before execution. Raw non-secret corporate content may return to the manager. Credentials, SSO tokens, cookies, browser sessions, VPN configuration, and secret values remain on JLLMac.

## Setup guidance

Document the Desktop connection as **Remote link** using the user's direct relay, not T3 Connect. Keep Desktop credentials in its protected connection catalog. Configure `t3chief` independently with a fresh scoped pairing credential when unattended operation is desired; never extract or copy credentials from Desktop's encrypted catalog.

## Validation

- Validate the skill package with the bundled skill validator.
- Confirm the installed chezmoi target matches the source.
- Search the package for credentials, pairing URLs, tokens, AWS account identifiers, and other test-specific sensitive values.
- Confirm both control paths have explicit health checks and visible failure behavior.
- Retain the live smoke-test evidence only as generalized behavior; do not commit its account ID, principal ARN, pairing link, or credential.
