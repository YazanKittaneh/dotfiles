# JLL Access Router Skill Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add and install a shared skill that routes VPN-, AWS SSO-, and JLL SSO-dependent operations from a high-capability Mac manager to a lower-cost JL1 T3 Code worker through the relay.

**Architecture:** Keep automatic routing and authority boundaries concise in `SKILL.md`, with detailed worker contracts and machine setup in two references. Use `t3chief` as the external control plane, select the `jl1` environment explicitly, pull bounded worker results back to the Mac, and preserve user approval immediately before corporate mutations.

**Tech Stack:** Markdown skill package, Codex skill metadata, chezmoi, T3 Code relay, `t3chief`, Git

---

### Task 1: Initialize the shared skill package

**Files:**
- Create: `dot_agents/skills/jll-access-router/SKILL.md`
- Create: `dot_agents/skills/jll-access-router/agents/openai.yaml`
- Create: `dot_agents/skills/jll-access-router/references/`

**Step 1: Initialize the skeleton**

Run:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/init_skill.py \
  jll-access-router \
  --path dot_agents/skills \
  --resources references \
  --interface 'display_name=JLL Access Router' \
  --interface 'short_description=Route corporate access tasks through JL1' \
  --interface 'default_prompt=Use $jll-access-router to complete this task, delegating any VPN, AWS SSO, or JLL SSO operations to JL1.'
```

Expected: the command creates `SKILL.md`, `agents/openai.yaml`, and `references/` without modifying existing skills.

**Step 2: Inspect the generated files**

Run:

```bash
find dot_agents/skills/jll-access-router -maxdepth 3 -type f -print
```

Expected: `SKILL.md` and `agents/openai.yaml` exist.

### Task 2: Write the manager workflow and references

**Files:**
- Modify: `dot_agents/skills/jll-access-router/SKILL.md`
- Create: `dot_agents/skills/jll-access-router/references/delegation-protocol.md`
- Create: `dot_agents/skills/jll-access-router/references/setup.md`

**Step 1: Replace the generated entrypoint**

Write frontmatter containing `name` and a discriminating `description`. Trigger on operations requiring the corporate VPN, AWS SSO, a JLL-authenticated AWS profile, or any JLL SSO-protected resource.

Require this manager behavior:

1. Keep planning and synthesis on the originating Mac agent.
2. Route the smallest access-dependent operation to the `jl1` T3 environment.
3. Run `doctor`, `project list`, and `providers` before selecting remote targets or routes.
4. Permit automatic read-only delegation.
5. For mutations, collect an exact proposal, request user approval, then resume the same JL1 thread.
6. Pull status and bounded results from the remote thread.
7. Report remote failures instead of silently substituting local execution.

Link `delegation-protocol.md` when preparing or supervising a worker and `setup.md` when the CLI, relay, or environment is unavailable.

**Step 2: Write the delegation protocol**

Document:

- read-only and mutating operation classifications;
- the worker brief fields: goal, operation, target, authority, constraints, evidence, and completion schema;
- the result fields: status, raw findings, evidence, proposed mutations, and open questions;
- starting, monitoring, reading, and following up with a JL1 thread using environment-qualified `t3chief` commands;
- retaining the thread ID and using the same worker for authentication-dependent follow-ups;
- approval handling when an apparently read-only task expands into a mutation.

**Step 3: Write the setup reference**

Document prerequisites without embedding credentials:

- `t3chief` installed on the Mac manager;
- JL1 running T3 Code with a relay-reachable HTTPS/WSS endpoint;
- a paired `t3chief` environment named `jl1`;
- an inexpensive authenticated provider on JL1;
- `doctor`, `status`, `project list`, and `providers` verification commands;
- recovery for expired pairing, unavailable relay, expired SSO, and missing provider configuration.

### Task 3: Validate and review the source package

**Files:**
- Validate: `dot_agents/skills/jll-access-router/`

**Step 1: Run structural validation**

Run:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py \
  dot_agents/skills/jll-access-router
```

Expected: validation succeeds.

**Step 2: Check for secrets and machine-specific credentials**

Run:

```bash
rg -n -i '(bearer|access[_-]?token|secret[_-]?key|password|pairing.*credential|https?://[^ ]+@)' \
  dot_agents/skills/jll-access-router
```

Expected: only explanatory warnings or field names appear; no credential values, relay URL, or account identifiers are present.

**Step 3: Inspect formatting and content**

Run:

```bash
git diff --check
git diff -- dot_agents/skills/jll-access-router
```

Expected: no whitespace errors and only intended skill content.

### Task 4: Commit and install the skill

**Files:**
- Commit: `docs/plans/2026-09-10-jll-access-router.md`
- Commit: `dot_agents/skills/jll-access-router/`
- Install: `~/.agents/skills/jll-access-router/`

**Step 1: Commit only the implementation plan and skill package**

Run:

```bash
git add docs/plans/2026-09-10-jll-access-router.md \
  dot_agents/skills/jll-access-router
git commit -m "feat: add JLL access router skill"
```

Expected: the pre-existing `dot_profile` and `dot_agents/dot_skill-lock.json` modifications remain outside the commit.

**Step 2: Preview the targeted chezmoi application**

Run:

```bash
chezmoi diff ~/.agents/skills/jll-access-router
```

Expected: only the new skill package is proposed.

**Step 3: Apply only the new skill**

Run:

```bash
chezmoi apply ~/.agents/skills/jll-access-router
```

Expected: the package is installed under `~/.agents/skills/jll-access-router/`.

**Step 4: Compare source and installed content**

Run:

```bash
diff -ru \
  ~/.local/share/chezmoi/dot_agents/skills/jll-access-router \
  ~/.agents/skills/jll-access-router
```

Expected: no differences.

### Task 5: Verify control-plane readiness

**Files:**
- No repository changes expected

**Step 1: Check CLI discovery**

Run:

```bash
command -v t3chief
```

Expected: an executable path, or a clearly reported pending prerequisite.

**Step 2: Check configured environments without exposing credentials**

Run:

```bash
t3chief --json environment list
t3chief --environment jl1 --json doctor
```

Expected: `jl1` is listed and reachable, or setup remains explicitly pending.

**Step 3: Check the remote fleet and provider catalog**

Run:

```bash
t3chief --environment jl1 --json status
t3chief --environment jl1 --json project list
t3chief --environment jl1 --json providers
```

Expected: bounded fleet state, available projects, and live provider/model identifiers. Do not start a corporate worker merely to test the skill.

**Step 4: Verify final repository state**

Run:

```bash
git status --short --branch
```

Expected: only the two pre-existing unrelated modifications remain uncommitted.
