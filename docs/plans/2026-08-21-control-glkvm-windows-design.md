# Control GLKVM Windows Skill Design

## Goal

Create a shared agent skill that preserves the reliable workflow learned while controlling a Windows machine through GLKVM in Vivaldi and supervising a terminal-based coding agent. Include a scoped handoff for resuming the Florida Exchange testing-suite work.

## Location and distribution

Store the canonical skill at `dot_agents/skills/control-glkvm-windows/` in the active chezmoi source repository. `chezmoi apply` will install it at `~/.agents/skills/control-glkvm-windows/`, where the shared agent skill hub can expose it to Codex and other compatible agents.

Do not modify the legacy `~/dotfiles` checkout. Its `macos` branch predates the active, single-branch chezmoi layout in `~/.local/share/chezmoi`.

## Structure

- `SKILL.md`: short, imperative workflow covering connection, state verification, safe remote control, terminal-agent supervision, and completion checks.
- `agents/openai.yaml`: human-facing discovery metadata generated from the skill.
- `references/glkvm-runbook.md`: exact tested GLKVM/Vivaldi settings, Computer Use mechanics, pointer-lock failure modes, recovery steps, and Docker verification commands.
- `references/terminal-agent-orchestration.md`: reusable protocol for questioning, approving, monitoring, and verifying a terminal coding agent without blindly approving risky operations.
- `references/florida-exchange-handoff.md`: session-specific testing scope, live service state, coverage decisions, and next actions.

No scripts or assets are needed. The work is procedural, and commands remain short enough to document directly.

## Skill behavior

Trigger the skill when an agent must connect to or operate the known GLKVM-hosted Windows computer, use Vivaldi as the KVM client, recover mouse or keyboard control, manage local Docker services, supervise Claude Code or another terminal coding agent, or resume the Florida Exchange testing-suite exercise.

Before every UI action, refresh application state and verify the active Vivaldi window is the dedicated GLKVM window. Prefer keyboard input after the remote canvas has focus. Recommend absolute mouse mode, a visible local cursor, a fitted/scaled view, and the virtual keyboard. Treat browser focus changes and relative-pointer scaling as hazards.

Ask the user or session context for credentials at runtime. Never write the GLKVM password, tokens, or other secrets into the skill or repository.

## Safety and error handling

- Use a dedicated Vivaldi window and advise the user to use another browser while the agent controls Vivaldi.
- Re-query state after any user-driven window change or stale-state error.
- Verify the title and visible remote screen before typing or clicking.
- Review approval prompts even when routine approvals are authorized; do not approve destructive, credential, publishing, or security-sensitive operations without appropriate authority.
- Prefer reversible inspections before changes and verify remote effects with terminal output or visible UI state.
- Stop and request help if the TLS interstitial requires a manual bypass or required credentials are unavailable.

## Validation

Run the skill creator's `quick_validate.py` against the source skill. Run `chezmoi diff` for the installed target, apply only the new skill paths, and verify that the installed `~/.agents/skills/control-glkvm-windows/` files match the source. Confirm repository searches find no plaintext password or token.

Forward-testing with another agent is optional and excluded from this iteration because the current task is a factual handoff distilled from a completed live exercise, and the user did not request delegated validation.
