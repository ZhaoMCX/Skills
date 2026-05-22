# AgentFramework Core Concepts

Use these concepts as a responsibility language. Do not treat them as mandatory files or runtime types.

## Philosophy

- Agent friendliness first: concepts exist to reduce agent guessing and make work easier to plan, implement, review, and verify.
- KISS first: use the simplest concept level that keeps responsibility, dependency, and validation obvious.
- Do not escalate to a heavier AF element, boundary, Port, Adapter, or ModuleMap unless it removes real ambiguity, enables testing, protects a boundary, or prevents future rework.
- Concrete names, examples, tests, and verification are more valuable than abstract completeness.

## Concepts

| Concept | Responsibility |
| --- | --- |
| Module | Stable business or engineering capability boundary. Primary coordinate for ownership, write scope, dependencies, and verification. |
| Data | Static configuration, schemas, metadata, content records, design tokens, rule parameters. |
| State | Runtime facts, domain facts, UI state, cached facts, persisted entity state. |
| Rules | Deterministic decisions: "can this happen?" and "how does State change?" |
| Surface | System contact layer: UI, page, route, component, scene, view, node, HTTP handler, resolver, webhook, CLI command. |
| UseCase | Explicit business flow across Modules, Rules, State, Events, or Boundaries. |
| Event | A fact that already happened. It is not a command and not required hidden control flow. |
| Boundary | Architecture boundary for external or cross-layer capability that core logic should not touch directly. |
| Port | Business-side minimal contract for a Boundary. Optional; add for tests, multiple implementations, or stable contracts. |
| Adapter | Concrete connection to platform, SDK, database, browser, engine, network, storage, file system, payment, or another external system. |
| Ability | Temporal, interactive, or engine-timed behavior such as drag, gesture, animation windows, physics, character actions, editor tools, or complex input modes. |
| Controller | Scheduler or arbiter for Abilities, state machines, input modes, turn flow, tools, or timing. Avoid generic catch-all services. |
| Result | Structured success/failure and stable failure reason. Prefer when callers need to understand failure. |
| Profile | Mapping from AF concepts to a technology stack, platform, or product domain. |
| Binding | Project-specific directory, naming, public API, dependency, testing, build, generation, and validation rules. |
| ModuleMap | Project-specific map of Modules, boundaries, allowed dependencies, write sets, and verification. |

## Escalation Path

```text
Inline local logic
-> named function
-> Rules
-> UseCase
-> Boundary
-> Port + Adapter
-> full ModuleMap
```

Use the simplest level that preserves agent readability. Do not abstract the first implementation unless the variation is already real.

## Boundaries

`Surface`, `Boundary`, `Port`, and `Adapter` are distinct:

| Concept | Meaning |
| --- | --- |
| Surface | Entry or presentation contact with user, caller, request, input, or runtime. |
| Boundary | Declared external capability that must be isolated. |
| Port | Business-side contract for a Boundary. |
| Adapter | Concrete external implementation. |

Typical flow:

```text
Surface -> UseCase -> Rules -> State
                  -> Port -> Adapter
```

## Testing By Element

| AF Element | Test family |
| --- | --- |
| Data | Schema, serialization, validation tests. |
| State | State transition tests. |
| Rules | Pure behavior and invariant tests. |
| UseCase | Orchestration, state-change, and boundary-call tests. |
| Event | Event flow tests. |
| Boundary / Port / Adapter | Contract and adapter tests. |
| Ability | Ability behavior tests. |
| Controller | Input, timing, scheduling, and state-machine tests. |
| Surface | Route, UI, scene, prefab, API, CLI, or editor tests. |
| Regression | Bug reproduction tests. |

## Anti-Patterns

- Files are few but each hides many responsibilities.
- Every class has an interface.
- Events are commands.
- UseCases become service locators.
- Rules call platform APIs directly.
- Ports mirror SDK APIs instead of business needs.
- Adapters decide business outcomes.
- Future-only variation causes factories, registries, strategies, or plugin systems before there is a real second implementation.
