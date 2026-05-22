---
name: agent-framework
description: Use when creating, adapting, or reviewing an AgentFramework guide for a specific project, technology stack, frontend app, backend service, game engine, mini program, or cross-platform codebase.
---

# Agent Framework

Use this skill to create or revise a project-specific AgentFramework guide. AgentFramework is an Agent-friendly responsibility language, not a mandatory runtime, layered framework, SOLID exercise, or design-pattern catalog.

## Highest Priority

Optimize for:

1. Agent friendliness.
2. KISS.

Choose the smallest structure that lets a new Agent quickly see responsibilities, dependencies, data flow, external boundaries, allowed write areas, and verification commands.

Do not add abstractions to satisfy SOLID, design patterns, or framework completeness. Do not hide responsibilities just to reduce file count.

## Naming Rules

- Use full names for official skill names, directories, filenames, document titles, templates, and generated framework names.
- Use abbreviations only in document body text.
- `AgentFramework` abbreviates to `AF`.
- A project-specific abbreviation must end with `AF`.
- Example: `UniAppAgentFramework.md` is valid; inside it, state `UniAppAgentFramework, abbreviated UniAppAF`.
- Do not name official files `UniAppAF.md`, `WebAFBinding.md`, or similar abbreviated forms.

## Language And Terminology Rules

- Optimize for Agent friendliness over language purity.
- Use English full names for official skill names, directories, filenames, document titles, templates, and generated framework names.
- Prefer English section headings for stable scanning, search, and cross-file references.
- Keep canonical AgentFramework role terms in English: `Module`, `Data`, `State`, `Rules`, `Surface`, `UseCase`, `Event`, `Boundary`, `Port`, `Adapter`, `Ability`, and `Controller`.
- For projects whose team language is not English, use that local language for explanatory body text while preserving English headings, role terms, code identifiers, paths, commands, and verification targets.
- For Chinese Unity projects, the recommended style is English structure and role terms with Chinese explanations.
- Do not translate canonical role terms into multiple local-language synonyms or use translated role names as official names.

## Creation Workflow

1. Identify whether the target is a technology-stack AgentFramework, a project-specific AgentFramework, or a revision to an existing one.
2. Inspect local project structure, package/build files, existing docs, test commands, and platform conventions.
3. Read `references/core-concepts.md` for canonical concepts when responsibilities are unclear.
4. Read `references/profile-mapping-guide.md` only for the relevant stack or domain.
5. Create the smallest useful document set:
   - Small project: one `<Name>AgentFramework.md` with concise Binding and ModulePlan sections.
   - Normal project: `<Name>AgentFramework.md`, `<Name>AgentFrameworkBinding.md`, and `<Name>AgentFrameworkModulePlan.md`.
   - Existing framework: revise the minimum documents needed.
6. Use `references/framework-template.md` as the starting structure, then delete sections that are not useful for the project.
7. Verify the finished guide lets a new Agent answer:
   - What Module owns this change?
   - Is each new file Data, State, Rules, Surface, UseCase, Event, Port, Adapter, or documentation?
   - Which external Boundary is involved?
   - What write set is allowed?
   - What tests or validation commands prove the change?

## Required Output Qualities

- Prefer local ecosystem names inside the Profile, but map them back to AgentFramework roles.
- Keep `Surface` distinct from `Port`: Surface is the system contact layer; Port is a business-side external capability contract.
- Keep `Boundary` distinct from `Adapter`: Boundary declares what must be isolated; Adapter is the concrete platform, SDK, database, browser, engine, or service implementation.
- Make `Port` optional. Add it only for tests, multiple implementations, stable public contracts, or clear external capability seams.
- Make `Ability` and `Controller` optional Profile extensions for games, complex interaction, temporal behavior, state machines, editors, or tools.
- Include explicit anti-patterns for the target stack.

## Avoid

- Do not create one interface per class.
- Do not introduce Factory, Strategy, Repository, Command Bus, Service Locator, or Observer patterns unless the local problem already needs them.
- Do not make Events required hidden control flow.
- Do not let Rules call platform APIs, SDKs, databases, storage, network, browser, engine, or UI APIs directly.
- Do not force every small feature into Data/State/Rules/UseCase/Port/Adapter files.
- Do not call a backend route, frontend page, game view, or CLI command `Interface`; use `Surface` as the cross-domain role.

## Relationship To SOLID And Patterns

Use SOLID only as a lightweight check:

- SRP: responsibilities should be clear.
- ISP: Ports should stay small.
- DIP: UseCases should depend on business-side Ports when external capabilities need isolation.

KISS and Agent readability override SOLID purity and design-pattern completeness.
