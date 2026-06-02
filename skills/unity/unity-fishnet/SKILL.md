---
name: unity-fishnet
description: Guides Unity multiplayer work that uses FishNet/Fish-Networking. Use when implementing, reviewing, debugging, or migrating NetworkManager setup, NetworkObject/NetworkBehaviour lifecycle, RPCs, SyncTypes, broadcasts, spawning/despawning, ownership, observers, scenes, Addressables, prediction, transports, serializers, or Mirror-to-FishNet migration.
---

# FishNet

## Overview

Use FishNet as the networking layer for client-server Unity multiplayer features: connection startup, authentication, object lifecycle, object-bound communication, persistent state synchronization, spawning, ownership, observer visibility, scene management, Addressables, prediction, and transport configuration.

During skill creation on 2026-05-24, the official FishNet repository `main` pointed at tag `4.7.2`, and the documentation repository had no official Agent/Codex/Claude/Gemini skill file. Always inspect the target project's installed FishNet files and `package.json` first; local version wins over this snapshot.

## Read First

Before adding or changing FishNet behavior:

1. Locate how FishNet is installed:
   - UPM package: `Packages/FishNet: Networking Evolved` or package cache.
   - Asset import: `Assets/FishNet`.
   - Git URL: `https://github.com/FirstGearGames/FishNet.git?path=Assets/FishNet`.
2. Inspect the local package version, release notes, project wrappers, asmdefs, and any project-specific networking conventions.
3. Inspect the scene or prefab with `NetworkManager`; it must not be a `NetworkObject` or be parent/child of one.
4. Inspect `NetworkManager` child managers: `ServerManager`, `ClientManager`, `TransportManager`, `TimeManager`, `PredictionManager`, `SceneManager`, `ObserverManager`, object pool, and any Authenticator.
5. Inspect affected prefabs for `NetworkObject`, `NetworkBehaviour`, `NetworkObserver`, `NetworkTransform`, `NetworkAnimator`, `NetworkTickSmoother`, `PredictedSpawn`, `PredictedOwner`, `OfflineRigidbody`, `NetworkCollider`, ownership, global, despawn, and prediction settings.
6. Check network prefab registration. For runtime/Addressables prefabs, confirm both server and clients register the same package collection ids before spawning.
7. Read only the reference files needed for the task.

## Reference Map

| Task or symptom | Read |
| --- | --- |
| General setup, namespaces, lifecycle, source anchors, review checklist | `references/quick-reference.md` |
| RPCs, SyncTypes, broadcasts, authentication, connection events, interactables | `references/communication-and-state.md` |
| Spawning, despawning, pooling, ownership, observers, scene loading, `SceneId ... not found in SceneObjects` | `references/spawning-scenes-observers.md` |
| NetworkTransform, NetworkAnimator, prediction movement, reconcile, smoothing, predicted spawn/ownership | `references/prediction-and-motion.md` |
| Addressables network prefabs or addressable scenes | `references/addressables-and-prefabs.md` |
| Mirror conversion, old API upgrades, component/property/RPC mapping | `references/mirror-migration.md` |
| Custom serializers, transports, dedicated servers, recurring warnings, final verification | `references/serialization-transports-debugging.md` |

## Implementation Workflow

1. Classify the networking need:
   - Object-bound one-shot command: RPC on a `NetworkBehaviour`.
   - Persistent object state, late joiners, respawns, UI restore: `SyncVar<T>` or a SyncType.
   - Global/non-object message, login, matchmaking, lobby traffic: broadcast using `IBroadcast`.
   - Runtime object lifecycle: server spawn/despawn plus optional pooling or Addressables registration.
   - Visibility/area-of-interest: observer conditions and scene membership.
   - Movement with correction: FishNet prediction or `NetworkTransform`, with one clear transform authority.
2. Decide authority first:
   - Server authoritative: clients request, server validates and mutates state.
   - Owner authoritative: owner provides input; server still validates critical effects.
   - Server-owned/no-owner object: use `IsController` or explicit server checks.
3. Put FishNet-specific code in `NetworkBehaviour` only when it needs FishNet lifecycle, RPCs, SyncTypes, ownership, observers, prediction, or per-object managers.
4. Use FishNet callbacks rather than Unity `Start` for network-initialized data.
5. Choose communication deliberately: `ServerRpc`, `ObserversRpc`, `TargetRpc`, SyncTypes, or broadcasts according to direction, ownership, persistence, and late-join behavior.
6. Verify with host plus a separate client when ownership, observer visibility, prediction, scene loading, authentication, Addressables, or transport behavior is involved.

## Project Rules

- Do not use old `[SyncVar]` or `[SyncObject]` attributes in new FishNet code. Use `readonly SyncVar<T>`, `SyncList<T>`, `SyncDictionary<TKey,TValue>`, `SyncHashSet<T>`, `SyncTimer`, or `SyncStopwatch`.
- Prefer `IsClientInitialized`, `IsServerInitialized`, `IsClientStarted`, `IsServerStarted`, and `IsController` over obsolete `IsClient`, `IsServer`, `IsHost`, and `HasAuthority`.
- Do not read `base.IsOwner` in `Awake`, `Start`, `OnStartNetwork`, or `OnStartServer`; use `base.Owner.IsLocalClient` there or wait for `OnStartClient`.
- Only the server spawns, despawns, changes server-synchronized SyncTypes, and grants/removes ownership in the normal server-authoritative path.
- Treat `RequireOwnership = false` and unauthenticated broadcasts as explicit security surfaces. Always validate the caller `NetworkConnection`.
- Do not send gameplay truth only through RPCs when late joiners or respawns need the latest value. Use SyncTypes or intentionally buffered RPCs.
- Do not couple separate SyncTypes by receive order. Make each replicated field self-contained or include an explicit sequence/version.
- Avoid having prediction, `NetworkTransform`, and manual writes independently author the same transform unless `NetworkTransform` is explicitly configured for prediction/spectator replication and ownership of each transform path is clear.
- Preserve observer conditions. Do not remove `SceneCondition` or use `Ignore Manager` on `NetworkObserver` until scene membership is understood.
- Treat `SceneManager.OnLoadEnd` as scene-load completion, not client observer readiness. Prefer `OnClientPresenceChangeEnd` or `OnSpawnServer` when a client must observe scene objects.
- For Addressables prefabs, never use collection id `0`; use a unique `ushort` in `1..65535`, and load/register bundles on clients before the server sends spawns or adds clients to scenes.
- For prediction, configure the `NetworkObject` inspector, use tick callbacks, always create reconcile data, use prediction helpers for physics, and keep gameplay colliders outside smoothed graphics.
- Finish Unity work with compilation, Console checks, and the repository's Unity completion gate when available.
