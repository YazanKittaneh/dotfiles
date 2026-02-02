---
allowed-tools: Task, Read, Glob, Grep, Write, Edit, Bash
argument-hint: <file-path-or-directory>
description: Add data-testid attributes to React components for tutorial highlighting and testing
---

# Add data-testid Attributes to Components

This command systematically adds `data-testid` attributes to React components, making them discoverable by the Sierra tutorial highlighting system and test frameworks.

## Usage

```bash
/add-testids src/views/MyComponent.tsx
/add-testids src/views/MyFeature/
```

## Your Task

You are tasked with adding `data-testid` attributes to React/TypeScript components. Follow these guidelines:

### 1. Read the Target Files

- If given a single file path, read that file
- If given a directory, find all `.tsx` files in it (excluding `__tests__` and `.test.` files)
- Read each target file to understand its structure

### 2. Identify Elements to Annotate

Add `data-testid` to these element types (in priority order):

**High Priority (Interactive Elements):**
- Buttons (Button, IconButton, etc.)
- Form inputs (TextField, Select, Checkbox, Radio, etc.)
- Links and navigation elements
- Cards and clickable containers
- Modals and drawers

**Medium Priority (Key UI Elements):**
- Section containers with distinct purposes
- Alert/notification components
- Loading states (spinners, skeletons)
- Error messages
- Headers and titles

**Low Priority (Optional):**
- Decorative containers
- Pure layout divs without semantic meaning

### 3. Naming Convention

Use **kebab-case** with descriptive, hierarchical names:

```typescript
// ✅ Good examples
data-testid="user-profile-card"
data-testid="save-changes-button"
data-testid="email-input"
data-testid="payment-form-container"
data-testid="error-message-alert"
data-testid="loading-spinner"

// ❌ Bad examples
data-testid="btn1"              // Not descriptive
data-testid="userProfileCard"   // camelCase (wrong)
data-testid="user_profile_card" // snake_case (wrong)
```

**Naming Pattern:**
```
[section-]component-type[-qualifier]

Examples:
- payment-card-primary
- user-settings-save-button
- email-verification-input
- account-error-message
```

### 4. Apply Changes

For each file:
1. Use the `Edit` tool to add `data-testid` attributes
2. Add them to the opening tag of JSX elements
3. Preserve existing formatting and indentation
4. Don't add to elements that already have `data-testid`

### 5. Verification

After making changes:
1. Run `npm run typecheck` to ensure no TypeScript errors
2. Run `npm run lint` to check for linting issues
3. Count total `data-testid` attributes added
4. List all unique test IDs added

### 6. Output Summary

Provide a summary including:
- Number of files modified
- Total `data-testid` attributes added
- List of all unique test IDs added (grouped by component)
- Any TypeScript or linting errors encountered

## Example Output

```
✅ Successfully added data-testid attributes

Files modified: 3
Total attributes added: 24

### UserProfile.tsx (8 attributes)
- user-profile-container
- profile-avatar-image
- edit-profile-button
- username-display
- email-display
- bio-text
- settings-link
- logout-button

### PaymentForm.tsx (10 attributes)
- payment-form-container
- card-number-input
- expiry-date-input
- cvv-input
- billing-address-input
- submit-payment-button
- cancel-button
- payment-error-alert
- payment-loading-spinner
- payment-success-message

### Dashboard.tsx (6 attributes)
- dashboard-container
- welcome-header
- stats-card-revenue
- stats-card-users
- recent-activity-list
- view-all-button

✓ No TypeScript errors
✓ No linting errors
```

## Integration with Tutorial Highlighting

These `data-testid` attributes are automatically discoverable by:
- **Sierra tutorial highlighting system** - Can highlight any element for guided tutorials
- **Test frameworks** - Standard attribute for E2E and integration tests
- **HighlightTestPanel** - Development tool for testing highlights

Use in Sierra commands:
```javascript
{
  tutorialCommand: 'highlight',
  componentId: 'testid:save-changes-button',
  highlightType: 'glow'
}
```

## Best Practices

1. **Be consistent** - Use the same naming pattern across the codebase
2. **Be specific** - `user-settings-save-button` > `save-button`
3. **Be hierarchical** - Group related elements with prefixes
4. **Don't overdo it** - Focus on interactive and key elements
5. **Check existing patterns** - Match the project's existing test ID style

## Notes

- Only add to production components, not test files
- Preserve all existing props and attributes
- Don't modify component logic or behavior
- Test IDs should be unique within a component's scope
- Use semantic names that describe the element's purpose, not its appearance
