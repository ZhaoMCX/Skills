# Spawning, Scenes, And Observers

Use this when working with server spawn/despawn, object pooling, ownership, observer conditions, scene loading, scene visibility, or scene object errors.

## Spawning, Despawning, Pooling

| Task | Pattern |
| --- | --- |
| Spawn without owner | `InstanceFinder.ServerManager.Spawn(go)` or `base.Spawn(nob)` on server. |
| Spawn with owner | `ServerManager.Spawn(nob, ownerConnection)`. |
| Despawn | `base.Despawn()`, `networkObject.Despawn()`, or `ServerManager.Despawn(nob)`. |
| Pool on despawn | `ServerManager.Despawn(nob, DespawnType.Pool)` or set NetworkObject default despawn type. |
| Retrieve pooled object | `NetworkManager.GetPooledInstantiated(prefab, position, rotation, asServer: true)`. |
| Prewarm | `InstanceFinder.NetworkManager.CacheObjects(prefab, count, asServer)`. |

Rules:

- Networked objects require `NetworkObject` and must be server-spawned to exist over the network.
- Spawnable prefab collections must contain the same network prefabs on server and client.
- Scene objects are not added to the object pool; they become disabled instead of destroyed when despawned.
- Global NetworkObjects must be instantiated/spawned objects, not scene objects.
- Addressable network prefabs need runtime collection registration; see `addressables-and-prefabs.md`.
- Nested NetworkObjects affect ownership, despawn, and hierarchy; review nested settings before recursive operations.
- Reset pooled object state in stop/despawn callbacks and in server initialization paths.

## Ownership

| Operation | API |
| --- | --- |
| Spawn with owner | `ServerManager.Spawn(nob, ownerConnection)` |
| Transfer owner | `networkObject.GiveOwnership(newOwner)` on server |
| Remove owner | `networkObject.RemoveOwnership()` on server |
| Check local owner | `base.IsOwner` after client initialization |
| Check controller | `base.IsController` for owner or server-without-owner |
| Current owner | `base.Owner` / `networkObject.Owner` |

Use `base.Owner.IsLocalClient` instead of `base.IsOwner` inside `OnStartNetwork` and `OnStartServer`.

## Observers And AOI

| Concept | Notes |
| --- | --- |
| Observer | Client that can see an object and receive object messages/callbacks. |
| `NetworkObserver` | Per-object conditions; added automatically at runtime if absent. |
| `ObserverManager` | Default conditions for objects. NetworkManager prefab includes SceneCondition. |
| `SceneCondition` | Requires clients to be in the same networked scene to observe scene objects. |
| Included conditions | Distance, Grid, HostOnly, Match, OwnerOnly, Scene. |
| Override type | Prefer `Add Missing`; `Ignore Manager` can accidentally drop SceneCondition. |

If scene NetworkObjects do not appear on clients:

1. Confirm the client has connected and authenticated.
2. Confirm the client has been added to the scene.
3. Confirm the scene was loaded through FishNet `SceneManager`, or manually add scene membership only when you know the client already loaded it.
4. Inspect `NetworkObserver` override type and conditions.
5. Do not remove `ObserverManager` or `SceneCondition` just to make objects visible.

Host note: if the host client is not an observer, renderers may be disabled to simulate unspawned client behavior while the server still owns the object.

## Scene Management

| Need | API |
| --- | --- |
| Load scenes for everyone | `SceneManager.LoadGlobalScenes(new SceneLoadData("SceneName"))` |
| Load scenes for one/many clients | `SceneManager.LoadConnectionScenes(connOrArray, sceneLoadData)` |
| Server-only preload | `SceneManager.LoadConnectionScenes(sceneLoadData)` |
| Replace all scenes | `sceneLoadData.ReplaceScenes = ReplaceOption.All` |
| Replace FishNet online scenes only | `ReplaceOption.OnlineOnly` |
| Move spawned NetworkObjects | `SceneLoadData.MovedNetworkObjects` |
| Scene stacking | `SceneLoadData.Options.AllowStacking = true` |
| Local physics for stacked scenes | `SceneLoadData.Options.LocalPhysics` |

Rules:

- Loading new scenes by FishNet is name-based.
- Existing loaded scene targeting can use scene reference or handle.
- Global scenes load for current and future clients.
- Connection scenes load only for specified connections and can be server-only.
- Global scenes are not automatically unloaded by empty connection membership.
- Use scene events to track loaded scene references when stacking or caching.

## Scene Event Timing

| Event | Meaning |
| --- | --- |
| `OnClientLoadedStartScenes` | A client loaded initial scenes after connecting; fires on client and server with an `asServer` flag. |
| `OnQueueStart` / `OnQueueEnd` | A scene load/unload queue started or ended. |
| `OnLoadStart` / `OnUnloadStart` | One queue entry began loading/unloading. |
| `OnLoadEnd` | Scenes for the queue entry loaded and active scene was set if applicable. |
| `OnClientPresenceChangeStart` | Server is adding/removing a client to/from a scene before observer status updates. |
| `OnClientPresenceChangeEnd` | Server finished client scene presence change after observer status updates. |

Do not spawn or target scene-observed content for a client solely because `OnLoadEnd` fired. `OnLoadEnd` means scene assets loaded; it does not guarantee that the connection observes the scene. Prefer `OnClientPresenceChangeEnd` for player spawns that depend on scene visibility, or `NetworkBehaviour.OnSpawnServer` for scene objects.

Initial scene trap:

- The first/offline scene a client enters play mode with is loaded by Unity SceneManager, not FishNet SceneManager.
- Connecting to a host/server does not automatically make the client an observer of that Unity-loaded scene.
- FishNet `PlayerSpawner` handles adding the owner to the default scene for common setups.
- Without `PlayerSpawner`, load the client through FishNet SceneManager or call `SceneManager.AddOwnerToDefaultScene()` from an owned object when appropriate.

## `SceneId ... not found in SceneObjects`

This error usually means the server sent a scene object spawn/message for a scene object the client cannot map.

Common causes:

- Server thinks the client is in a scene the client has not loaded.
- Scene differs between client and server build, branch, Addressables bundle, or editor clone.
- Networked scene objects lack `SceneCondition` and are sent to clients outside the scene.
- Scene object ids are stale after duplicating, moving, adding, deleting, or prefab-applying NetworkObjects.
- Missing scripts or unapplied prefab changes prevent proper serialization.

Repair path:

1. Check the Console for the full FishNet warning/error.
2. Confirm server and client load the same scene content and build/index/addressable bundle.
3. Confirm `ObserverManager` default conditions include `SceneCondition`.
4. Confirm the connection was added to the scene through FishNet.
5. Open the affected scenes in Unity.
6. Run `Tools -> Fish-Networking -> Reserialize NetworkObjects`.
7. Save the opened scenes after reserializing.
8. If available, add `DebugManager` to `NetworkManager` and enable scene object detail logging.

Related warnings:

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| `NetworkObject ... needs to be reserialized` | Stale prefab or scene object serialized data | Run FishNet reserialize utility on prefabs/scenes. |
| Scene objects disabled on client | Client is not an observer of the scene | Add scene membership or load through FishNet SceneManager. |
| RPC target not found | Target not an observer or object not spawned | Check observer visibility, spawn state, and TargetRpc connection. |
