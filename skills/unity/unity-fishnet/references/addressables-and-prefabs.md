# Addressables And Runtime Prefabs

Use this when FishNet network prefabs or scenes are loaded through Unity Addressables or another runtime bundle system.

## Prefab Addressables Rules

- Each runtime prefab package needs a unique `ushort` collection id from `1..65535`.
- Never use id `0`; FishNet reserves it for the configured default `SpawnablePrefabs`.
- Server and every client that may receive spawn messages must register the same prefab collection id and prefab order.
- Clients must load bundles and register prefabs before the server spawns those objects for them.
- If a scene contains addressable network prefabs, clients must load the relevant bundle before the server adds the client to that scene.
- Clear/remove runtime collections only after all objects from that collection are despawned or no spawn messages can reference them.

## Runtime Registration Pattern

```csharp
using System.Collections;
using System.Collections.Generic;
using FishNet;
using FishNet.Managing;
using FishNet.Managing.Object;
using FishNet.Object;
using GameKit.Dependencies.Utilities;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;

public sealed class FishNetAddressablePrefabs : MonoBehaviour
{
    private NetworkManager _networkManager => InstanceFinder.NetworkManager;
    private readonly Dictionary<string, AsyncOperationHandle<IList<GameObject>>> _handles = new();

    public IEnumerator LoadPackage(string packageKey)
    {
        ushort collectionId = packageKey.GetStableHashU16();
        if (collectionId == 0)
            throw new System.InvalidOperationException("FishNet runtime prefab collection id cannot be 0.");

        SinglePrefabObjects prefabs =
            (SinglePrefabObjects)_networkManager.GetPrefabObjects<SinglePrefabObjects>(collectionId, true);

        List<NetworkObject> networkPrefabs = new();
        AsyncOperationHandle<IList<GameObject>> handle =
            Addressables.LoadAssetsAsync<GameObject>(packageKey, go =>
            {
                if (go.TryGetComponent(out NetworkObject nob))
                    networkPrefabs.Add(nob);
            });

        yield return handle;

        prefabs.Clear();
        prefabs.AddObjects(networkPrefabs, checkForDuplicates: true);
        _handles[packageKey] = handle;
    }

    public void UnloadPackage(string packageKey)
    {
        ushort collectionId = packageKey.GetStableHashU16();
        PrefabObjects prefabs = _networkManager.GetPrefabObjects<SinglePrefabObjects>(collectionId, false);
        prefabs?.Clear();
        _networkManager.RemoveSpawnableCollection(collectionId);

        if (_handles.TryGetValue(packageKey, out AsyncOperationHandle<IList<GameObject>> handle))
        {
            Addressables.Release(handle);
            _handles.Remove(packageKey);
        }
    }
}
```

Adapt the hashing strategy when package names are not guaranteed unique. FishNet documentation examples may use `GetStableHash16`; current 4.7.2 GameKit utilities expose `GetStableHashU16`. Inspect the installed helper or provide your own deterministic nonzero `ushort` mapping. The collection id and prefab ordering are part of the network contract.

## Scene Addressables

Addressable scenes use FishNet custom scene processors.

Checklist:

1. Implement a custom scene processor using FishNet scene processor APIs.
2. Assign it to FishNet `SceneManager.SceneProcessor`.
3. Load addressable scene dependencies before connection scene membership changes.
4. Treat `SceneLoadData` addressable flags as metadata unless the project's processor implements behavior for them.
5. Test host, remote client, reconnect, and scene unload/reload.

Do not assume that setting an Addressables flag on scene load data makes Addressables work by itself. The project needs a processor that actually loads/unloads addressable scenes.

Processor skeleton to adapt and compile against the installed Addressables/FishNet versions:

```csharp
using System.Collections;
using System.Collections.Generic;
using FishNet.Managing.Scened;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using UnityEngine.ResourceManagement.ResourceProviders;
using UnityEngine.SceneManagement;
using UnityScene = UnityEngine.SceneManagement.Scene;

public sealed class AddressablesSceneProcessor : DefaultSceneProcessor
{
    private readonly Dictionary<int, AsyncOperationHandle<SceneInstance>> _loadedByHandle = new();
    private AsyncOperationHandle<SceneInstance>? _currentLoad;
    private AsyncOperationHandle<SceneInstance>? _currentUnload;
    private AsyncOperation _currentActivation;
    private int _unloadingSceneHandle;
    private UnityScene _lastLoadedScene;

    public override void BeginLoadAsync(string sceneName, LoadSceneParameters parameters)
    {
        // Map FishNet sceneName to your Addressables key if they differ.
        LoadSceneMode mode = parameters.loadSceneMode;
        AsyncOperationHandle<SceneInstance> handle =
            Addressables.LoadSceneAsync(sceneName, mode, activateOnLoad: false);

        _currentLoad = handle;
    }

    public override void BeginUnloadAsync(UnityScene scene)
    {
        if (_loadedByHandle.TryGetValue(scene.handle, out AsyncOperationHandle<SceneInstance> handle))
        {
            _unloadingSceneHandle = scene.handle;
            _currentUnload = Addressables.UnloadSceneAsync(handle, autoReleaseHandle: true);
        }
        else
        {
            base.BeginUnloadAsync(scene);
        }
    }

    public override bool IsPercentComplete()
    {
        return GetPercentComplete() >= 0.9f;
    }

    public override float GetPercentComplete()
    {
        if (_currentLoad.HasValue)
            return _currentLoad.Value.PercentComplete;
        if (_currentActivation != null)
            return _currentActivation.progress;
        if (_currentUnload.HasValue)
            return _currentUnload.Value.PercentComplete;
        return base.GetPercentComplete();
    }

    public override IEnumerator AsyncsIsDone()
    {
        while ((_currentLoad.HasValue && !_currentLoad.Value.IsDone) ||
               (_currentActivation != null && !_currentActivation.isDone) ||
               (_currentUnload.HasValue && !_currentUnload.Value.IsDone))
        {
            yield return null;
        }
    }

    public override void ActivateLoadedScenes()
    {
        if (!_currentLoad.HasValue)
        {
            base.ActivateLoadedScenes();
            return;
        }

        SceneInstance instance = _currentLoad.Value.Result;
        _currentActivation = instance.ActivateAsync();

        _lastLoadedScene = instance.Scene;
        _loadedByHandle[_lastLoadedScene.handle] = _currentLoad.Value;
    }

    public override UnityScene GetLastLoadedScene()
    {
        return _lastLoadedScene.IsValid() ? _lastLoadedScene : base.GetLastLoadedScene();
    }

    public override void LoadEnd(LoadQueueData queueData)
    {
        _currentLoad = null;
        _currentActivation = null;
        base.LoadEnd(queueData);
    }

    public override void UnloadEnd(UnloadQueueData queueData)
    {
        if (_currentUnload.HasValue && _currentUnload.Value.IsDone)
            _loadedByHandle.Remove(_unloadingSceneHandle);

        _currentUnload = null;
        _unloadingSceneHandle = 0;
        base.UnloadEnd(queueData);
    }
}
```

Treat the skeleton as a shape, not a drop-in for every Addressables version. In production, wait for activation completion, handle failed operations, keep handles for stacked scenes, and map FishNet scene names to Addressables keys deliberately.

Loading with Addressables intent:

```csharp
SceneLoadData data = new("ArenaAddressableKey");
data.Options.Addressables = true;
networkManager.SceneManager.LoadConnectionScenes(connection, data);
```

The `Options.Addressables` flag is only a signal for your processor/workflow. The processor must do the actual Addressables load and unload work.

## Failure Modes

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| Client cannot spawn addressable prefab | Client did not register collection id or prefab order differs | Load/register bundle on client before spawn. |
| Collection id `0` warning/error | Runtime collection attempted to use default id | Use a unique nonzero `ushort`. |
| Wrong prefab appears | Server/client collection order mismatch or stale default prefabs | Rebuild/register collection deterministically on both sides. |
| Scene object errors after addressable scene load | Client scene content differs or membership changed before load | Load addressable scene/bundles first, then add connection to scene. |
| Memory leak after unloading package | Runtime collection and handle not cleared | Despawn users, clear prefab collection, remove runtime collection, release handle. |
