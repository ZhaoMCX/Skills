# Mirror Migration

Use this when converting Mirror/UNet-style networking code to FishNet.

## Migration Order

1. Back up the Unity project or work on an isolated copy.
2. Identify Mirror package, Mirror components, scripting defines, and custom `NetworkManager` overrides.
3. If Mirror and FishNet are both present, consider FishNet's upgrade tool:
   - `Tools -> Fish-Networking -> Utility -> Upgrading From Mirror -> Replace Components`
   - Then remove temporary Mirror/FirstGearGames defines after the tool runs.
4. Remove `[RequireComponent(typeof(NetworkIdentity))]` from scripts before or during component migration.
5. Convert components, properties, RPCs, SyncVars, manager usage, and scene flow.
6. Compile after each slice; generated networking errors can hide downstream issues.
7. Re-test host, client-only, dedicated server, late join, scene transitions, and ownership.

## Component Mapping

| Mirror | FishNet | Notes |
| --- | --- | --- |
| `NetworkIdentity` | `NetworkObject` | Required for networked GameObjects. |
| Interest Management | `ObserverManager` and `NetworkObserver` | Conditions can be combined. |
| `NetworkTransform` / child variants | FishNet `NetworkTransform` or prediction | Revisit authority and smoothing. |
| `NetworkAnimator` | FishNet `NetworkAnimator` | Revisit client authoritative settings. |
| `NetworkSceneChecker` | `SceneCondition` | Usually on ObserverManager default conditions. |
| Online/Offline scenes | `DefaultScene` component or FishNet SceneManager flow | Mirror NetworkManager settings do not directly carry over. |

## NetworkBehaviour Properties

When converting from Mirror, prefer FishNet `Initialized` properties for object readiness.

| Mirror | FishNet |
| --- | --- |
| `hasAuthority` | `IsOwner` or, for owner/server-without-owner control, `IsController` |
| `isClient` | `IsClientInitialized` |
| `isClientOnly` | `IsClientOnlyInitialized` |
| `isServer` | `IsServerInitialized` |
| `isServerOnly` | `IsServerOnlyInitialized` |
| `connectionToClient` | `Owner` |
| `connectionToServer` | `LocalConnection` |
| `netId` | `ObjectId` |

FishNet also has `Started` variants. Use them for manager/socket state, not as a substitute for object initialization.

## RPC Mapping

| Mirror | FishNet | Notes |
| --- | --- | --- |
| `[Command]` | `[ServerRpc]` | Owner-only by default. Use `RequireOwnership = false` with validation for non-owner requests. |
| `[ClientRpc]` | `[ObserversRpc]` | Goes to object observers, not necessarily every connected client. |
| `[TargetRpc]` | `[TargetRpc]` | First parameter must be `NetworkConnection`. |
| `[SyncVar] T field` | `readonly SyncVar<T> field = new();` | Access value via `.Value`; subscribe to `OnChange`. |
| `SyncList<T>` etc. | FishNet class-style SyncTypes | Initialize at declaration. |

Mirror client RPCs often assumed all clients received messages. In FishNet, observer visibility and scene membership control object-bound messages.

## Manager Mapping

| Mirror | FishNet |
| --- | --- |
| `NetworkManager` | `NetworkManager` |
| `NetworkServer` | `ServerManager` |
| `NetworkClient` | `ClientManager` |
| Transport access | `TransportManager` |
| Tick/prediction | `TimeManager`, `PredictionManager` |
| Scene flow | `SceneManager` |

FishNet manager classes are sealed manager components. Move Mirror `NetworkManager` override logic into a `MonoBehaviour` that subscribes to FishNet manager events.

## Callback/Event Mapping

| Mirror override/concept | FishNet event or pattern |
| --- | --- |
| `OnServerConnect` / `OnServerDisconnect` | `ServerManager.OnRemoteConnectionState` |
| `OnStartServer` / `OnStopServer` / server errors | `ServerManager.OnServerConnectionState` |
| `OnStartClient` / `OnStopClient` / client connect/disconnect/errors | `ClientManager.OnClientConnectionState` |
| Client fully ready/authenticated | `ClientManager.OnAuthenticated` |
| `OnServerReady` | `SceneManager.OnClientLoadedStartScenes` or scene presence events |
| Server/client scene changed | `SceneManager.OnLoadEnd`, then often `OnClientPresenceChangeEnd` for visibility-dependent work |
| `OnServerAddPlayer` | Custom player spawner, often after authentication and scene presence |

Do not spawn players for a scene just because a scene load ended. Wait until the client is present/observing the target scene.

Manager event bridge template:

```csharp
using FishNet.Connection;
using FishNet.Managing;
using FishNet.Managing.Scened;
using FishNet.Transporting;
using UnityEngine;

public sealed class FishNetConnectionFlow : MonoBehaviour
{
    [SerializeField] private NetworkManager _networkManager;

    private void Awake()
    {
        if (_networkManager == null)
            _networkManager = GetComponent<NetworkManager>();
    }

    private void OnEnable()
    {
        _networkManager.ServerManager.OnServerConnectionState += OnServerConnectionState;
        _networkManager.ServerManager.OnRemoteConnectionState += OnRemoteConnectionState;
        _networkManager.ServerManager.OnAuthenticationResult += OnAuthenticationResult;
        _networkManager.ClientManager.OnClientConnectionState += OnClientConnectionState;
        _networkManager.ClientManager.OnAuthenticated += OnClientAuthenticated;
        _networkManager.SceneManager.OnClientPresenceChangeEnd += OnClientPresenceChangeEnd;
    }

    private void OnDisable()
    {
        _networkManager.ServerManager.OnServerConnectionState -= OnServerConnectionState;
        _networkManager.ServerManager.OnRemoteConnectionState -= OnRemoteConnectionState;
        _networkManager.ServerManager.OnAuthenticationResult -= OnAuthenticationResult;
        _networkManager.ClientManager.OnClientConnectionState -= OnClientConnectionState;
        _networkManager.ClientManager.OnAuthenticated -= OnClientAuthenticated;
        _networkManager.SceneManager.OnClientPresenceChangeEnd -= OnClientPresenceChangeEnd;
    }

    private void OnServerConnectionState(ServerConnectionStateArgs args)
    {
        if (args.ConnectionState == LocalConnectionState.Started)
            LoadInitialServerScenes();
    }

    private void OnRemoteConnectionState(NetworkConnection connection, RemoteConnectionStateArgs args)
    {
        if (args.ConnectionState == RemoteConnectionState.Stopped)
            CleanupServerState(connection);
    }

    private void OnAuthenticationResult(NetworkConnection connection, bool authenticated)
    {
        if (authenticated)
            PrepareAuthenticatedConnection(connection);
    }

    private void OnClientConnectionState(ClientConnectionStateArgs args)
    {
        if (args.ConnectionState == LocalConnectionState.Stopped)
            ShowDisconnectedUi();
    }

    private void OnClientAuthenticated()
    {
        RequestInitialClientState();
    }

    private void OnClientPresenceChangeEnd(ClientPresenceChangeEventArgs args)
    {
        if (args.Added)
            SpawnPlayerForScene(args.Connection, args.Scene);
    }

    private void LoadInitialServerScenes() { }
    private void CleanupServerState(NetworkConnection connection) { }
    private void PrepareAuthenticatedConnection(NetworkConnection connection) { }
    private void ShowDisconnectedUi() { }
    private void RequestInitialClientState() { }
    private void SpawnPlayerForScene(NetworkConnection connection, UnityEngine.SceneManagement.Scene scene) { }
}
```

Mirror `NetworkRoomManager` projects need a design pass rather than mechanical replacement. Model lobby readiness, selected player data, room slots, and game scene admission explicitly with broadcasts/SyncTypes plus `OnAuthenticated` and `OnClientPresenceChangeEnd`.

## Common Migration Traps

| Trap | Fix |
| --- | --- |
| Mechanical replace `hasAuthority` with `IsOwner` everywhere | Use `IsController` when server should control server-owned/no-owner objects. |
| Keeping Mirror `[SyncVar]` attributes | Replace with `readonly SyncVar<T> = new()` and `.Value`. |
| Porting `[ClientRpc]` to `[ObserversRpc]` without scene/observer checks | Confirm the target clients observe the object. Use broadcasts for global messages. |
| Calling ServerRpc before the object is client-initialized | Wait for `OnStartClient` or check object readiness. |
| Moving Mirror scene overrides to `OnLoadEnd` only | Use scene presence events for observer-dependent spawning. |
| Expecting component settings to survive upgrade tool | Keep original project for reference and manually reconfigure. |
| Leaving Mirror and FishNet runtime assemblies fighting | Remove Mirror when migration slice is complete and compile cleanly. |
