---
allowed-tools: Task, Read, Glob, Grep, Write, Edit, Bash
argument-hint: [--analyze | --report | --score <agent-name>]
description: Track over-engineering penalties and rewards - calculates simplicity scores for code changes
---

# Strategy 6: Penalty for Over-Engineering

This command implements the scoring system that rewards simplicity and penalizes unnecessary complexity.

## Usage Modes

### 1. Analyze Current Changes
```
/strategy6 --analyze
```
Analyzes uncommitted or recent changes, calculates score, provides feedback.

### 2. Generate Agent Report
```
/strategy6 --report
```
Generates leaderboard and sprint retrospective from historical data.

### 3. Score Specific Agent
```
/strategy6 --score <agent-name>
```
Shows detailed score breakdown for a specific agent's work.

---

## Your Task

### Mode 1: Analyze Current Changes (`--analyze`)

This is the primary mode - analyzing code changes for over-engineering.

#### Step 1: Identify Changes

Use `git diff` to find what changed:
```bash
# Get staged changes
git diff --cached --stat
git diff --cached --numstat

# Or recent commit if nothing staged
git log -1 --stat
git show HEAD --stat
```

Capture:
- Files created (new)
- Files modified
- Lines added/removed
- File types

#### Step 2: Analyze Code Complexity

For each changed file, analyze:

**A. Abstractions Count** (PENALTY: -20 each)
Search for:
- `interface I` - interfaces
- `abstract class` - abstract base classes
- `class.*Factory` - factory patterns
- `class.*Builder` - builder patterns
- `implements` with single implementation
- `extends` with single subclass
- Generic types: `<T>`, `<K,V>` used only once

**B. New Patterns Introduced** (PENALTY: -25 each)
1. Scan existing codebase for pattern frequency:
```bash
grep -r "class.*Factory" --include="*.ts" --include="*.js" | wc -l
grep -r "class.*Builder" --include="*.ts" --include="*.js" | wc -l
grep -r "interface I[A-Z]" --include="*.ts" | wc -l
```

2. Check if changed files introduce patterns with <3 existing uses
3. Flag as "new pattern" if rare/unique

**C. File Count Analysis** (PENALTY: -10 per extra file)
1. Determine minimal file count for feature type:
   - Simple CRUD: 1-2 files (add to existing Controller/Repository)
   - New feature: 2-4 files
   - Complex feature: 4-8 files

2. Compare actual vs. minimal
3. Penalty = (actual - minimal) × 10

**D. Code Reuse Detection** (REWARD: +3 each)
Search changed files for imports from common utilities:
```bash
grep "import.*from.*utils/" [files]
grep "import.*from.*helpers/" [files]
grep "import.*from.*validators/" [files]
grep "import.*from.*services/" [files]
```

Count unique imports from existing utility modules.

**E. Pattern Conformity** (REWARD: +5 each)
Compare against codebase patterns:
- Uses existing base classes → +5
- Follows existing naming conventions → +5
- Matches file structure of similar features → +5
- Uses existing error handling → +5

#### Step 3: Calculate Score

```javascript
Score =
  (Tasks Completed × 10) +
  (Code Reused × 3) +
  (Matches Codebase Patterns × 5) -
  (Unnecessary Abstractions × 20) -
  (Files Beyond Minimal × 10) -
  (New Patterns Introduced × 25)
```

For this analysis:
- Tasks Completed = 1 (assume one task)
- Calculate other metrics from analysis

#### Step 4: Check for Human "Simplify" Comments

If analyzing a PR or commit with review comments, use GitKraken CLI MCP to fetch PR details:

**Note:** If you have access to GitKraken CLI MCP tools (like `mcp__gitkraken__*`), use them to:
- Get current PR information
- Fetch PR review comments
- Check for discussion threads

Search comments for phrases:
- "simplify", "over-engineered", "too complex"
- "why do we need", "unnecessary"
- "let's use what we have"

Each = -15 points (if PR exists)

#### Step 5: Generate Feedback Report

```markdown
# Strategy 6 Analysis: Code Complexity Score

## Changes Analyzed
- **Files Created:** X
- **Files Modified:** Y
- **Total Lines Changed:** Z

---

## Scoring Breakdown

### ✅ Rewards (+)
- Code Reused: [X instances] → +[X × 3] points
  - [List specific utilities reused]
- Pattern Conformity: [Y instances] → +[Y × 5] points
  - [List patterns matched]
- Base Score: +10 (task completed)

**Total Rewards: +[sum]**

---

### ❌ Penalties (-)
- Unnecessary Abstractions: [X found] → -[X × 20] points
  - [List each: interface/base class with justification why it's unnecessary]
- Files Beyond Minimal: [X extra] → -[X × 10] points
  - Minimal for this feature: Y files
  - Actual: Z files
- New Patterns Introduced: [X patterns] → -[X × 25] points
  - [List patterns not commonly used in codebase]
- "Simplify" Comments: [X comments] → -[X × 15] points

**Total Penalties: -[sum]**

---

## Final Score: [total]

### Score Interpretation
- **+200 or higher:** ⭐ Excellent - Simple, reuses well, matches patterns
- **+100 to +199:** ✅ Good - Solid code with minor complexity
- **0 to +99:** ⚠️ Warning - Some unnecessary complexity
- **Negative:** 🚨 Red Flag - Significant over-engineering

---

## Detailed Findings

### 🚩 Over-Engineering Detected

[For each issue found:]

**[Issue Type]:** [Interface/Base Class/Pattern Name]
- **Location:** [file:line]
- **Problem:** [Why it's unnecessary]
- **Recommendation:** [How to simplify]
- **Score Impact:** -[X] points

### ✅ Good Practices Found

[For each good thing:]

**[Practice]:** [Specific example]
- **Location:** [file:line]
- **Why It's Good:** [Explanation]
- **Score Impact:** +[X] points

---

## Recommendations

[Based on score:]

### If Score < 0:
❌ **Significant refactoring recommended:**
1. [Specific simplification 1]
2. [Specific simplification 2]
3. [Specific simplification 3]

Consider re-running with `/strategy4` to get Minimalist perspective.

### If Score 0-99:
⚠️ **Minor improvements suggested:**
1. [Suggestion 1]
2. [Suggestion 2]

### If Score 100+:
✅ **Code quality is good!** Minor notes:
- [Optional improvement 1]

---

## Next Steps

1. **Review flagged abstractions** - Can any be eliminated?
2. **Check reuse opportunities** - Did you miss existing utilities?
3. **Compare to similar features** - Does your code look like theirs?

Would you like me to:
- Show specific code snippets that could be simplified
- Run Strategy 4 to get alternative approach
- Commit changes with score in commit message
```

---

### Mode 2: Generate Agent Report (`--report`)

This generates a sprint retrospective report.

#### Step 1: Gather Historical Data

You'll need to maintain a tracking file: `.claude/strategy6-tracking.json`

If it doesn't exist, create it:
```json
{
  "sprint": "current",
  "startDate": "YYYY-MM-DD",
  "agents": {},
  "analyses": []
}
```

Each analysis adds entry:
```json
{
  "date": "YYYY-MM-DD",
  "agent": "agent-name or human",
  "score": 150,
  "metrics": {
    "filesCreated": 2,
    "linesChanged": 50,
    "abstractions": 0,
    "codeReused": 5,
    "patternConformity": 3
  },
  "commit": "abc123",
  "summary": "Added payment history endpoint"
}
```

#### Step 2: Generate Leaderboard

```markdown
# Strategy 6 Sprint Report

## Agent Simplicity Leaderboard - Sprint [X]

Generated: [date]
Period: [start] to [end]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Rank  Agent/Developer     Score   Changes  Avg Score
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 🥇   [Name]              +[XXX]    [Y]      [Z]/10
 🥈   [Name]              +[XXX]    [Y]      [Z]/10
 🥉   [Name]              +[XXX]    [Y]      [Z]/10
  4   [Name]              +[XXX]    [Y]      [Z]/10
  5   [Name]              +[XXX]    [Y]      [Z]/10

🔻 Needs Improvement
 [X]  [Name]              -[XX]     [Y]      [Z]/10  ⚠️
      → [X] unnecessary abstractions
      → [Y] new patterns introduced

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Sprint Metrics

### Overall Trends
- **Code Reuse Rate:** [X]% [↑↓ from last sprint]
- **Avg Files Per Feature:** [X] [↑↓]
- **Unnecessary Abstractions:** [X] total [↑↓]
- **Pattern Conformity:** [X]% [↑↓]

### Top Wins This Sprint
✅ [Agent/Dev]: [Specific achievement]
✅ [Agent/Dev]: [Specific achievement]
✅ [Agent/Dev]: [Specific achievement]

### Top Issues This Sprint
❌ [Agent/Dev]: [Specific problem]
❌ [Agent/Dev]: [Specific problem]

### Pattern Analysis
- Most reused utilities: [List top 3]
- Most violated patterns: [List issues]
- New patterns introduced: [List and frequency]

## Action Items for Next Sprint

1. [Action based on data]
2. [Action based on data]
3. [Action based on data]

## Historical Comparison

| Metric | This Sprint | Last Sprint | Change |
|--------|-------------|-------------|--------|
| Avg Score | [X] | [Y] | [+/-Z] |
| Reuse Rate | [X]% | [Y]% | [+/-Z]% |
| Abstractions | [X] | [Y] | [+/-Z] |
| Files/Feature | [X] | [Y] | [+/-Z] |
```

---

### Mode 3: Score Specific Agent (`--score <agent-name>`)

Shows detailed breakdown for one agent/developer.

```markdown
# Strategy 6 Detailed Score: [Agent Name]

## Overall Statistics
- **Total Score:** [X]
- **Changes Analyzed:** [Y]
- **Average Score:** [Z]/10
- **Rank:** [position] of [total]

## Score History
[Chart/table of scores over time]

## Best Practices
[Top 3 things this agent does well]
1. [Practice with examples]
2. [Practice with examples]
3. [Practice with examples]

## Areas for Improvement
[Top 3 issues]
1. [Issue with examples and recommendations]
2. [Issue with examples and recommendations]
3. [Issue with examples and recommendations]

## Recent Changes

[For each recent change:]
**[Date]:** [Description]
- Score: [X]
- Files: [Y] ([optimal] expected)
- Abstractions: [Z]
- Patterns: [List]
- [Notable findings]

## Recommendations
[Specific guidance for this agent]
```

---

## State Management

All data stored in: `.claude/strategy6-tracking.json`

Structure:
```json
{
  "currentSprint": "Sprint-23",
  "sprints": {
    "Sprint-23": {
      "startDate": "2025-10-01",
      "endDate": null,
      "analyses": [ /* analysis objects */ ]
    }
  },
  "agents": {
    "agent-name": {
      "totalScore": 450,
      "changesCount": 8,
      "averageScore": 56.25,
      "lastUpdated": "2025-10-28"
    }
  }
}
```

## Integration Points

- **With Strategy 4:** Run Strategy 6 after implementing Strategy 4's recommendation
- **With Git:** Auto-add score to commit messages (use `git commit` directly)
- **With GitKraken CLI MCP:** Use for fetching PR data, review comments, and remote operations
- **With CI/CD:** Run as pre-merge check

## GitKraken CLI MCP Integration

If you have GitKraken CLI MCP tools available (tools starting with `mcp__gitkraken__*`), use them for:

1. **Fetching PR Information**
   - Get PR details for current branch
   - Retrieve review comments
   - Check PR status and approvals

2. **Posting Results**
   - Add score as PR comment
   - Update PR description with metrics
   - Tag reviewers if score is low

3. **Remote Operations**
   - Push branches
   - Create PRs with score in description
   - Fetch remote changes for comparison

**Note:** All remote git operations should use GitKraken CLI MCP tools, not `gh` (GitHub CLI).

## Advanced Features

### Auto-scoring on commit
```bash
# In .git/hooks/pre-commit
claude /strategy6 --analyze --auto
```

### PR Integration (using GitKraken CLI MCP)
After creating PR, run:
```
/strategy6 --analyze --post-to-pr
```
This will use GitKraken CLI MCP to add score as comment.

### Threshold Enforcement
```bash
# Fail if score < 0
claude /strategy6 --analyze --enforce --threshold=0
```

---

## Notes

- First run creates tracking file
- Scores accumulate over sprint
- Reset tracking file at sprint boundaries
- Can manually edit tracking file for corrections
- Historical data preserved for trend analysis
- Use local `git` commands for diffs and history
- Use GitKraken CLI MCP for all remote operations (PRs, comments, etc.)

This system makes simplicity measurable and improvable!
