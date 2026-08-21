# Florida Exchange Testing Handoff

## Contents

1. Objective and decisions
2. Historical runtime state
3. Approved coverage
4. Test data and diagnostics
5. Verification standard
6. Next-agent startup checklist

## Objective and decisions

Build a pragmatic baseline test suite for the application's live base functionality. The approved scope is:

1. Add route/createApp integration tests for every live API group, using the local Cosmos Emulator and covering a representative happy path plus validation or error behavior.
2. Add Playwright coverage for the core screens and critical workflow in each portal.
3. Keep and verify the existing cross-portal golden path rather than adding another cross-portal specification in this scope.

Do not add a new cross-portal Supertest packaging/orchestration layer or frontend component-test tooling in this iteration. Record those as follow-ups. Exclude obsolete broker flows, dead routes, and the .NET `flex-receipting` service unless fresh repository inspection proves they remain live dependencies.

The success criterion chosen by the user was author-only local reliability. All new or updated tests must pass locally against Cosmos Emulator and the existing per-application scripts. CI wiring is a follow-up.

## Historical runtime state

At the end of the remote exercise:

- `flex-cosmos` appeared to be running.
- `flex-redis` had been stopped with `Exited (255)` and was restarted using `docker start flex-redis`.
- `docker exec flex-redis redis-cli ping` returned `PONG`.
- A Claude Code instance was open in the Windows terminal and had inspected/planned the testing work.

These facts are not current-state guarantees. Reconnect and verify Docker, the terminal, the repository, and any uncommitted changes before continuing.

## Approved coverage

### Retailer portal

API groups:

- ASR disputes
- BGR reports
- Carrier products and carrier reads
- Tower templates and deductible selector
- Programs: accept, withdraw, and bind

Playwright workflows:

- Complete the intake wizard and submit
- Review and accept a quote
- Inspect the bound portfolio

### Carrier portal

API groups:

- Bid, decline, and finalize
- Carriers
- Lines-of-business definitions
- Opportunities
- Appetite CRUD

Playwright workflows:

- Exercise the appetite-filtered worklist
- Price, decline, and finalize representative opportunities

### Platform portal

API groups:

- Agencies
- AOR disputes
- Build-decision logs
- Rules
- Users
- Workflows
- Submissions and documents

Playwright workflows:

- Exercise representative administrative CRUD
- Exercise qualification or status transition behavior

### Cross-portal

The golden-path Playwright flow was reported as already implemented. Inspect and run it; do not duplicate it unless the existing flow is missing or invalid.

## Test data and diagnostics

- Generate unique timestamp or random identifiers for created records.
- Reuse seeded reference catalogs where appropriate.
- Avoid broad cleanup that can delete pre-existing developer data.
- Do not depend on test execution order.
- Use the existing Vitest assertions and error envelopes.
- Keep Playwright's list reporter and trace-on-first-retry diagnostics.
- Make cross-portal failures identify the portal, server, and base URL involved.

## Verification standard

1. Run the existing local application scripts against the running Cosmos Emulator.
2. Run each new narrow integration group while developing it.
3. Run the relevant broader application suite before completing a batch.
4. Run newly added Playwright coverage twice to catch obvious flakiness.
5. Verify the existing cross-portal golden path.
6. Document CI wiring, cross-portal Supertest orchestration, and component-test tooling as explicit follow-ups.

## Next-agent startup checklist

1. Reconnect to GLKVM using [glkvm-runbook.md](glkvm-runbook.md).
2. Run `docker ps -a` and re-verify Redis with `docker exec flex-redis redis-cli ping`.
3. Inspect the Claude Code terminal's current output and any pending prompt.
4. Ask Claude to restate its repository root, current branch, working-tree status, completed tests, failing commands, and next proposed batch.
5. Compare its answer with `git status`, `git diff`, manifests, routes, and test configuration.
6. Restate the approved scope above and correct any drift before approving implementation.
7. Continue the smallest incomplete API group or portal workflow.
8. Verify the batch independently before approving the next one.
