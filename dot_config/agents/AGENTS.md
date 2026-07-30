# Shared agent context

Single source of truth for cross-agent instructions. Symlinked into Claude Code,
Codex, Gemini, opencode, and Cursor so every agent — on every machine — shares the
same operating philosophy. Edit here; it propagates everywhere via chezmoi.

# Model orchestration

Use Fable as the primary orchestrator for high-taste, high-judgment work.

Use Codex/GPT-5.5 via CLI for cheap, high-volume, mechanical, or computer-use-heavy work:
- log inspection
- large specs/PDFs
- browser/app verification
- screenshots
- simulator work
- bounded implementations
- independent reviews

Definitions:
- Intelligence: ability to solve hard problems unsupervised.
- Taste: UI/UX, API design, code quality, copy, and product judgment.
- Cost: relative usage/cost impact.

These are defaults, not limits. If a cheaper model's output does not meet the bar, rerun or redo the work with a smarter model without asking. Judge the output, not the price tag.

Cost should not block using the right model. Use cheaper models to gather information and explore before escalating.

## Codex Delegation

If computer use, browser automation, simulator work, screenshots, app launching, or runtime verification would help complete or verify work, shell out to Codex/GPT-5.5.

For read-only investigations, use:

    codex exec -s read-only "<self-contained prompt>"

Use Codex for:
- independent review
- bounded implementation in a worktree
- local app verification
- computer use
- large-context investigation

When Codex finds no issues, say so clearly and state exactly what target was inspected.

Verify important Codex claims against the code before presenting them.
