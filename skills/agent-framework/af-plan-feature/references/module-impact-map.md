# Module Impact Map

`Module` is the primary coordinate for ownership, write scope, dependencies, and verification.

## Required Table

```md
## Module Impact Map
| Module | Impact Role | Change Status | Owns | Write Scope | Collaboration Mechanism | Forbidden Dependency | Verification Gate |
|---|---|---|---|---|---|---|---|
```

## Field Values

Impact Role:

- `Primary`: owns the feature outcome.
- `Collaborating`: changes or participates in the flow.
- `Read-only`: referenced but not changed.
- `External`: outside current codebase or profile boundary.
- `N/A`: explicitly not involved.

Change Status:

- `New`
- `Change`
- `Existing`
- `N/A`

## Rules

- `Primary Module` is normally unique.
- If multiple primary modules seem necessary, re-check whether this is one feature or multiple plans.
- Cross-module collaboration must name the collaboration mechanism: `UseCase`, `Event`, `Port`, `Result`, or `Surface composition`.
- Forbidden Dependency names any ModulePlan dependency that must not be introduced; use `N/A` only when no forbidden dependency is relevant.
- Do not bypass ModulePlan forbidden dependencies.
- Write Scope must be specific enough to prevent unrelated edits.
