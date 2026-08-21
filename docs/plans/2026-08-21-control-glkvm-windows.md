# Control GLKVM Windows Skill Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add and install a validated shared skill that teaches future agents to control the GLKVM-hosted Windows machine and resume the Florida Exchange testing-suite work safely.

**Architecture:** Keep the triggering workflow concise in `SKILL.md` and move detailed operating knowledge into three directly linked reference files. Manage the canonical source with chezmoi under `dot_agents/skills`, then apply it into the shared `~/.agents/skills` hub.

**Tech Stack:** Markdown skill package, Codex skill metadata, chezmoi, Git

---

### Task 1: Initialize the shared skill

**Files:**
- Create: `dot_agents/skills/control-glkvm-windows/SKILL.md`
- Create: `dot_agents/skills/control-glkvm-windows/agents/openai.yaml`
- Create: `dot_agents/skills/control-glkvm-windows/references/`

**Step 1: Read the OpenAI interface metadata rules**

Read the complete `references/openai_yaml.md` file shipped with the `skill-creator` skill.

**Step 2: Initialize the skill skeleton**

Run:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/init_skill.py \
  control-glkvm-windows \
  --path dot_agents/skills \
  --resources references \
  --interface 'display_name=Control GLKVM Windows' \
  --interface 'short_description=Operate GLKVM Windows and supervise its coding agent' \
  --interface 'default_prompt=Use $control-glkvm-windows to connect to the GLKVM Windows computer, control it safely, and supervise the terminal coding agent.'
```

Expected: the skill skeleton and `agents/openai.yaml` are created without errors.

**Step 3: Inspect the generated files**

Run:

```bash
find dot_agents/skills/control-glkvm-windows -maxdepth 3 -type f -print
```

Expected: `SKILL.md` and `agents/openai.yaml` exist; `references/` is empty.

### Task 2: Write the reusable operating workflow

**Files:**
- Modify: `dot_agents/skills/control-glkvm-windows/SKILL.md`
- Create: `dot_agents/skills/control-glkvm-windows/references/glkvm-runbook.md`
- Create: `dot_agents/skills/control-glkvm-windows/references/terminal-agent-orchestration.md`

**Step 1: Replace the generated SKILL.md**

Write frontmatter containing only `name` and `description`. Make the description trigger on GLKVM Windows control, Vivaldi remote-KVM operation, Docker recovery, terminal coding-agent supervision, and continuation of the Florida Exchange test-suite exercise.

In the body, require this sequence:

1. Load only the reference relevant to the current request.
2. Obtain credentials from the user or current secure session.
3. Establish a dedicated Vivaldi GLKVM window.
4. Refresh application state before every UI action and verify the window title.
5. Prefer keyboard input after focusing the remote canvas.
6. Inspect before changing remote state.
7. Supervise terminal agents through small prompts, reviewed approvals, and direct verification.
8. Report the final remote state, evidence, and unresolved risks.

**Step 2: Write the GLKVM runbook**

Document the tested endpoint without credentials, Vivaldi bundle identifier, `@oai/sky` bootstrap, dedicated-window workflow, exact observed settings, recommended setting changes, pointer-lock behavior, stale-state recovery, Docker recovery commands, and verification evidence.

**Step 3: Write the terminal-agent orchestration reference**

Document how to ask the terminal agent for context, inventory changes, agree on scope, approve routine read-only actions, reject or escalate risky prompts, monitor progress, and independently verify code/tests before reporting completion.

**Step 4: Check for leaked secrets**

Run:

```bash
rg -n 'GLKVM_PASSWORD|password\s*[:=]|token\s*[:=]' dot_agents/skills/control-glkvm-windows
```

Expected: no plaintext credential matches.

### Task 3: Write the Florida Exchange continuation handoff

**Files:**
- Create: `dot_agents/skills/control-glkvm-windows/references/florida-exchange-handoff.md`

**Step 1: Record the remote service state**

Record that `flex-cosmos` was running, `flex-redis` was restarted, and `docker exec flex-redis redis-cli ping` returned `PONG`. Tell the next agent to re-check rather than assume the state is still current.

**Step 2: Record approved test scope**

Record the pragmatic baseline: route/createApp integration coverage for every live API group, Playwright coverage for each portal's critical workflow and core interactions, and the existing cross-portal golden path. Exclude dead routes, obsolete broker flows, and the .NET receipting service unless inspection proves they remain live dependencies.

**Step 3: Record coverage and verification decisions**

Include the retailer, carrier, and platform coverage inventory; Cosmos-based local verification; unique test data; existing seed reuse; no broad cleanup; twice-run Playwright stability check; and CI/component-tooling/cross-portal Supertest follow-ups.

**Step 4: Define the next-agent startup checklist**

Require the next agent to reconnect, verify Docker, inspect the Claude terminal's current state and working tree, restate the agreed scope, continue the smallest incomplete test group, and verify before approving the next batch.

### Task 4: Validate and commit the source skill

**Files:**
- Validate: `dot_agents/skills/control-glkvm-windows/`
- Modify: `README.md`

**Step 1: Run structural validation**

Run:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py \
  dot_agents/skills/control-glkvm-windows
```

Expected: validation succeeds.

**Step 2: Document personal-skill ownership**

Update the Skills hub section in `README.md` to distinguish package-manager-installed third-party skills from curated personal skills managed under `dot_agents/skills/`.

**Step 3: Inspect the diff**

Run:

```bash
git diff --check
git diff -- dot_agents/skills/control-glkvm-windows
```

Expected: no whitespace errors and only the intended skill files appear.

**Step 4: Commit the skill**

Run:

```bash
git add README.md docs/plans/2026-08-21-control-glkvm-windows.md \
  dot_agents/skills/control-glkvm-windows
git commit -m "feat: add shared GLKVM Windows control skill"
```

Expected: a commit containing only the skill package.

### Task 5: Integrate and apply the skill

**Files:**
- Install: `~/.agents/skills/control-glkvm-windows/`

**Step 1: Fast-forward the active chezmoi checkout**

From the active source checkout, preserve the existing unrelated `dot_profile` modification and run:

```bash
git merge --ff-only feat/control-glkvm-windows
```

Expected: `main` advances without modifying the existing `dot_profile` working-tree change.

**Step 2: Preview the chezmoi application**

Run:

```bash
chezmoi diff ~/.agents/skills/control-glkvm-windows
```

Expected: only the new skill files are proposed.

**Step 3: Apply only the new skill**

Run:

```bash
chezmoi apply ~/.agents/skills/control-glkvm-windows
```

Expected: the skill is installed under `~/.agents/skills/control-glkvm-windows/`.

**Step 4: Verify source and installed content**

Run:

```bash
diff -ru \
  ~/.local/share/chezmoi/dot_agents/skills/control-glkvm-windows \
  ~/.agents/skills/control-glkvm-windows
```

Expected: no differences.

**Step 5: Verify final repository state**

Run:

```bash
git status --short --branch
```

Expected: only the pre-existing `dot_profile` modification remains uncommitted.
