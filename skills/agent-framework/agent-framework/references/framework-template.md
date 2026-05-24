# AgentFramework Document Template

Copy this shape only as far as it helps. Delete sections that do not make the target project easier for a new Agent to understand.

```markdown
# <Name>AgentFramework

<Name>AgentFramework, abbreviated <Name>AF, is the AgentFramework guide for <technology stack/project>. It exists to help Agents and humans place code, preserve boundaries, and verify changes with the smallest useful structure.

## Principles

- Agent friendliness first.
- KISS first.
- Use the smallest structure that keeps responsibilities, dependencies, data flow, boundaries, and verification obvious.
- Do not introduce abstractions only for SOLID, design patterns, or framework completeness.

## Concept Mapping

| AgentFramework Concept | <Stack/Project> Mapping | Notes |
| --- | --- | --- |
| Module |  |  |
| Data |  |  |
| State |  |  |
| Rules |  |  |
| Surface |  |  |
| UseCase |  |  |
| Event |  |  |
| Boundary |  |  |
| Port |  | Optional unless needed. |
| Adapter |  |  |
| Result |  |  |

## Directory And Naming Binding

Describe the actual project folders, naming conventions, public APIs, generated files, dependency rules, test commands, build commands, and validation commands.

## ModulePlan

| Module | Type | Owns | Exposes | Allowed Dependencies | Forbidden Dependencies | Verification |
| --- | --- | --- | --- | --- | --- | --- |
|  | Domain/Feature/Infrastructure | Data/State/Rules/Surface/UseCase/Event |  |  |  |  |

## Boundaries

| Boundary | Port Needed? | Adapter(s) | Rules |
| --- | --- | --- | --- |
|  | Yes/No |  |  |

## Agent Development Protocol

When changing this project, an Agent must:

1. Read this AgentFramework guide first.
2. Identify the affected Module, Surface, Rules, UseCase, Boundary, Port, or Adapter.
3. State the intended write set before broad edits.
4. Keep Rules free of platform, storage, network, SDK, database, browser, engine, or UI calls.
5. Add or update tests when Rules, UseCases, Ports, or Adapters change.
6. Run the verification commands listed for affected Modules.
7. Report changed files, verification evidence, and remaining risks.

## Escalation Rules

- If a simple Surface-local change stays understandable, keep it local.
- If a rule is reused or changes State, move it to Rules.
- If a flow crosses Modules or Boundaries, use a UseCase.
- If external capability must be tested, swapped, or stabilized, introduce a Port.
- If platform/API/SDK code appears, place it in an Adapter.

## Anti-Patterns

- Hiding business rules in Surface.
- Putting platform APIs in Rules.
- Using Events as commands.
- Creating Ports for every class.
- Introducing design patterns before a real local need exists.
```

## Filename Rules

Use full names:

- `<Name>AgentFramework.md`
- `<Name>AgentFrameworkBinding.md`
- `<Name>AgentFrameworkModulePlan.md`

Do not use abbreviated filenames such as `<Name>AF.md` or `<Name>AFBinding.md`.
