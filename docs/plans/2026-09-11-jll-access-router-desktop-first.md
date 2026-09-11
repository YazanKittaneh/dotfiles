# Desktop-First JLL Access Router Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make the JLL access router use the working T3 Desktop direct-relay connection first while retaining `t3chief` for headless operation.

**Architecture:** Add explicit control-plane capability detection to `SKILL.md`, with Desktop lifecycle details in the delegation protocol and separate Desktop/headless pairing guidance in setup. Keep JLLMac as the logical alias, verify the physical environment identity at runtime, select an adequate healthy low-cost provider, and validate access against the requested service rather than a single VPN indicator.

**Tech Stack:** Codex skills (Markdown/YAML), T3 Desktop Remote link, `t3chief`, chezmoi, Git

---

### Task 1: Add Desktop-first routing decisions

**Files:**
- Modify: `dot_agents/skills/jll-access-router/SKILL.md`

**Step 1: Record the current failure**

Run:

```bash
rg -n "Use `t3chief`|T3 Desktop|USJLLADEVP25H2R1" dot_agents/skills/jll-access-router/SKILL.md
```

Expected: the skill mandates `t3chief` and contains no Desktop route or physical identity mapping.

**Step 2: Implement the routing decision**

Replace the single-control-plane rule with these invariants:

- logical environment name is `JLLMac`;
- current verified physical identity is `USJLLADEVP25H2R1`;
- prefer a healthy product-native T3 Desktop Remote link when available;
- otherwise use a healthy, separately paired `t3chief --environment JLLMac` route;
- never extract Desktop credentials or silently run the access-dependent operation locally.

Keep authority and content boundaries unchanged.

**Step 3: Verify the entrypoint remains concise**

Run:

```bash
wc -l dot_agents/skills/jll-access-router/SKILL.md
rg -n "Desktop|t3chief|Auto|JLLMac|USJLLADEVP25H2R1" dot_agents/skills/jll-access-router/SKILL.md
```

Expected: both routes and their selection criteria are discoverable without duplicating detailed mechanics.

### Task 2: Document the Desktop worker lifecycle

**Files:**
- Modify: `dot_agents/skills/jll-access-router/references/delegation-protocol.md`

**Step 1: Add the Desktop path**

Document how to:

- confirm the selected project is hosted on the verified JLLMac environment;
- use Current checkout for read-only work and a worktree only for authorized repository changes;
- choose the least costly adequate healthy provider from live choices;
- use Auto runtime mode;
- send a bounded worker brief, consume the result, follow up in the same thread, and settle it.

**Step 2: Preserve the headless path**

Keep the existing environment-qualified `t3chief` commands as the unattended route and clarify that its environment configuration is independent of Desktop.

**Step 3: Correct access verification**

State that `scutil --nc list` is only one signal and may miss corporate network extensions. Require a read-only check against the actual requested service, such as AWS identity plus a bounded service lookup.

**Step 4: Inspect for accidental permanent state assumptions**

Run:

```bash
rg -n "Sonnet|Codex|PATH|scutil|Remote link|t3chief" dot_agents/skills/jll-access-router/references/delegation-protocol.md
```

Expected: live observations are decision examples, not hard-coded provider requirements.

### Task 3: Split Desktop and headless setup guidance

**Files:**
- Modify: `dot_agents/skills/jll-access-router/references/setup.md`

**Step 1: Document Desktop Remote link setup**

Identify the user-facing connection as T3 Desktop **Remote link** over the direct relay, explicitly distinguishing it from T3 Connect. Require protected Desktop credential storage and runtime identity verification.

**Step 2: Retain independent `t3chief` pairing**

Explain that Desktop connection state does not automatically configure `t3chief`; a fresh scoped pairing credential is required for unattended operation. Prohibit reading or copying Desktop's encrypted catalog.

**Step 3: Add provider and VPN diagnostics**

Document that a missing preferred provider is non-blocking when an adequate verified alternative exists, while no adequate provider remains a setup failure. Replace generic VPN conclusions with target-specific connectivity checks.

### Task 4: Validate, install, commit, and publish

**Files:**
- Verify: `dot_agents/skills/jll-access-router/**`
- Apply: `~/.agents/skills/jll-access-router/**`

**Step 1: Validate the skill**

Run:

```bash
uv run --with pyyaml python ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py dot_agents/skills/jll-access-router
```

Expected: `Skill is valid!`

**Step 2: Search for leaked live-test data**

Run searches for pairing tokens, URLs, the observed AWS account ID, principal ARN, and other credentials. Expected: none in the skill package.

**Step 3: Apply and compare**

Run:

```bash
chezmoi apply ~/.agents/skills/jll-access-router
diff -ru dot_agents/skills/jll-access-router ~/.agents/skills/jll-access-router
```

Expected: no diff.

**Step 4: Commit only router files and plans**

Preserve unrelated `dot_agents/dot_skill-lock.json` and `dot_profile` changes.

**Step 5: Push and verify**

Run:

```bash
git push origin main
git status --short --branch
```

Expected: `main` matches `origin/main`; only pre-existing unrelated working-tree changes remain.
