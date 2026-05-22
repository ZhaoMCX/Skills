# Profile Mapping Guide

Use only the relevant section. Prefer local ecosystem names inside the Profile, but always map them to AgentFramework concepts.

## Web Frontend

| AgentFramework | Common Mapping |
| --- | --- |
| Module | Feature folder, route feature, domain package. |
| Data | Config, schema, route meta, content record, design token. |
| State | UI state, store state, cache snapshot, session state. |
| Rules | Validation, permission checks, state transition, calculation. |
| Surface | Page, route component, UI component, form, canvas. |
| UseCase | Login, checkout, submit form, save draft, import/export flow. |
| Event | Submitted, closed, selected, loaded facts. |
| Boundary | HTTP, storage, browser APIs, analytics, auth, payment. |
| Port | Business-side contract for external capability. |
| Adapter | Fetch client, localStorage wrapper, SDK integration. |
| Ability | Drag/drop, gesture, canvas interaction, editor tool action. |
| Controller | Flow controller, input mode coordinator, editor controller. |

## UniApp And Mini Program

| AgentFramework | Common Mapping |
| --- | --- |
| Module | Feature under pages/components/store/service folders. |
| Data | `pages.json` meta, config records, static content, schemas. |
| State | Page state, store state, session state, platform cache facts. |
| Rules | Validation, permission, business state transitions. |
| Surface | Page, component, layout, input handler. |
| UseCase | Login, payment, share, submit, sync, platform flow. |
| Boundary | `uni` APIs, `wx` APIs, storage, request, auth, payment, share. |
| Port | Platform-neutral capability needed by UseCase. |
| Adapter | UniApp or mini-program API implementation. |
| Ability | Gesture, picker flow, media capture, drag, map interaction. |
| Controller | Page flow coordinator, platform interaction coordinator. |

Use conditional compilation and platform APIs only in Adapters, Surfaces, or Binding-approved files. Keep Rules platform-neutral when practical.

## Backend

| AgentFramework | Common Mapping |
| --- | --- |
| Module | Bounded feature, domain package, service area. |
| Data | Config, schema, static rules, DTO schema. |
| State | Persisted entity facts, aggregate state, cache facts. |
| Rules | Domain validation and state transitions. |
| Surface | Route handler, controller, resolver, webhook, CLI command. |
| UseCase | Application service or command handler. |
| Event | Domain event or integration fact. |
| Boundary | Database, queue, cache, email, payment, filesystem, third-party API. |
| Port | Repository/payment/email/cache contract defined by business side. |
| Adapter | ORM repository, queue client, SDK client, filesystem implementation. |

Do not put business decisions in ORM models, route handlers, queue consumers, or SDK clients.

## Unity

| AgentFramework | Common Mapping |
| --- | --- |
| Module | `Assets/Game/Modules/<ModuleName>` or package/assembly. |
| Data | ScriptableObject, config class, static record. |
| State | Plain C# runtime facts. |
| Rules | Deterministic C# rules, preferably EditMode-testable. |
| Surface | MonoBehaviour view, UI component, scene object, prefab. |
| Ability | Input/physics/animation-timed behavior. |
| Controller | Ability scheduler, state-machine or turn coordinator. |
| UseCase | Cross-module gameplay flow. |
| Event | Gameplay fact, not command. |
| Boundary | Addressables, Input System, Save, Network, Audio, UI, Scene. |
| Port | Game-side contract for save, input, network, assets, audio, or platform capability. |
| Adapter | Unity/FishNet/Addressables/platform implementation. |

## Godot

| AgentFramework | Common Mapping |
| --- | --- |
| Module | Feature folder, addon, scene group. |
| Data | Resource, config, static table. |
| State | Runtime facts outside presentation nodes when practical. |
| Rules | Deterministic scripts for validation and state transition. |
| Surface | Node, Control, scene, HUD, input-facing script. |
| Ability | Timed interaction, physics, animation, action behavior. |
| Controller | Ability or state-machine scheduler. |
| Boundary | Resource loading, save, network, input, audio, scene tree. |
| Adapter | Godot API or plugin integration. |

## Games And Interactive Tools

Use `Ability` when behavior depends on input snapshots, animation timing, physics, collision, gestures, pointer capture, drag state, or frame/tick lifecycle.

Use `Controller` only to choose active Ability, resolve priority, or coordinate mutually exclusive modes.

## Small Project Guidance

For small apps, one document can be enough. It should still name:

- Modules.
- Surfaces.
- Rules that must not live in Surface.
- External Boundaries and Adapters.
- Verification commands.

Do not generate a full ModuleMap when a short module list answers the same agent questions.
