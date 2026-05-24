# Prediction And Motion

Use this when working with `NetworkTransform`, `NetworkAnimator`, prediction, reconcile, rubber-banding, smoothing, predicted spawning, predicted ownership, or physics under latency.

## NetworkTransform

- Synchronizes the transform it is attached to; child transforms can have their own `NetworkTransform`.
- Client authoritative mode lets the owner send transform changes; otherwise the server must move the object.
- Send Interval is in ticks; `1` can send every tick when changed.
- Turn off unused position/rotation/scale axes to save bandwidth.
- Use teleport thresholds for large position jumps.
- Avoid prediction, `NetworkTransform`, and manual transform replication independently authoring the same transform unless `NetworkTransform` is explicitly configured for prediction/spectator replication.

## NetworkAnimator

- Synchronizes Animator state/parameters and exposes synchronized `Play`, `CrossFade`, trigger, reset, controller, and animator methods.
- Client authoritative mode lets owner animation changes relay through server.
- It is not aligned with FishNet prediction. Predicted games often drive local animation from predicted state and replicate only high-level state needed by spectators.
- Use the same interpolation approach as related movement when animation should align with movement.

## Prediction Setup Checklist

1. Enable prediction on the `NetworkObject`.
2. Choose prediction type: Rigidbody, Rigidbody2D, or Other.
3. Decide whether State Forwarding is enabled.
4. Assign a graphical object only for visuals that can be smoothed.
5. Keep gameplay colliders, triggers, character controllers, and movement roots outside/beside smoothed graphics.
6. If using physics, use `PredictionRigidbody` or `PredictionRigidbody2D`.
7. Subscribe to `TimeManager.OnTick` and, for physics, `TimeManager.OnPostTick`.
8. Implement `[Replicate]` and `[Reconcile]` methods.
9. Always call `CreateReconcile`; only server will send reconcile, but the call pattern should be consistent.
10. Test with latency, packet loss, host, and remote client.

State Forwarding:

- Enabled: owner/server inputs can run on other clients too. More CPU/memory, but spectators run the same input logic and reconcile.
- Disabled: owner and server run inputs. Spectators need separate visual replication, often `NetworkTransform`, RPCs, or high-level SyncTypes.

## Prediction Data Skeleton

```csharp
public struct MoveData : IReplicateData
{
    public float Horizontal;
    public float Vertical;
    private uint _tick;

    public MoveData(float horizontal, float vertical) : this()
    {
        Horizontal = horizontal;
        Vertical = vertical;
    }

    public uint GetTick() => _tick;
    public void SetTick(uint value) => _tick = value;
    public void Dispose() { }
}

public struct ReconcileData : IReconcileData
{
    public PredictionRigidbody Body;
    private uint _tick;

    public ReconcileData(PredictionRigidbody body) : this()
    {
        Body = body;
    }

    public uint GetTick() => _tick;
    public void SetTick(uint value) => _tick = value;
    public void Dispose() { }
}
```

Tick lifecycle:

```csharp
public override void OnStartNetwork()
{
    TimeManager.OnTick += TimeManager_OnTick;
    TimeManager.OnPostTick += TimeManager_OnPostTick;
}

public override void OnStopNetwork()
{
    TimeManager.OnTick -= TimeManager_OnTick;
    TimeManager.OnPostTick -= TimeManager_OnPostTick;
}
```

Replicate and reconcile rules:

- Build owner input data during ticks; return `default` for non-owners unless server/no-owner control is intended.
- Use `[Replicate]` signature with data, `ReplicateState state = ReplicateState.Invalid`, and `Channel channel = Channel.Unreliable`.
- Use `[Reconcile]` signature with reconcile data and `Channel channel = Channel.Unreliable`.
- Apply forces, velocity, and simulation through `PredictionRigidbody`, not direct `Rigidbody` mutation.
- For physics bodies, create reconcile data in `OnPostTick` after physics simulation.
- For non-physics controllers, reconcile can be created in `OnTick`.
- For CharacterController reconciliation, disable the controller before setting position and re-enable it after.
- Use `Dispose` when replicate/reconcile data owns disposable or pooled resources.

Minimal Rigidbody controller shape:

```csharp
using FishNet.Object;
using FishNet.Object.Prediction;
using FishNet.Transporting;
using UnityEngine;

public sealed class PredictedRigidbodyMover : NetworkBehaviour
{
    public struct ReplicateData : IReplicateData
    {
        public Vector2 Input;
        private uint _tick;

        public ReplicateData(Vector2 input) : this()
        {
            Input = input;
        }

        public uint GetTick() => _tick;
        public void SetTick(uint value) => _tick = value;
        public void Dispose() { }
    }

    public struct ReconcileData : IReconcileData
    {
        public PredictionRigidbody Body;
        private uint _tick;

        public ReconcileData(PredictionRigidbody body) : this()
        {
            Body = body;
        }

        public uint GetTick() => _tick;
        public void SetTick(uint value) => _tick = value;
        public void Dispose() { }
    }

    [SerializeField] private float _moveForce = 20f;
    private PredictionRigidbody _body = new();

    private void Awake()
    {
        _body.Initialize(GetComponent<Rigidbody>());
    }

    public override void OnStartNetwork()
    {
        TimeManager.OnTick += OnTick;
        TimeManager.OnPostTick += OnPostTick;
    }

    public override void OnStopNetwork()
    {
        TimeManager.OnTick -= OnTick;
        TimeManager.OnPostTick -= OnPostTick;
    }

    private void OnTick()
    {
        Move(BuildReplicateData());
    }

    private void OnPostTick()
    {
        CreateReconcile();
    }

    private ReplicateData BuildReplicateData()
    {
        if (!IsOwner)
            return default;

        Vector2 input = new(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));
        return new ReplicateData(input);
    }

    [Replicate]
    private void Move(ReplicateData data, ReplicateState state = ReplicateState.Invalid, Channel channel = Channel.Unreliable)
    {
        Vector3 force = new(data.Input.x, 0f, data.Input.y) * _moveForce;
        _body.AddForce(force);
        _body.Simulate();
    }

    public override void CreateReconcile()
    {
        Reconcile(new ReconcileData(_body));
    }

    [Reconcile]
    private void Reconcile(ReconcileData data, Channel channel = Channel.Unreliable)
    {
        _body.Reconcile(data.Body);
    }
}
```

CharacterController variation:

- Store position, velocity/gravity, stamina, platform/parent references, and other deterministic controller state in reconcile data.
- In `[Replicate]`, use `TimeManager.TickDelta` rather than `Time.deltaTime`.
- Accumulate one-frame inputs in `Update`, consume and reset them when building replicate data.
- In `[Reconcile]`, disable `CharacterController`, set parent and local/world position, restore velocities/state, then re-enable.

## Prediction Components

| Component | Use | Watch for |
| --- | --- | --- |
| `NetworkTickSmoother` | Smooths transform properties between network ticks. Place below a `NetworkObject`. | It initializes using NetworkBehaviour callbacks. Non-networked objects use offline smoother variants. |
| `NetworkTickSmoother` Favor Prediction Network Transform | Lets smoother yield to a prediction-aware NetworkTransform where configured. | Prevents jitter when prediction and NetworkTransform are intentionally combined. |
| `OfflineRigidbody` | Prevents non-networked rigidbodies from simulating multiple times during prediction correction. | Add to reactive physics objects near predicted bodies. |
| `NetworkCollision`, `NetworkTrigger`, 2D variants | Prediction-aware collision/trigger Enter, Stay, Exit callbacks. | Avoid playing one-shot effects while `PredictionManager.IsReconciling`; `OnStay` does not return Unity `Collision`. |
| `PredictedSpawn` | Lets clients predicted-spawn/despawn a NetworkObject with server validation. | ServerManager predicted spawning must be enabled; object must have component; predicted spawns currently have limitations such as nesting restrictions. |
| `PredictedOwner` | Lets a client immediately simulate ownership before server response. | Validate by overriding server decision hooks; server can allow/deny at runtime. |

## Predicted Spawn

Use only when the UX requires immediate client-side spawn feedback and the server can validate after the fact.

Checklist:

- Enable `ServerManager` predicted spawning.
- Add and configure `PredictedSpawn` on each eligible prefab.
- Keep normal server spawning for objects that do not need immediate local prediction.
- Override validation points when the default acceptance is too broad.
- Test rejection, duplicate spawn prevention, despawn, pooling, and late observer visibility.

If you see `Cannot spawn object because server is not active and predicted spawning is not enabled`, the client is trying to network-spawn without the predicted spawning path.

## Predicted Ownership

Use only when waiting for ownership round trip would feel bad, such as grabbing or controlling an object.

Checklist:

- Add `PredictedOwner`.
- Let the client call `TakeOwnership(...)` only from an input path that can be validated.
- Validate on server by overriding ownership decision logic.
- Use `PreviousOwner` and ownership callbacks to restore input/UI when ownership is rejected or transferred.
- Server may toggle whether predicted ownership is allowed at runtime.

Server validation shape:

```csharp
using FishNet.Component.Ownership;
using FishNet.Connection;
using FishNet.Object;
using UnityEngine;

public sealed class ValidatedPredictedOwner : PredictedOwner
{
    [SerializeField] private float _maxTakeDistance = 3f;

    [Server]
    protected override void OnTakeOwnership(NetworkConnection caller, bool recursive)
    {
        if (caller == null || !caller.IsActive || caller.FirstObject == null)
            return;

        float sqrDistance = (caller.FirstObject.transform.position - transform.position).sqrMagnitude;
        if (sqrDistance > _maxTakeDistance * _maxTakeDistance)
            return;

        base.OnTakeOwnership(caller, recursive);
    }
}
```

Use ownership callbacks to revert predicted-only input/UI if the server rejects the ownership attempt.

## Motion Conflict Triage

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| Rubber-banding | Server and client disagree on authority or reconcile data | Pick one authority path and send enough reconcile state. |
| Jittering graphics | Smoother, NetworkTransform, and prediction all touching same transform | Put gameplay root and smoothed graphics on separate transforms; configure smoother ownership. |
| Collisions inconsistent during correction | Direct Rigidbody writes or non-prediction collision callbacks | Use `PredictionRigidbody` and `NetworkCollider` components. |
| Spectators see no movement | State Forwarding disabled without spectator replication | Add prediction-aware NetworkTransform or high-level visual replication. |
| CharacterController snaps back | Reconcile sets position while controller remains enabled | Disable, set transform, re-enable. |

## Verification

- Run host plus remote client with artificial latency and packet loss.
- Check owner, server, and spectator behavior separately.
- Verify one-shot audio/VFX do not replay during reconcile.
- Verify pooled predicted objects clear local prediction state.
- Confirm graphics smoothing does not move gameplay colliders.
