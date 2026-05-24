# Domain Consistency Grilling

Challenge the request against the current project facts before planning.

## Inspect First

Read the relevant:

- `XXXAgentFramework`
- Directory And Naming Binding
- ModulePlan
- glossary or context docs
- ADRs or durable decision docs
- related code paths, routes, scenes, prefabs, API endpoints, tests, configs, and manifests

## Rules

- If the user's term conflicts with existing project language, stop and resolve the term before planning.
- If the user's described behavior conflicts with current code, tests, docs, or framework rules, stop and resolve which source of truth wins.
- If a proposed AF Element name does not reveal its type through Binding, rename it in the plan before execution.
- If a decision should be remembered later but Plan Mode is active, record it in `Required Documentation Updates`; do not write docs.
- Do not create or update `CONTEXT.md`, ADRs, plans, framework docs, or project files during Plan Mode.

## Conflict Patterns

- Same word means two different domain concepts.
- New feature bypasses ModulePlan dependencies.
- UI or Surface is asked to own a business decision.
- Adapter is asked to decide an outcome instead of translating an external capability.
- Rule depends on browser, engine, SDK, storage, network, database, or UI APIs.
- Ability and Controller responsibilities are blurred.
- Existing tests encode behavior that contradicts the requested change.

## Output

Resolved conflicts go into `Decisions / Gray Areas Resolved`.

Durable follow-up docs go into:

```md
## Required Documentation Updates
| Target | Update Needed | Reason |
|---|---|---|
```
