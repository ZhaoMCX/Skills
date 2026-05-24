# Communication And State

Use this when working with RPCs, SyncTypes, broadcasts, authentication, connection events, or server-authoritative interactables.

## RPCs

| Need | Pattern |
| --- | --- |
| Owner asks server | `[ServerRpc]` |
| Spectator/non-owner asks server | `[ServerRpc(RequireOwnership = false)]` and final `NetworkConnection caller = null` |
| Server tells all current observers | `[ObserversRpc]` |
| Server tells a specific client | `[TargetRpc]` with first parameter `NetworkConnection` |
| Sender should also run the method immediately | `RunLocally = true`, but still validate on server |
| Future observers need the last transient value | `[ObserversRpc(BufferLast = true)]` |
| Unreliable, supersedable data | Add `Channel channel = Channel.Unreliable` final parameter |
| Ownerless ServerRpc with channel and caller | Put `Channel` before the final caller parameter |

RPC attribute options:

| Option | Applies to | Use |
| --- | --- | --- |
| `RunLocally` | All RPCs | Run on caller immediately as well as send. |
| `DataLength` | All RPCs | Reserve writer capacity for large known payloads. |
| `OrderType = DataOrderType.Last` | All RPCs | Send after default-ordered data, often after SyncTypes. |
| `RequireOwnership` | `ServerRpc` | Defaults true. Set false only with caller validation. |
| `ExcludeOwner` | `ObserversRpc` | Prevent owner receiving their own observer update. |
| `ExcludeServer` | `ObserversRpc`, `TargetRpc` | Prevent host/server-side client duplicate handling. |
| `BufferLast` | `ObserversRpc` | Send last value to future observers when object spawns for them. |
| `ValidateTarget` | `TargetRpc` | Keep true unless the target validation warning is intentionally unwanted. |

Do not use RPCs as the only source of persistent truth. If respawn, reconnect, scene reload, or late join should recover state, use a SyncType or spawn payload.

## SyncTypes

Current FishNet uses class-style SyncTypes:

```csharp
private readonly SyncVar<int> _score = new();
private readonly SyncList<ItemState> _items = new();
private readonly SyncDictionary<NetworkConnection, string> _names = new();
private readonly SyncHashSet<int> _seenIds = new();
private readonly SyncTimer _timer = new();
private readonly SyncStopwatch _stopwatch = new();
```

Settings:

```csharp
private readonly SyncVar<string> _name = new(
    new SyncTypeSettings(
        WritePermission.ClientUnsynchronized,
        ReadPermission.ExcludeOwner,
        sendRate: 0.1f,
        channel: Channel.Reliable));
```

| Setting | Meaning |
| --- | --- |
| `WritePermission.ServerOnly` | Only server may change networked value. |
| `WritePermission.ClientUnsynchronized` | Client may set locally; the SyncType itself does not send client value to server. Pair with validated ServerRpc when server truth is needed. |
| `ReadPermission.Observers` | All observers receive updates. |
| `ReadPermission.OwnerOnly` | Only owner receives updates. |
| `ReadPermission.ExcludeOwner` | Observers except owner receive updates. |
| `SendRate` | Seconds between sends. `0f` can send every network tick. |
| `Channel.Reliable` | Default. Use unreliable only for supersedable data. |

Rules and traps:

- Initialize SyncTypes at field declaration and keep collection fields `readonly`.
- Changes in `Awake` happen locally on server and client without network synchronization.
- Change server-synchronized values in `OnStartServer` when clients need the value in spawn data.
- `SyncVar<T>.OnChange` receives `(previous, next, asServer)`.
- Host client callback `previous` can equal current for `asServer == false`; gate previous-value logic with `if (asServer || IsClientOnlyStarted)` when previous matters.
- SyncVar values reset before `OnDestroy`; capture needed state earlier in stop/despawn callbacks.
- Do not couple separate SyncTypes by receive order. Use one struct value, explicit sequence ids, or idempotent callbacks when fields depend on each other.

## Broadcasts

Use broadcasts for messages not tied to one spawned `NetworkObject`.

```csharp
public struct ChatMessage : IBroadcast
{
    public string Text;
}
```

| Direction | API |
| --- | --- |
| Client sends to server | `ClientManager.Broadcast(message, channel)` |
| Server registers client messages | `ServerManager.RegisterBroadcast<T>((conn, msg, channel) => { }, requireAuthentication: true)` |
| Server sends to one client | `ServerManager.Broadcast(connection, message, requireAuthenticated, channel)` |
| Server sends to all clients | `ServerManager.Broadcast(message, requireAuthenticated, channel)` |
| Server sends to object observers | `ServerManager.Broadcast(networkObject, message, requireAuthenticated, channel)` |
| Client registers server messages | `ClientManager.RegisterBroadcast<T>((msg, channel) => { })` |

Unregister handlers in cleanup callbacks. For pre-authentication login data, deliberately register the server handler with `requireAuthentication: false` and validate every field.

## Authentication And Connection Events

Important manager events:

| Event | Side | Use |
| --- | --- | --- |
| `ServerManager.OnServerConnectionState` | Server | Server starts/stops. Good for global scene load or initial server spawns. |
| `ServerManager.OnRemoteConnectionState` | Server | A client connects/disconnects at transport level. Good for capacity checks and authenticator setup. |
| `ServerManager.OnAuthenticationResult` | Server | Authenticator accepted or rejected a client. Good for storing accepted connections or sending post-auth data. |
| `ClientManager.OnClientConnectionState` | Client | Local client connects/disconnects at transport level. The client may not yet be authenticated or present in `ClientManager.Clients`. |
| `ClientManager.OnAuthenticated` | Client | Local client has an id, is authenticated, and is ready for gameplay startup. |
| `ClientManager.OnRemoteConnectionState` | Client | Another client connects/disconnects; requires `ServerManager.ShareIds`. |
| `SceneManager.OnClientLoadedStartScenes` | Shared | Client finished initial scenes; use `asServer` flag to avoid duplicate host logic. |

Custom authenticator flow:

1. Create a `MonoBehaviour` inheriting `FishNet.Authenticating.Authenticator`.
2. Implement `OnAuthenticationResult` and raise it with `(connection, true/false)` when validation finishes.
3. Override `OnRemoteConnection(NetworkConnection connection)` for server-side pre-auth setup or challenge messages.
4. Assign it through the ServerManager inspector or `ServerManager.SetAuthenticator(authenticator)`.
5. Let the client send credentials after `ClientManager.OnClientConnectionState` reaches `Started`, often by broadcast.
6. Use `ClientManager.OnAuthenticated` for gameplay startup, player selection, UI unlock, and initial data requests.

Minimal authenticator skeleton:

```csharp
using System;
using FishNet.Authenticating;
using FishNet.Broadcast;
using FishNet.Connection;
using FishNet.Managing;
using FishNet.Transporting;
using UnityEngine;

public struct LoginRequest : IBroadcast
{
    public string Token;
}

public struct LoginResponse : IBroadcast
{
    public bool Accepted;
    public string Reason;
}

public sealed class TokenAuthenticator : Authenticator
{
    public override event Action<NetworkConnection, bool> OnAuthenticationResult;

    [SerializeField] private string _clientToken;
    [SerializeField] private string _serverToken;

    public override void InitializeOnce(NetworkManager networkManager)
    {
        base.InitializeOnce(networkManager);

        NetworkManager.ClientManager.OnClientConnectionState += OnClientConnectionState;
        NetworkManager.ClientManager.RegisterBroadcast<LoginResponse>(OnLoginResponse);
        NetworkManager.ServerManager.RegisterBroadcast<LoginRequest>(OnLoginRequest, requireAuthentication: false);
    }

    public override void OnRemoteConnection(NetworkConnection connection)
    {
        // Optional: send a server challenge here before the client sends credentials.
    }

    private void OnClientConnectionState(ClientConnectionStateArgs args)
    {
        if (args.ConnectionState != LocalConnectionState.Started)
            return;

        NetworkManager.ClientManager.Broadcast(new LoginRequest
        {
            Token = _clientToken
        }, Channel.Reliable);
    }

    private void OnLoginRequest(NetworkConnection connection, LoginRequest request, Channel channel)
    {
        if (connection.IsAuthenticated)
        {
            connection.Disconnect(true);
            return;
        }

        bool accepted = request.Token == _serverToken;

        NetworkManager.ServerManager.Broadcast(connection, new LoginResponse
        {
            Accepted = accepted,
            Reason = accepted ? string.Empty : "Invalid credentials."
        }, false, Channel.Reliable);

        // Invoke after sending the response so a rejected client can receive the failure reason before disconnect.
        OnAuthenticationResult?.Invoke(connection, accepted);
    }

    private void OnLoginResponse(LoginResponse response, Channel channel)
    {
        Debug.Log(response.Accepted ? "Authentication accepted." : response.Reason);
    }
}
```

Authenticator implementation notes:

- `OnAuthenticationResult` is an event the custom authenticator raises; it is not an override method.
- The server automatically listens to the event and completes or rejects the connection.
- Pre-authentication server broadcast handlers must pass `requireAuthentication: false`.
- Disconnect already-authenticated clients that send login messages again.
- Never send real passwords/tokens in plaintext in production. Use a secure transport/session token flow appropriate to the platform.
- If the authenticator object can be disabled or replaced at runtime, mirror the subscriptions with unregister calls supported by the installed FishNet version.

## Server-Authoritative Door

Use this pattern for doors, buttons, pickups, switches, and other world interactables that a non-owner may use.

```csharp
using FishNet.Connection;
using FishNet.Object;
using FishNet.Object.Synchronizing;

public sealed class NetworkDoor : NetworkBehaviour
{
    private readonly SyncVar<bool> _open = new();

    private void Awake()
    {
        _open.OnChange += OnOpenChanged;
    }

    [ServerRpc(RequireOwnership = false)]
    public void RequestUseServerRpc(NetworkConnection caller = null)
    {
        if (caller == null || !CanUse(caller))
            return;

        _open.Value = !_open.Value;
    }

    private bool CanUse(NetworkConnection caller)
    {
        NetworkObject player = caller.FirstObject;
        if (player == null)
            return false;

        float sqrDistance = (player.transform.position - transform.position).sqrMagnitude;
        return sqrDistance <= 9f;
    }

    private void OnOpenChanged(bool previous, bool next, bool asServer)
    {
        if (asServer && !IsClientStarted)
            return;

        ApplyDoorVisual(next);
    }

    private void ApplyDoorVisual(bool isOpen) { }
}
```

Checklist:

- The request RPC is ownerless only because the door has no owner.
- The server validates caller identity, distance, state, cooldown, locks, team, and scene membership.
- The state lives in `SyncVar<bool>`, so late joiners see the current door state.
- Visuals respond to SyncVar change, not to the request RPC.
