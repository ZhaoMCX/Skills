# Serialization, Transports, And Debugging

Use this when working with custom serializers, transports, dedicated servers, code stripping, install issues, recurring FishNet warnings, or final verification.

## Serialization

Automatic serializer behavior:

- Public fields and properties are serialized when supported.
- Inherited fields/properties are serialized when supported.
- Use `[ExcludeSerialization]` from `FishNet.CodeGenerating` for public members that should not go over the network.
- Prefer explicit DTO structs for network data instead of sending large gameplay classes.

Custom serializer requirements:

- Static methods in a static class.
- Writer method name starts with `Write`; first parameter is `this Writer`.
- Reader method name starts with `Read`; first parameter is `this Reader`.
- Read data in exactly the same order it was written.
- Add `[UseGlobalCustomSerializer]` to the data type when serializer should work across assemblies.

Example:

```csharp
public static class EnemySerializers
{
    public static void WriteEnemy(this Writer writer, Enemy value)
    {
        writer.WriteBoolean(value.HasEnergy);
        writer.WriteSingle(value.Health);
        if (value.HasEnergy)
            writer.WriteSingle(value.Energy);
    }

    public static Enemy ReadEnemy(this Reader reader)
    {
        Enemy value = new();
        value.HasEnergy = reader.ReadBoolean();
        value.Health = reader.ReadSingle();
        if (value.HasEnergy)
            value.Energy = reader.ReadSingle();
        return value;
    }
}
```

## Connection Startup

Manual connection startup:

```csharp
networkManager.ServerManager.StartConnection();
networkManager.ClientManager.StartConnection();
networkManager.TransportManager.Transport.SetClientAddress(address);
networkManager.ClientManager.StopConnection();
networkManager.ServerManager.StopConnection(sendDisconnectMessage: true);
```

For port selection:

```csharp
networkManager.ServerManager.StartConnection(port);
networkManager.TransportManager.Transport.SetClientAddress(address);
```

## Transport Notes

- `TransportManager.Transport` chooses the active transport; empty uses default/first available.
- Latency simulator can simulate latency, packet loss, out-of-order unreliable packets, and host latency.
- Only transports supporting unreliable messages can truly send unreliable RPCs; otherwise FishNet falls back to reliable.
- Dedicated server builds should verify `Start On Headless`, frame rate, timeout, authentication, and port binding.
- If port is already used, check duplicate server starts and transport `ReuseAddress` support.
- For mobile/Quest suspend behavior, consider explicit disconnect on app pause when appropriate.

## Install And Upgrade Checks

- If importing a new FishNet version causes immediate compile errors, the official docs recommend deleting the FishNet folder and importing the latest version cleanly.
- For 4.x APIs, `NetworkManager.Authenticator` and `ServerManager.Authenticator` were replaced by `ServerManager.GetAuthenticator()` and `SetAuthenticator(...)`.
- Old `[SyncVar]` and `[SyncObject]` attributes are obsolete; use class-style SyncTypes.
- `PooledReader`/`PooledWriter` disposal APIs became `Store`/`StoreLength`.
- Broadcast handlers include `Channel` as the last parameter.
- `ObserversRpc IncludeOwner` became `ExcludeOwner`; invert old values when migrating.

## Common Failure Modes

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| `base.IsOwner` false in `OnStartServer` as host | Client side not initialized yet | Use `base.Owner.IsLocalClient` there. |
| `Cannot complete action because client is not active` | Client socket/object not ready or `[Client]` method invoked while offline | Wait for client/object initialization or adjust logging intent. |
| `Cannot complete action because server is not active` | Server socket/object not ready or `[Server]` method invoked while offline | Wait for server/object initialization or adjust logging intent. |
| ServerRpc ignored/warns | Non-owner called owner-required RPC | Keep owner-only or set `RequireOwnership = false` with validation. |
| Late joiner misses state | One-shot RPC used for persistent state | Use SyncTypes or `ObserversRpc(BufferLast = true)`. |
| Host SyncVar callback previous value is wrong | Host client limitation | Gate previous-value logic with `asServer || IsClientOnlyStarted`. |
| SyncVar value unavailable in `OnDestroy` | SyncTypes reset before destroy | Capture needed state earlier in stop/despawn callbacks. |
| Pooled object keeps stale state | Despawn reset path incomplete | Reset state in stop callbacks and SyncType initial values. |
| Custom serializer corrupts packet | Read/write order mismatch | Make reader mirror writer exactly. |
| Wrong prefab spawns | Spawnable prefab list or runtime collection mismatch | Rebuild default prefabs or runtime collection on both sides. |
| `AssetPathHash is not set` | Unity/FishNet prefab serialization issue | Restart Unity; check missing scripts and prefab save state. |
| Netcode for GameObjects conflict after install | Conflicting networking package/files | Remove conflicting NGO files and fix asmdef references. |

Scene object visibility and `SceneId ... not found in SceneObjects` are covered in `spawning-scenes-observers.md`.

## Verification Checklist

1. Compile Unity and check Console.
2. Run host plus one separate client for ownership/RPC/SyncType behavior.
3. Test dedicated server or headless path for server-only features.
4. Simulate latency and packet loss when using unreliable, prediction, or fast movement.
5. Test late join and respawn for every stateful feature.
6. Test scene load/unload, scene stacking, and observer visibility where applicable.
7. Test Addressables bundle load/unload before and after spawn.
8. Test despawn and pooled reuse for stale events, callbacks, and SyncType state.
9. Inspect bandwidth if SyncTypes/RPCs send at tick rate or from many objects.
10. Check generated serializers if custom network DTOs changed.
