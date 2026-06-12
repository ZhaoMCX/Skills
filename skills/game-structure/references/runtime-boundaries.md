# Runtime Boundaries

Game systems often fail when runtime objects become the place where every responsibility lives. Classify runtime code before editing.

## Default Mapping

| Runtime artifact | Default role | Notes |
| --- | --- | --- |
| Scene object / MonoBehaviour / Node / Actor | Surface | Receives input, presents state, forwards timing/callbacks. |
| UI widget / HUD / Control | Surface | Presents and requests; does not own gameplay truth. |
| Animation callback | Surface | Timing signal only; not a business decision. |
| Physics callback | Surface or Adapter | Reports contact/query result; Api decides outcome. |
| Network callback / RPC handler | Adapter or Surface | Transports request/fact; does not calculate gameplay truth. |
| Save/load service | Adapter | Persists and restores State; does not invent State transitions. |
| Static definition / config table / Resource / ScriptableObject / DataAsset | Domain definition | Static input by default; name it by domain meaning, not as a default layer. |
| Plain class/struct | State, Api, Result, or domain value | Preferred home for testable gameplay core. |

## Lifecycle Standards

- Keep initialization, binding, and cleanup separate from gameplay decisions.
- Do not rely on frame callbacks as the only way to test Api.
- Use runtime objects to bridge engine events into Api.
- Store current runtime facts in State or runtime instances, not shared static definitions/assets.
- Emit Results or Events when gameplay core finishes; let Surfaces and Adapters react.

## Engine Vocabulary Examples

These examples are anchors, not engine-specific rules. Local project conventions win.

| Role | Unity examples | Godot examples | Unreal examples |
| --- | --- | --- | --- |
| Surface | `MonoBehaviour`, UI component, Animator event | `Node`, `Control`, signal bridge | `Actor`, `Widget`, animation notify |
| State | Plain C# instance, runtime component field | Plain GDScript/C# object, runtime node field | Plain object/struct, runtime component field |
| Api | Plain C# function set/service | Plain script object/function set | Plain object/function set, subsystem function |
| Adapter | Addressables, SDK, save/network wrapper | file/network/resource wrapper | subsystem/API/save/network wrapper |

## Red Flags

- A UI/scene object owns a gameplay invariant.
- An animation, physics, or network callback directly changes score, damage, cooldown, quest progress, or rewards.
- A static definition asset stores per-player or per-entity current values.
- A save/network adapter validates gameplay eligibility.
- A lifecycle method is the only place a core behavior can run.
