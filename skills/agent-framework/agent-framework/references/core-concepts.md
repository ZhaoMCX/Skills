# AgentFramework Core Concepts

Use these concepts as a responsibility language. Do not treat them as mandatory files or runtime types.

## Core Principle

AgentFramework exists to make codebases easy for Agents and humans to understand, modify, and verify. It follows KISS: add only the structure needed to make responsibilities, dependencies, data flow, boundaries, and validation obvious.

## Concepts

| Concept | Responsibility | Required? |
| --- | --- | --- |
| Module | Stable business or engineering capability boundary. | Required as a thinking tool; explicit docs for normal and large projects. |
| Data | Static configuration, schemas, metadata, content records, design tokens, rule parameters. | Use when static values matter. |
| State | Runtime facts, domain facts, UI state, cached facts, persisted entity state. | Use when mutable facts matter. |
| Rules | Deterministic decisions: "can this happen?" and "how does State change?" | Required when business or interaction rules exist. |
| Surface | The system contact layer: UI, page, route, component, game view, node, HTTP handler, resolver, webhook, CLI command. | Required when receiving input or presenting output. |
| UseCase | Explicit business flow across Modules, Rules, State, Events, or Boundaries. | Use for cross-module or reusable flows; skip for simple local behavior. |
| Event | A fact that already happened. It is not a command and not required hidden control flow. | Optional observation output. |
| Boundary | Architecture boundary for external or cross-layer capability that core logic should not touch directly. | Required as a concept for external systems. |
| Port | Business-side minimal contract for a Boundary. | Optional; add for tests, multiple implementations, or stable contracts. |
| Adapter | Concrete connection to platform, SDK, database, browser, engine, network, storage, file system, payment, resource, or other external system. | Required when external systems are accessed. |
| Result | Structured success/failure and stable failure reason. | Prefer when callers need to understand failure. |
| Profile | Mapping from AgentFramework concepts to a technology stack or platform. | Required for technology-stack-specific frameworks. |
| Binding | Project-specific directory, naming, API, dependency, testing, build, and generation rules. | Required for project-specific frameworks, can be short. |
| ModulePlan | Project-specific list of Modules, Boundaries, Ports, Adapters, UseCases, allowed dependencies, write sets, and verification. | Required for medium/large projects; small projects may use a short module list. |

## KISS Escalation Path

Use the simplest level that preserves Agent readability:

```text
Inline local logic
-> named function
-> Rules
-> UseCase
-> Boundary
-> Port + Adapter
-> full ModulePlan
```

Do not abstract the first implementation unless the variation is already known. When a second real implementation appears, extract the stable Port, Rules, or UseCase.

## Surface, Port, Boundary, Adapter

These concepts must not be confused:

| Concept | Meaning | Example |
| --- | --- | --- |
| Surface | Entry or presentation contact with user, caller, request, input, or runtime. | `LoginPage`, `PostOrderRoute`, `InventoryView`, `ImportCliCommand` |
| Boundary | Declared external capability that must be isolated. | Auth Boundary, Payment Boundary, Storage Boundary |
| Port | Business-side contract for a Boundary. | `AuthPort`, `PaymentPort`, `StoragePort` |
| Adapter | Concrete external implementation. | `UniAppAuthAdapter`, `StripePaymentAdapter`, `LocalStorageAdapter` |

Typical flow:

```text
Surface -> UseCase -> Rules -> State
                  -> Port -> Adapter
```

Rules should not directly call Adapter. UseCases may depend on Ports when external capabilities are part of the business flow.

## Optional Extensions

Use `Ability` for temporal, interactive, or engine-timed behavior such as drag, gesture, animation windows, physics, character actions, editor tools, or complex input modes.

Use `Controller` only to schedule or arbitrate Abilities. Avoid using generic `Controller` as a catch-all business service.

## Anti-Patterns

- Files are few but each hides many responsibilities.
- Every class has an interface.
- Events are commands.
- UseCases become service locators.
- Rules call platform APIs directly.
- Ports mirror SDK APIs instead of business needs.
- Adapters decide business outcomes.
- Future-only variation causes factories, registries, strategies, or plugin systems before there is a real second implementation.
