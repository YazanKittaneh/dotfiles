# Claude Code Custom Commands

This directory contains custom slash commands for Claude Code workflows.

## Available Commands

### `/design-research`
**File**: `design-research.md`
**Purpose**: Comprehensive design system research and planning
**Target**: @paychex/sp20-design NPM package

Conducts a 60-90 minute deep-dive research session that:
- Analyzes architecture, component APIs, and developer experience
- Creates 4 comprehensive Obsidian notes with findings
- Generates prioritized implementation roadmap
- Identifies technical debt and improvement opportunities

**Usage**:
```
/design-research
```

**Outputs**:
- SP20 Design - Architecture Analysis [DATE]
- SP20 Design - Component API Standards [DATE]
- SP20 Design - Implementation Roadmap [DATE]
- SP20 Design - Developer Experience [DATE]

---

### `/strategy4`
**File**: `strategy4.md`
**Purpose**: Builder vs Minimalist agent debate
**Argument**: `<feature-description>`

Evaluates two implementation approaches (Builder and Minimalist) and chooses the best one through a three-agent debate system.

**Usage**:
```
/strategy4 Add user authentication with JWT
```

---

### `/strategy6`
**File**: `strategy6.md`
**Purpose**: Track over-engineering penalties and rewards
**Options**: `[--analyze | --report | --score <agent-name>]`

Calculates simplicity scores for code changes to prevent over-engineering.

**Usage**:
```
/strategy6 --analyze
/strategy6 --report
/strategy6 --score agent-name
```

---

### `/start-pr`
**File**: `start-pr.md`
**Purpose**: Review all open PRs with parallel agent analysis

Reviews multiple pull requests simultaneously using parallel agents for comprehensive analysis.

**Usage**:
```
/start-pr
```

---

### Kiro Commands
**Directory**: `kiro/`
**Purpose**: Specification and project management commands

#### `/kiro:spec-init`
Initialize a new specification with detailed project description and requirements

#### `/kiro:spec-requirements`
Generate comprehensive requirements for a specification

#### `/kiro:spec-design`
Create technical design for a specification

#### `/kiro:spec-tasks`
Generate implementation tasks for a specification

#### `/kiro:spec-status`
Show specification status and progress

#### `/kiro:steering`
Create or update Kiro steering documents based on project state

#### `/kiro:steering-custom`
Create custom Kiro steering documents for specialized contexts

---

## Command Structure

Commands follow this format:

```markdown
---
allowed-tools: Tool1, Tool2, Tool3
argument-hint: <argument-description>  # optional
description: Brief description of what the command does
---

# Command Title

[Command content and instructions for Claude]
```

## Creating New Commands

1. Create a new `.md` file in this directory
2. Add frontmatter with `allowed-tools` and `description`
3. Write detailed instructions for Claude
4. Test the command with `/your-command-name`

## Command Locations

Commands can be defined in two places:

1. **Global**: `~/dotfiles/.claude/commands/` - Available in all projects
2. **Project**: `.claude/commands/` - Available only in specific project

Project commands override global commands with the same name.

## Documentation

For detailed documentation on specific workflows:

- **Design System Research**: See `SP20 Design System - Research Workflow Guide.md` and `SP20 Design System - Quick Start.md` in the SurePayroll vault
