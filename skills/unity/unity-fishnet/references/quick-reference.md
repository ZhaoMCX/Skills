# FishNet Quick Reference

## Contents

- Official anchors
- Namespaces
- Setup checks
- NetworkBehaviour lifecycle
- Communication selection
- Core review questions

## Official Anchors

| Need | Source |
| --- | --- |
| Runtime source | `Assets/FishNet/Runtime` or installed package equivalent |
| Code generation | `Assets/FishNet/CodeGenerating` |
| Mirror upgrade tools | `Assets/FishNet/Upgrading` |
| Official docs | `https://fish-networking.gitbook.io/docs/` |
| Source repository | `https://github.com/FirstGearGames/FishNet` |
| Documentation repository | `https://github.com/FirstGearGames/FishNet-Documentation` |
| UPM Git URL | `https://github.com/FirstGearGames/FishNet.git?path=Assets/FishNet` |
| Researched snapshot | `com.firstgeargames.fishnet` `4.7.2`, Unity `2021.3` minimum; verify local package first |

No official Agent/Codex/Claude/Gemini skill file was found in the FishNet source or documentation repositories during skill creation.

## Namespaces

| Feature | Namespace |
| --- | --- |
| `NetworkBehaviour`, `NetworkObject`, RPC attributes | `FishNet.Object` |
| `NetworkConnection` | `FishNet.Connection` |
| SyncTypes and permissions | `FishNet.Object.Synchronizing` |
| Prediction attributes and data interfaces | `FishNet.Object.Prediction` |
| Channels and transport types | `FishNet.Transporting` |
| Manager lookup | `FishNet` for `InstanceFinder`, or manager properties on `NetworkBehaviour` |
| Broadcasts | `FishNet.Broadcast` |
| Serialization helpers | `FishNet.Serializing`, `FishNet.CodeGenerating` |
| Prefab collections | `FishNet.Managing.Object` |
| Authenticators | `FishNet.Authenticating` |

## Setup Checks

| Check | Why |
| --- | --- |
| One active `NetworkManager` path | Duplicate managers create confusing startup and object registry behavior. |
| `NetworkManager` is not a `NetworkObject` | Official docs warn the manager must not be on, under, or above a `NetworkObject`. |
| `TransportManager.Transport` configured | Empty uses default/first transport; explicit transport is clearer for builds. |
| `ObserverManager` has `SceneCondition` unless intentionally removed | Prevents objects from spawning into unrelated scenes. |
| Spawnable prefab collection includes network prefabs | Server spawn must map to a known prefab for clients. |
| Addressables collection ids are registered on both sides | Runtime prefab collections must exist before spawn messages are processed. |
| `ServerManager.ShareIds` understood | Required for clients to know other client IDs and remote connection events. |
| Authenticator assignment understood | Use `ServerManager.GetAuthenticator`/`SetAuthenticator`; old `NetworkManager.Authenticator` APIs are gone. |
| Headless server settings checked | `Start On Headless`, frame rate, timeout settings, authentication, and port binding affect dedicated builds. |

## NetworkBehaviour Lifecycle

| Callback/property | Use |
| --- | --- |
| `OnStartNetwork` | Shared network initialization. Called once even as host. Do not use `IsOwner`; use `Owner.IsLocalClient` if needed. |
| `OnStopNetwork` | Shared cleanup after server/client stop callbacks. |
| `OnStartServer` | Server initialization. SyncTypes changed here are included in spawn data. Observers are not built yet. |
| `OnSpawnServer(NetworkConnection)` | Per-observer post-spawn hook; good for tailored `TargetRpc`. |
| `OnDespawnServer(NetworkConnection)` | Last chance to send object-bound communication before despawn reaches a connection. |
| `OnStopServer` | Server cleanup; too late for object-specific client communication. |
| `OnStartClient` | Client initialization after Owner/ObjectId/SyncTypes are synchronized. Buffered RPCs run immediately after. |
| `OnOwnershipServer/Client` | Refresh authority, input, prediction cache, and owner UI. |
| `OnStopClient` | Client cleanup before deinitialization. |
| `WritePayload` / `ReadPayload` | Spawn payloads read before network start callbacks; use for initialization that should not wait on SyncTypes. |

Avoid obsolete properties in new code:

| Old | Prefer |
| --- | --- |
| `IsClient` | `IsClientInitialized` or `IsClientStarted` |
| `IsServer` | `IsServerInitialized` or `IsServerStarted` |
| `IsHost` | `IsHostInitialized` or `IsHostStarted` |
| `IsClientOnly` | `IsClientOnlyInitialized` or `IsClientOnlyStarted` |
| `IsServerOnly` | `IsServerOnlyInitialized` or `IsServerOnlyStarted` |
| `HasAuthority` | `IsController` |

`Initialized` usually answers "is this object ready on this side?" `Started` usually answers "is the socket/authenticated side running?"

## Communication Selection

| Need | Use | Detailed reference |
| --- | --- | --- |
| Owner asks server to do something | `[ServerRpc]` | `communication-and-state.md` |
| Any client asks server | `[ServerRpc(RequireOwnership = false)]` plus caller validation | `communication-and-state.md` |
| Server tells current observers | `[ObserversRpc]` | `communication-and-state.md` |
| Server tells one client | `[TargetRpc]` | `communication-and-state.md` |
| Server stores current state for observers | `SyncVar<T>` or Sync collections | `communication-and-state.md` |
| Message not tied to one object | `IBroadcast` | `communication-and-state.md` |
| Spawn-time initial data | `WritePayload` / `ReadPayload` | `spawning-scenes-observers.md` |
| Runtime prefab bundle | Addressables prefab collection | `addressables-and-prefabs.md` |
| Predicted movement | `[Replicate]` / `[Reconcile]` | `prediction-and-motion.md` |

## Core Review Questions

1. Which side is authoritative for each state mutation?
2. Which clients should observe the object at the time the message is sent?
3. Does a late joiner need this value?
4. Does host mode run the callback once or twice?
5. Are scene load and observer readiness being treated as separate milestones?
6. Are pooled objects resetting events, SyncTypes, owner-only UI, and local prediction cache?
7. Are Addressables prefabs registered before any spawn packet can reference them?
8. Is one system responsible for each transform, animator, and physics state?
9. Do custom serializers read exactly what writers wrote?
10. Has the feature been verified with host plus a separate client?
