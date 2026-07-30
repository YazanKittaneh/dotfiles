---
description: Review all open PRs with parallel agent analysis
---

# PR Review Orchestration

You are orchestrating a comprehensive review of all open pull requests in this repository.

## Prerequisites

Before running this command, ensure the Bitbucket CLI is authenticated:

```bash
bb profile list
```

If authentication is needed, set up a profile first:
```bash
bb profile create
```

## Step 1: Discover Open PRs

Get all open PRs using the Bitbucket CLI:

```bash
bb pullrequest list --state open -o json
```

**If bb CLI authentication fails**, use this alternative approach:
```bash
# Fetch all remote branches
git fetch --all

# List recent branches (filter manually for PR branches)
git branch -r --sort=-committerdate | head -20
```

Then ask the user which branches they want reviewed.

Parse the JSON output to extract:
- PR ID
- Source branch name
- PR title
- PR author

## Step 2: Create Git Worktrees

For EACH open PR branch, create a git worktree in a temporary directory:

```bash
# Create worktrees directory if it doesn't exist
mkdir -p /tmp/pr-worktrees

# For each branch, create a worktree
git worktree add /tmp/pr-worktrees/[branch-name] [branch-name]
```

IMPORTANT: Track all created worktrees so they can be cleaned up later.

## Step 3: Parallel Agent Review

For EACH PR worktree, launch these 4 specialized agents IN PARALLEL (single message with multiple Task tool calls):

**IMPORTANT**: Use `model: "haiku"` parameter for ALL agent Task tool calls to use Haiku 4.5.

### Agent 1: frontend-engineer
**Prompt:**
```
Review the frontend changes in the PR worktree at /tmp/pr-worktrees/[branch-name]

Focus on:
1. **React/TypeScript Standards**:
   - Proper use of hooks and component patterns
   - TypeScript type safety and interface usage
   - Material-UI v7 usage patterns
   - Redux Toolkit best practices

2. **Code Similarity & Redundancy**:
   - Duplicate logic that could be extracted to shared utilities
   - Similar components that could be consolidated
   - Repeated patterns that violate DRY principles

3. **Frontend Standards** (refer to /frontend/CLAUDE.md):
   - Proper use of @/ui imports (never @ui-lib)
   - Mobile-first responsive design
   - Error handling and loading states
   - Performance optimizations

Compare the PR changes with the main branch using:
```bash
cd /tmp/pr-worktrees/[branch-name]
git diff main...HEAD -- 'frontend/**'
```

Provide specific file paths and line numbers for all issues found.
```

### Agent 2: backend-engineer
**Prompt:**
```
Review the backend changes in the PR worktree at /tmp/pr-worktrees/[branch-name]

Focus on:
1. **Django/Python Standards**:
   - PEP 8 compliance
   - Service layer patterns
   - Proper use of @fga_required decorator
   - Database query optimization (select_related/prefetch_related)

2. **Code Similarity & Redundancy**:
   - Duplicate business logic across services
   - Repeated validation patterns
   - Similar API endpoints that could be consolidated
   - Redundant database queries

3. **Backend Standards** (refer to /backend2/CLAUDE.md):
   - All new features in backend2/ (not backend/)
   - Proper error handling and logging
   - API design consistency
   - Security best practices

Compare the PR changes with the main branch using:
```bash
cd /tmp/pr-worktrees/[branch-name]
git diff main...HEAD -- 'backend2/**'
```

Provide specific file paths and line numbers for all issues found.
```

### Agent 3: architect-reviewer
**Prompt:**
```
Review the architectural patterns and design decisions in the PR worktree at /tmp/pr-worktrees/[branch-name]

Focus on:
1. **Architectural Consistency**:
   - SOLID principles adherence
   - Proper layering (presentation, service, data)
   - API contract consistency
   - Component/module boundaries

2. **Cross-Cutting Concerns**:
   - Code duplication across frontend/backend
   - Opportunities for shared utilities or patterns
   - Inconsistent approaches to similar problems
   - Missing abstractions

3. **System Design**:
   - Scalability implications
   - Performance bottlenecks
   - Security considerations
   - Maintainability issues

Review all changes across the entire codebase:
```bash
cd /tmp/pr-worktrees/[branch-name]
git diff main...HEAD
```

Provide high-level architectural feedback with specific examples.
```

### Agent 4: code-reviewer
**Prompt:**
```
Perform a comprehensive code quality review of the PR worktree at /tmp/pr-worktrees/[branch-name]

Focus on:
1. **Code Quality**:
   - Code clarity and readability
   - Naming conventions
   - Comment quality (necessary vs. redundant)
   - Magic numbers and hard-coded values

2. **Redundancy Detection**:
   - Copy-pasted code blocks
   - Similar functions with slight variations
   - Redundant conditional logic
   - Unnecessary complexity

3. **Best Practices**:
   - Error handling completeness
   - Edge case coverage
   - Test coverage gaps
   - Documentation completeness

Review all changes:
```bash
cd /tmp/pr-worktrees/[branch-name]
git diff main...HEAD
```

Provide specific, actionable feedback with file paths and line numbers.
```

## Step 4: Consolidate Findings

After all agents complete their reviews:

1. **Summarize by PR**: Group all findings by PR ID
2. **Prioritize Issues**: Categorize as Critical, High, Medium, Low
3. **Identify Patterns**: Note recurring issues across multiple PRs
4. **Generate Report**: Create a markdown report with:
   - PR summary (ID, title, author, branch)
   - Issues found by category
   - Specific locations (file:line)
   - Recommended actions

## Step 5: Cleanup

Remove all worktrees after review:

```bash
# For each worktree created
git worktree remove /tmp/pr-worktrees/[branch-name]

# Remove the temporary directory
rm -rf /tmp/pr-worktrees
```

## Output Format

Present findings as:

```markdown
# PR Review Summary

## PR #[ID]: [Title]
**Branch**: [branch-name]
**Author**: [author]

### Critical Issues (Must Fix)
- [file:line] - [description]

### High Priority
- [file:line] - [description]

### Medium Priority
- [file:line] - [description]

### Code Redundancy Detected
- [description of duplicate code]
- Suggested consolidation approach

### Architectural Recommendations
- [high-level feedback]

---
```

## Important Notes

- Launch all 4 agents IN PARALLEL for each PR (use single message with multiple Task tool calls)
- **Use `model: "haiku"` for ALL agent Task tool calls** (orchestrator stays on Sonnet 4.5)
- Agents should use the worktree path, not the main repository
- Focus on SPECIFIC issues with file paths and line numbers
- Emphasize code redundancy and similarity detection
- Reference project standards from CLAUDE.md files
- Clean up ALL worktrees when done
