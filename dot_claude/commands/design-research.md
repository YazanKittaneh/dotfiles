---
allowed-tools: Task, Read, Glob, Grep, Write, Edit, Bash, WebFetch
description: Deep-dive research and planning for sp20-design NPM package - generates comprehensive architecture, API, roadmap, and DX analysis
---

# Design System Research & Planning

You are tasked with conducting a comprehensive deep-dive research session for the **@paychex/sp20-design** NPM package - a React + TypeScript design system built on Material-UI for SurePayroll developers.

## Context

**Package Location**: ~/git/sp20-design
**Current Version**: 0.4.0
**Architecture**: React 18 + MUI v6 + TypeScript + Storybook
**Current Components**: 40+ components (15 elements, 25+ composite components)
**Distribution**: Git-based NPM package (internal Bitbucket)
**Target Audience**: SurePayroll development teams

## Your Research Mission

Conduct a thorough analysis and planning session focusing on:

### 1. Architecture Assessment
- Review current component organization (elements vs components)
- Evaluate TypeScript type safety and prop API consistency
- Assess theme system architecture (SPR Light/Dark themes)
- Analyze build and distribution strategy (dist/ folder pattern)
- Identify technical debt and architectural improvements

### 2. Component API Design
- Review existing component APIs for consistency
- Identify patterns across components (DS prefix, sx prop usage)
- Evaluate prop naming conventions and TypeScript interfaces
- Assess accessibility (a11y) implementation across components
- Design principles for new component APIs

### 3. Developer Experience (DX)
- Evaluate Storybook documentation quality
- Assess ease of component consumption by teams
- Review build/test/release workflow efficiency
- Identify pain points in the development workflow
- Suggest tooling and automation improvements

### 4. Implementation Roadmap
- Prioritize architectural improvements
- Plan new component additions based on team needs
- Design migration strategies for breaking changes
- Create phased implementation timeline
- Define success metrics and quality gates

## Research Methodology

Follow this systematic approach:

### Phase 1: Discovery (15-20 minutes)
1. **Codebase Exploration**
   - Use the Explore agent to map out the component structure
   - Read key architectural files (index.ts, theme configs, build scripts)
   - Review existing Storybook stories for documentation patterns
   - Examine test coverage and testing patterns

2. **Pattern Analysis**
   - Identify common patterns across components
   - Document inconsistencies or anti-patterns
   - Note particularly well-designed components as examples
   - Flag components needing refactoring

### Phase 2: Analysis (20-30 minutes)
3. **Benchmarking Against MUI**
   - Compare wrapper patterns vs MUI base components
   - Evaluate which customizations add value
   - Identify opportunities to leverage MUI features better
   - Document where custom implementations are justified

4. **Developer Workflow Analysis**
   - Review the build and release process
   - Evaluate testing strategy (Jest + jsdom)
   - Assess Storybook development experience
   - Identify bottlenecks in the development cycle

5. **API Consistency Review**
   - Create a matrix of prop patterns across components
   - Document TypeScript interface patterns
   - Identify naming convention inconsistencies
   - Propose standardization opportunities

### Phase 3: Synthesis & Planning (20-30 minutes)
6. **Architecture Recommendations**
   - Prioritized list of architectural improvements
   - Specific refactoring suggestions with examples
   - Migration strategies for breaking changes
   - Long-term architectural vision

7. **Component Roadmap**
   - High-priority missing components
   - Components needing enhancement
   - Deprecation candidates
   - Innovation opportunities (new patterns, advanced features)

8. **DX Improvements**
   - Tooling enhancements (better builds, testing, docs)
   - Developer onboarding improvements
   - Documentation gaps to fill
   - Automation opportunities

## Documentation Output

Create structured Obsidian notes in the current vault:

### Note 1: `SP20 Design - Architecture Analysis [DATE]`
- Current state assessment
- Strengths and weaknesses
- Technical debt inventory
- Architectural recommendations
- Links to relevant code locations (file:line format)

### Note 2: `SP20 Design - Component API Standards [DATE]`
- Prop naming conventions
- TypeScript interface patterns
- Accessibility requirements
- Storybook documentation standards
- Example implementations from existing code

### Note 3: `SP20 Design - Implementation Roadmap [DATE]`
- Phased implementation plan
- Priority-ordered tasks with estimates
- Breaking change migration strategies
- Success metrics and quality gates
- Dependencies between tasks

### Note 4: `SP20 Design - Developer Experience [DATE]`
- Current workflow analysis
- Pain points and friction
- Proposed improvements with specific solutions
- Tooling recommendations
- Onboarding enhancements

## Research Guidelines

**Be Thorough**: This is a deep-dive session. Take time to explore the codebase comprehensively.

**Be Specific**: Reference actual code with file paths and line numbers. Include concrete examples.

**Be Practical**: Focus on actionable recommendations that can be implemented incrementally.

**Be Strategic**: Think long-term architecture while respecting the current implementation.

**Be Developer-Focused**: Remember the audience is SurePayroll developers who need practical, well-documented components.

## Tools to Use

- **Task tool with Explore agent**: For comprehensive codebase exploration
- **Read tool**: To examine specific files in detail
- **Grep tool**: To find patterns across the codebase
- **WebFetch**: If you need to reference MUI documentation for best practices
- **Write tool**: To create the Obsidian documentation notes

## Expected Timeline

Total research session: **60-90 minutes** of focused analysis

## Deliverables

By the end of this research session, you should have:

1. ✅ 4 detailed Obsidian notes documenting findings
2. ✅ Specific architectural recommendations with code examples
3. ✅ Prioritized implementation roadmap
4. ✅ DX improvement proposals
5. ✅ Clear next steps for the development team

## Starting the Research

Begin by:
1. Greeting the user and confirming you're starting the research session
2. Creating a todo list with the research phases
3. Starting with Phase 1: Discovery using the Explore agent
4. Systematically working through each phase
5. Creating comprehensive Obsidian notes as you go

Remember: This is a strategic planning session. Your insights will guide significant development decisions for this package.
