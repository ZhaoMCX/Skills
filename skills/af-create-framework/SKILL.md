---
name: af-create-framework
description: Use when creating or restructuring a technology-stack/platform/engine-specific XXXAgentFramework profile such as UnityAgentFramework, WebAppAgentFramework, BackendServiceAgentFramework, UniAppAgentFramework, or WebGameAgentFramework, plus project-specific Binding and ModuleMap files that apply that profile without polluting it with product facts.
---

# AF Create Framework

Create a concrete technology-stack, platform, or engine `XXXAgentFramework` profile, then put project-specific facts in separate Binding and ModuleMap files.

`XXXAgentFramework.md` is the reusable Profile layer. It must describe how AgentFramework concepts map to a technology environment. It must not define concrete product modules, business entities, feature facts, project paths, or project verification commands.

## Design Philosophy

- Agent friendliness first: the framework and project documents must help future agents quickly answer what owns a change, where behavior belongs, what must not be touched, and how to prove correctness.
- KISS first: create the smallest framework shape that makes the project understandable and verifiable.
- Do not add AF documents, elements, boundaries, Ports, Adapters, or patterns for completeness.
- Keep the Profile layer reusable. Prefer technology-stack language in `XXXAgentFramework.md`; put local project language and concrete naming in Binding and ModuleMap documents.
- Do not trade clarity for fewer files. A small project may use short Binding and ModuleMap files, but do not mix project facts into a stack Profile.

## Workflow

1. Inspect local project structure, package/build files, tests, docs, routes/scenes/pages, generated files, and platform conventions.
2. Read `references/core-concepts.md` for canonical AF concepts.
3. Read only the relevant section of `references/profile-mapping-guide.md`.
4. Use `references/framework-template.md` as the starting shape.
5. Create the smallest useful document set:
   - Always create or update one technology-stack Profile: `<StackName>AgentFramework.md`.
   - For a concrete project, also create or update `<ProjectName>Binding.md` and `<ProjectName>ModuleMap.md`.
   - If no concrete project exists, create only the Profile and leave Binding/ModuleMap for the future project.
6. In `<StackName>AgentFramework.md`, include stack-level Concept Mapping, general naming guidance, stack boundaries, development protocol, escalation rules, anti-patterns, and generic verification families.
7. In `<ProjectName>Binding.md`, include actual project folders, file naming, public APIs, generated-file rules, dependency rules, test/build/validation commands, and evidence artifact rules.
8. In `<ProjectName>ModuleMap.md`, include concrete Modules, AF element inventory, boundaries, allowed dependencies, write scope, BDD/current behavior, test matrix, and verification obligations.
9. Verify a future agent can answer: which rules are stack-generic, which paths and commands are project-specific, what Module owns a change, what AF element each file belongs to, what boundaries are involved, what can be edited, and what commands prove correctness.

## Output Rules

- Use full names for official files: `<Name>AgentFramework.md`, not `<Name>AF.md`.
- Use `AgentFramework` only for the technology-stack/platform/engine Profile layer.
- Do not name project-specific files `XXXAgentFramework.md`. Use `<ProjectName>Binding.md` and `<ProjectName>ModuleMap.md` unless the project already has an established compatible naming convention.
- Keep canonical AF role names in English.
- Use local language for explanatory body text when useful, while preserving role terms, paths, commands, and code identifiers.
- Prefer local ecosystem names inside the profile, then map them back to AF roles.
- Do not put concrete product modules, business entities, feature plans, project folder paths, or project commands in `<StackName>AgentFramework.md`.
- Put concrete project paths, naming conventions, public contracts, dependency rules, and verification commands in `<ProjectName>Binding.md`.
- Put concrete Modules, AF element inventories, boundaries, BDD/current behavior, test matrix, and write scopes in `<ProjectName>ModuleMap.md`.
- Do not force every role into a separate file.
- Do not introduce design patterns for completeness.
- Do not make the framework harder for agents to use in the name of architectural purity.

## References

- `references/core-concepts.md`
- `references/framework-template.md`
- `references/profile-mapping-guide.md`
