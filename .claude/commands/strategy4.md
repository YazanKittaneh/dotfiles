---
allowed-tools: Task, Read, Glob, Grep, Write, Edit, Bash
argument-hint: <feature-description>
description: Builder vs Minimalist agent debate - evaluates two implementation approaches and chooses the best one
---

# Strategy 4: Builder vs. Minimalist Agent Pairs

This command implements the "opposing philosophies" approach to prevent over-engineering. Two agents propose competing solutions, a third agent decides which is better.

## Your Task

You are the **orchestrator** of a three-agent debate. Follow these steps precisely:

### Step 1: Run Codebase Discovery

**CRITICAL**: Discovery must happen FIRST before any proposals.

Use the `Task` tool to invoke the `codebase-archaeologist-v1` agent:

```
Prompt: "Discover what already exists in the codebase for this requirement.

Requirement: $ARGUMENTS

Perform thorough discovery following your process:
1. Search for existing utilities that could be reused
2. Find similar features already implemented
3. Analyze codebase patterns and conventions
4. Identify integration points
5. Search for warnings and anti-patterns
6. Calculate baseline metrics
7. Determine what needs to be built vs. what exists

Provide your complete Discovery Report following your output format."

Subagent: codebase-archaeologist-v1
```

Wait for the complete **Codebase Discovery Report** before proceeding to Step 2.

The Discovery Report will include:
- Existing utilities to reuse
- Similar implementations
- Codebase patterns & conventions
- What NOT to build (already exists)
- What NEEDS to be built
- Baseline complexity metrics

### Step 2: Launch Builder and Minimalist Agents in Parallel

Use the `Task` tool to launch BOTH agents simultaneously (in a single message with two Task tool calls):

**Builder Agent:**
```
Prompt: "Based on this Discovery Report and requirements, propose your architecturally sound solution.

[paste Discovery Report]

Requirements: $ARGUMENTS

Provide your Builder Proposal following your output format."

Subagent: builder-agent-v1
```

**Minimalist Agent:**
```
Prompt: "Based on this Discovery Report and requirements, propose the simplest possible solution.

[paste Discovery Report]

Requirements: $ARGUMENTS

Provide your Minimalist Proposal following your output format. Be especially aggressive in challenging unnecessary abstractions."

Subagent: minimalist-agent-v1
```

### Step 3: Wait for Both Proposals

Both agents will complete their analysis. You'll receive:
- Builder's proposal with architecture, components, patterns, justification
- Minimalist's proposal with simple solution, reuse strategy, challenges

### Step 4: Launch Mediator Agent

Once both proposals are complete, use the `Task` tool to invoke the mediator:

```
Prompt: "Evaluate these two competing proposals and make a final decision.

## Discovery Report
[paste the Discovery Report from Step 1]

## Builder Proposal
[paste complete Builder output]

## Minimalist Proposal
[paste complete Minimalist output]

## Requirements
$ARGUMENTS

Provide your complete Mediator Decision following your output format. Be thorough in your analysis."

Subagent: mediator-agent-v1
```

### Step 5: Present Results to User

After the Mediator completes, present a summary:

```markdown
# Strategy 4 Results: Builder vs. Minimalist

## Requirements
[Summary]

## Discovery Highlights
- [Key finding 1]
- [Key finding 2]

## Builder's Approach
**Complexity:** [X files, Y LOC, Z patterns]
**Key Abstractions:** [List]

## Minimalist's Approach
**Complexity:** [X files, Y LOC, Z patterns]
**Key Strategy:** [Summary]

## Mediator Decision
**Winner:** [Builder / Minimalist / Hybrid]
**Reasoning:** [2-3 sentences]

---

## Recommended Implementation

[Paste Mediator's "Instructions for Implementation Agent" section]

---

Would you like me to:
1. Proceed with implementing this approach
2. Ask the agents to revise their proposals
3. Show detailed analysis from any agent
```

## Important Notes

- **Always run Builder and Minimalist in parallel** - use a single message with two Task tool calls
- **Always complete Discovery first** - agents need context about what exists
- **Never skip the Mediator** - human shouldn't have to judge
- **Present clear summary** - don't dump raw agent outputs on user

## Advanced Usage

### With specific ticket
```
/strategy4 JIRA-1234
```

### With feature description
```
/strategy4 Add endpoint to fetch user payment history for the last 30 days
```

### After discovery only (skip to debate)
```
/strategy4 --skip-discovery <feature-description>
```
(Only use if you already have a Discovery Report in context)

## Example Flow

1. User: `/strategy4 Add payroll export to CSV`
2. You: [Run discovery - grep/glob for existing export code]
3. You: [Generate Discovery Report]
4. You: [Launch Builder + Minimalist in parallel]
5. You: [Wait for both proposals]
6. You: [Launch Mediator with both proposals]
7. You: [Present summary to user with recommendation]

This prevents over-engineering by forcing advocates to defend their positions!
