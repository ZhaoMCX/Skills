# Profile Mapping Guide

Use only the relevant section for the target stack. Prefer the local ecosystem's common names inside the Profile, but always map them to AgentFramework concepts.

## Web Frontend

| AgentFramework | Common Mapping |
| --- | --- |
| Module | feature folder, route feature, domain package |
| Data | config, schema, route meta, content record, design token |
| State | UI state, store state, cache snapshot, session state |
| Rules | validation, permission checks, state transition, calculation |
| Surface | page, route component, UI component, form, canvas |
| UseCase | login, checkout, submit form, save draft, import/export flow |
| Event | submitted/closed/selected/loaded facts |
| Boundary | HTTP, storage, browser APIs, analytics, auth, payment |
| Port | business-side contract for external capability |
| Adapter | fetch client, localStorage wrapper, SDK integration |

## UniApp And Mini Program

| AgentFramework | Common Mapping |
| --- | --- |
| Module | feature under pages/components/store/service folders |
| Data | `pages.json` meta, config records, static content, schemas |
| State | page state, store state, session state, platform cache facts |
| Rules | validation, permission, business state transitions |
| Surface | page, component, layout, input handler |
| UseCase | login, payment, share, submit, sync, platform flow |
| Boundary | `uni` APIs, `wx` APIs, storage, request, auth, payment, share |
| Port | platform-neutral capability needed by UseCase |
| Adapter | UniApp or mini-program API implementation |

Use conditional compilation and platform APIs only in Adapters, Surfaces, or Binding-approved files. Keep Rules platform-neutral when practical.

## Backend

| AgentFramework | Common Mapping |
| --- | --- |
| Module | bounded feature, domain package, service area |
| Data | config, schema, static rules, DTO schema |
| State | persisted entity facts, aggregate state, cache facts |
| Rules | domain validation and state transitions |
| Surface | route handler, controller, resolver, webhook, CLI command |
| UseCase | application service or command handler |
| Event | domain event or integration fact |
| Boundary | database, queue, cache, email, payment, filesystem, third-party API |
| Port | repository/payment/email/cache contract defined by business side |
| Adapter | ORM repository, queue client, SDK client, filesystem implementation |

Do not put business decisions in ORM models, route handlers, queue consumers, or SDK clients.

## Unity

| AgentFramework | Common Mapping |
| --- | --- |
| Module | `Assets/Game/Modules/<ModuleName>` or package/assembly |
| Data | ScriptableObject, config class, static record |
| State | plain C# runtime facts |
| Rules | deterministic C# rules, preferably EditMode-testable |
| Surface | MonoBehaviour view, UI component, scene object |
| Ability | input/physics/animation-timed behavior |
| Controller | Ability scheduler |
| UseCase | cross-module gameplay flow |
| Boundary | Addressables, Input System, Save, Network, Audio, UI, Scene |
| Adapter | Unity/FishNet/Addressables/platform implementation |

## Godot

| AgentFramework | Common Mapping |
| --- | --- |
| Module | feature folder, addon, scene group |
| Data | Resource, config, static table |
| State | runtime facts outside presentation nodes when practical |
| Rules | deterministic scripts for validation and state transition |
| Surface | Node, Control, scene, HUD, input-facing script |
| Ability | timed interaction, physics, animation, action behavior |
| Controller | Ability or state-machine scheduler |
| Boundary | resource loading, save, network, input, audio, scene tree |
| Adapter | Godot API or plugin integration |

## Games And Interactive Tools

Use `Ability` when behavior depends on input snapshots, animation timing, physics, collision, gestures, pointer capture, drag state, or frame/tick lifecycle.

Use `Controller` only to choose active Ability, resolve priority, or coordinate mutually exclusive modes.

## Small Project Guidance

For small apps, a single document can be enough. It should still name:

- Surfaces.
- Rules that must not live in Surface.
- External Boundaries and Adapters.
- Verification commands.

Do not generate a full ModulePlan when a short module list answers the same Agent questions.
