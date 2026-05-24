# Minimum Effective Plan

KISS does not mean under-specifying. An AF Feature Plan should be the shortest plan that a weaker model can execute without guessing.

## Non-Negotiable Minimum

Every formal feature plan includes:

- Primary Module.
- Concrete AF Element names.
- BDD behavior or acceptance scenario.
- Test obligation derived from AF Elements.
- TDD slice with test first, expected RED, minimal GREEN, refactor boundary, behavior/risk, test type, and verification Gate.
- Verification Gate with a real command or explicit manual verification gate.
- Decisions for any gray area that would affect implementation, tests, AF ownership, acceptance, or scope.

Do not remove these to make a plan look simple.

## Scaling

### Tiny / Local

Use for local, low-risk behavior such as a small Surface display change or simple copy/state presentation.

Keep:

- Primary Module.
- Concrete AF Element.
- Concrete Surface when a route, page, component, scene, prefab, endpoint, command, editor entry, visible feedback, or entry point changes or is relied on.
- One BDD behavior or acceptance sentence.
- One test obligation or explicit verification gate.
- One TDD slice.
- Verification Gate.

Skip unless relevant:

- Option Framing.
- Required Documentation Updates.
- Multi-module detail.

### Normal

Use for standard feature work.

Keep:

- Module Impact Map.
- BDD Acceptance Scenarios.
- AF Element Changes.
- TDD Execution Slices with behavior/risk, test type, and verification Gate.
- Verification Gates.

### Complex / Cross-Module

Use when behavior crosses Modules, external boundaries, engine/runtime timing, public contracts, data migration, permissions, or risky state transitions.

Keep:

- Full Requirement Grilling.
- Full Domain Consistency Grilling.
- Option Framing for real tradeoffs.
- Complete Module Impact Map.
- Complete AF Element Changes.
- Cross-module UseCase section when behavior crosses Modules.
- BDD normal, failure, and no-side-effect scenarios.
- Module and cross-module TDD Execution Slices with behavior/risk, test type, and verification Gate.
- Required Documentation Updates when durable knowledge changes.

## Anti-Patterns

- Short plan that leaves the model to infer Module, AF Element, tests, or verification.
- Long plan that adds empty tables, meaningless omission notes, or documentation updates that do not reduce future ambiguity.
- Option Framing with only one real option.
- Treating KISS as permission to skip BDD, TDD, review, or verification.
