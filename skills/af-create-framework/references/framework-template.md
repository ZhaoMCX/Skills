# AgentFramework Document Templates

Use these templates only as far as they help. Delete sections that do not make the target stack or project easier for a new agent to understand.

## Stack Profile: `<StackName>AgentFramework.md`

`<StackName>AgentFramework.md` is the reusable technology-stack, platform, or engine Profile. It must not include concrete product modules, business entities, feature facts, project folder paths, or project verification commands.

```markdown
# <StackName>AgentFramework

<StackName>AgentFramework, abbreviated <StackName>AF, is the AgentFramework Profile for <technology stack/platform/engine>. It helps agents map AF concepts to this technical environment.

## Principles

- Agent friendliness first.
- KISS first.
- Module is the primary coordinate for ownership, dependencies, write scope, and verification.
- Use the smallest structure that keeps responsibilities, dependencies, data flow, boundaries, and validation obvious.
- Keep this Profile free of concrete product modules, project paths, feature facts, and project commands.
- Do not introduce abstractions only for SOLID, design patterns, or framework completeness.

## Concept Mapping

| AgentFramework Concept | <Stack> Mapping | Notes |
| --- | --- | --- |
| Module |  | Project ModuleMap names concrete modules. |
| Data |  |  |
| State |  |  |
| Rules |  |  |
| Surface |  |  |
| UseCase |  |  |
| Event |  |  |
| Boundary |  |  |
| Port |  | Optional unless needed for tests, multiple implementations, or stable contracts. |
| Adapter |  |  |
| Ability |  | Optional for interaction, timing, games, tools, and state machines. |
| Controller |  | Optional scheduler or arbiter; not a generic service bucket. |
| Result |  |  |

## General Directory And Naming Guidance

Describe stack-level naming patterns without concrete project paths.

| AF Element | Recommended Naming | Responsibility Rule |
| --- | --- | --- |
| Data |  |  |
| State |  |  |
| Rules |  |  |
| Surface |  |  |
| UseCase |  |  |
| Event |  |  |
| Boundary |  |  |
| Port |  |  |
| Adapter |  |  |
| Ability |  |  |
| Controller |  |  |

## Stack Boundaries

| Boundary Type | Allowed AF Location | Forbidden Location |
| --- | --- | --- |
|  |  |  |

## Feature Planning Protocol

When planning a feature:

1. Identify the Primary Module from the project ModuleMap.
2. Map changed files to AF elements using the project Binding.
3. Keep Rules free of platform and external boundary calls.
4. Write BDD Acceptance Scenarios.
5. Derive tests from AF elements.
6. Plan TDD slices with expected RED, minimal GREEN, and verification commands.

## Verification By AF Element

| AF Element | Verification Family |
| --- | --- |
| Data | Schema / serialization / validation tests. |
| State | State transition tests. |
| Rules | Pure behavior and invariant tests. |
| UseCase | Orchestration, state-change, and boundary-call tests. |
| Event | Event fact and observation tests. |
| Boundary / Port / Adapter | Contract / adapter tests. |
| Ability | Timing, interaction, gesture, or action tests. |
| Controller | Input, scheduling, priority, cancellation, pause/resume tests. |
| Surface | UI, route, scene, API, CLI, screenshot, accessibility, or platform smoke tests. |
| Regression | Bug reproduction tests. |

## Agent Development Protocol

When changing a project using this Profile, an agent must:

1. Read this Profile, then the project Binding and ModuleMap.
2. Identify affected Module, AF elements, boundaries, and allowed write scope.
3. State intended write set before broad edits.
4. Keep Rules free of platform, storage, network, SDK, database, browser, engine, or UI calls.
5. Add or update tests when Rules, UseCases, Ports, Adapters, Abilities, Controllers, or Surfaces change.
6. Run verification commands from the project Binding and ModuleMap.
7. Report changed files, verification evidence, and remaining risks.

## Escalation Rules

- If simple Surface-local behavior stays understandable, keep it local.
- If a rule is reused or changes State, move it to Rules.
- If a flow crosses Modules or Boundaries, use a UseCase.
- If external capability must be tested, swapped, or stabilized, introduce a Port.
- If platform/API/SDK code appears, place it in an Adapter or Binding-approved Surface/Controller file.

## Anti-Patterns

- Hiding business rules in Surface.
- Putting platform APIs in Rules.
- Using Events as commands.
- Creating Ports for every class.
- Introducing design patterns before a real local need exists.
- Encoding project modules, feature facts, concrete paths, or project commands in this Profile.
```

## Project Binding: `<ProjectName>Binding.md`

`<ProjectName>Binding.md` applies a stack Profile to a concrete repository. It owns paths, naming, commands, dependency rules, generated-file rules, and evidence artifact rules.

```markdown
# <ProjectName>Binding

<ProjectName>Binding applies `<StackName>AgentFramework.md` to this repository.

## Project Shape

| Path | Purpose | AF Ownership |
| --- | --- | --- |
|  |  |  |

## Naming Rules

| Pattern | Required Meaning |
| --- | --- |
|  |  |

## Public Entrypoints

| Entrypoint | Contract |
| --- | --- |
|  |  |

## Dependency Rules

| From | May Depend On | Must Not Depend On |
| --- | --- | --- |
|  |  |  |

## Generated / Evidence Files

| Path Pattern | Rule |
| --- | --- |
|  |  |

## Verification Commands

| Gate | Command / Check | Expected Evidence |
| --- | --- | --- |
|  |  |  |
```

## Project ModuleMap: `<ProjectName>ModuleMap.md`

`<ProjectName>ModuleMap.md` owns concrete Modules, AF element inventory, boundaries, write scope, current behavior, and test obligations. It is a long-lived module boundary map, not a feature execution plan.

```markdown
# <ProjectName>ModuleMap

<ProjectName>ModuleMap describes concrete project Modules and AF responsibilities. It depends on `<StackName>AgentFramework.md` and `<ProjectName>Binding.md`.

## ModuleMap

| Module | Type | Owns | Exposes | Allowed Dependencies | Forbidden Dependencies | Verification |
| --- | --- | --- | --- | --- | --- | --- |
|  | Domain/Feature/Infrastructure | Data/State/Rules/Surface/UseCase/Event/Ability/Controller |  |  |  |  |

## AF Element Inventory

| AF Element | File / Location | Responsibility |
| --- | --- | --- |
|  |  |  |

## Boundaries

| Boundary | Port Needed? | Adapter(s) | Rule |
| --- | --- | --- | --- |
|  | Yes/No |  |  |

## Current Acceptance Scenarios

Use Gherkin-style scenarios only for current durable behavior that future agents need to preserve.

```gherkin
Scenario: <observable behavior>
  Given <initial state>
  When <user action or system event>
  Then <visible or business result>
```

## Test Matrix

| AF Element | Test Location | Required Behavior |
| --- | --- | --- |
|  |  |  |

## Write Scope Rules

- Keep project-specific facts here or in the Binding.
- Do not add project facts to `<StackName>AgentFramework.md`.
```

## Filename Rules

Use full names:

- `<StackName>AgentFramework.md`
- `<ProjectName>Binding.md`
- `<ProjectName>ModuleMap.md`

Do not use abbreviated filenames such as `<Name>AF.md`. Do not use `AgentFramework` in project-specific Binding or ModuleMap filenames unless an existing project convention already requires it.
