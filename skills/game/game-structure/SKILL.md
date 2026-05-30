---
name: game-structure
description: Decide where gameplay logic should live by separating game Module, State, Api, Result, Surface, and Adapter responsibilities. Use when creating, refactoring, or reviewing game systems; when gameplay rules are mixed with UI, animation, physics, networking, save/load, engine callbacks, or SDK code; or when a game module needs clear responsibility boundaries.
---

# Game Structure

Use this skill to place gameplay responsibilities before writing or refactoring game code. It is a responsibility-placement skill, not a framework generator.

## First Move

Inspect the project before inventing structure:

- Engine/runtime: Unity, Godot, Unreal, custom, or unknown.
- Gameplay Module: combat, buff, ability, inventory, quest, movement, save, networking, or another system.
- Existing project conventions, tests, asmdefs/modules, scenes/prefabs/resources, and domain docs.

Use engine-specific skills only when placement depends on engine APIs or framework behavior.

## Placement Table

| Writing | Role |
| --- | --- |
| Stable gameplay ownership boundary | Module |
| Pure runtime facts and current game truth | State |
| Read, validate, calculate, transition, or orchestrate State | Api |
| Structured success/failure, diagnostics, and optional emitted events | Result |
| Input, UI, view, scene object, animation/physics callback; calls Api only | Surface |
| Engine, network, save/load, SDK, filesystem, resource access | Adapter |

## Shape Standards

- State is pure runtime facts. It does not decide, call callbacks, touch external systems, or create Results.
- Api is the only place that interprets or changes State. It owns validation, calculation, transitions, and flow orchestration.
- Other Modules may call public Api, but must not import or mutate another Module's internal State.
- Adapter only touches external systems and passes facts/results to Api. Do not hide gameplay rules in Adapter.
- Surface only receives input or presents output and calls Api. Do not hide gameplay rules in Surface.
- Result only describes structured output: success/failure, ResultNotice items, and optional GameEvent items to consume later.
- Event is an interaction meaning, not a layer. EventKey is a stable event key, GameEvent is an occurred fact, subscriptions are State, dispatch/subscribe functions are Api, and dispatch output is Result.
- Data is not a default layer. Use it only as a normal domain word when it is precise, such as SaveData.
- Config is a module or domain capability, not a default layer.
- State and Api are naming, directory, dependency-direction, and test constraints. Do not add marker interfaces such as IState or IApi.
- Avoid broad aggregate objects named Bus, Manager, Registry, Controller, or Runner. Prefer explicit State plus focused Api files.

## Pre-Code Check

Before editing gameplay code, state:

```md
Game Structure Check:
- Module:
- Role:
- Why here:
- Must not live in:
- Engine/external boundary:
- Verification:
```

## Extraction Standard

Keep behavior local unless one is true:

- Reused by more than one caller.
- Hard to test where it is.
- Crosses Modules or runtime objects.
- Touches engine, network, save/load, SDK, filesystem, or resource loading.
- Hides a gameplay invariant.
- Likely to be extended by designers, content, AI, or networking.

Do not split every feature into all roles by default.

## Defaults

Module owns. State records. Api decides and performs. Result explains. Surface presents or receives. Adapter integrates.

## Common Misplacements

- Bad: UI button directly changes health. Good: UI Surface calls Api; Api changes State.
- Bad: Network RPC calculates damage. Good: Network Adapter passes request; Combat Api validates and resolves.
- Bad: ScriptableObject or Resource stores current cooldown. Good: a cooldown definition/config stores duration; State stores remaining cooldown.
- Bad: Animation event applies gameplay truth directly. Good: Animation Surface emits timing signal; Api owns outcome.
- Bad: Physics callback decides scoring. Good: Physics Surface/Adapter reports contact; Api decides score.
- Bad: EventBus stores subscriptions, validates publishing, invokes handlers, and aggregates diagnostics. Good: Event State stores subscriptions, Event Api subscribes/dispatches, Event Result reports diagnostics.

## Hand Off When

- Terms or design intent are unclear: use `grill-with-docs`.
- The user asks for red-green implementation: use `tdd`.
- There is broken gameplay behavior: use `diagnose`.
- The issue is engine/API-specific: use the relevant Unity, Godot, Unreal, networking, tweening, or SDK skill.

## References

- For module ownership and cross-module interaction, read `references/module-contract.md`.
- For runtime object and lifecycle boundaries, read `references/runtime-boundaries.md`.
