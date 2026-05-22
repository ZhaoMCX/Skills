# Clarify Requirements

Use this as the entrypoint for AF-native planning clarification. It prepares the built-in grilling stages; it does not depend on external skills.

## Explore Before Asking

Read the current `XXXAgentFramework`, ModulePlan, existing docs, related code, routes/scenes/pages, tests, and terminology before asking user questions.

## Built-In Stages

Run these stages before Module Impact Map:

1. Requirement Grilling: `references/requirement-grilling.md`
2. Domain Consistency Grilling: `references/domain-consistency-grilling.md`
3. Option Framing when a real tradeoff exists: `references/option-framing.md`

## Clarify Only What Matters

- User goal and success criteria.
- Domain terms and terminology conflicts.
- Business rules and invariants.
- State and lifecycle changes.
- Surface entry points.
- Error, empty, invalid, and permission paths.
- External boundaries: API, storage, network, SDK, engine, browser, platform.
- What is explicitly out of scope.

Ask one blocking question at a time. If code, docs, framework, routes, scenes, tests, configs, or manifests can answer, inspect instead of asking. When asking, provide a recommended answer.

## Output

Capture decisions as:

```md
## Decisions / Gray Areas Resolved
| Question | Decision | Reason |
|---|---|---|
```

Keep unresolved questions out of the final plan unless the user explicitly accepts them as assumptions.
