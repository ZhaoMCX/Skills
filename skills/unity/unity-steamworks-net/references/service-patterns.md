# Steamworks.NET Service Patterns

## Contents

- When to Read This
- Architecture Goal
- Recommended Service Split
- Lifecycle Service
- Feature Services
- FishySteamworks Session Boundary
- Testing Strategy
- Implementation Checklist

## When to Read This

Read this file when designing the project architecture, adding a first stable Steamworks.NET integration, or deciding how Steam platform services should interact with FishNet/FishySteamworks. For low-level API and lifecycle rules, read `integration-guide.md`; for bug diagnosis, read `troubleshooting.md`.

## Architecture Goal

Keep Steamworks.NET at the platform edge. Gameplay, UI, save systems, and networking screens should depend on project-owned interfaces, not directly on `Steamworks.*` types everywhere.

This gives the project:

- A single place to handle unavailable Steam.
- Testable gameplay code.
- Clear ownership between Steam platform features and FishNet transport.
- Easier future migration if Steam APIs or transport libraries change.

## Recommended Service Split

| Responsibility | Suggested owner | Depends on |
| --- | --- | --- |
| Steam lifecycle and identity | `SteamPlatformService` | Steamworks.NET |
| Achievements and stats | `SteamAchievementsService`, `SteamStatsService` | `SteamPlatformService`, `SteamUserStats` |
| Leaderboards | `SteamLeaderboardService` | `SteamUserStats`, `CallResult<T>` |
| Lobbies/session discovery | `SteamLobbyService` | `SteamMatchmaking`, callbacks |
| FishNet connection | Existing FishNet bootstrap / session service | FishySteamworks transport |
| Backend authentication | `SteamAuthService` | `SteamUser`, backend API |
| Cloud save transport | `SteamCloudSaveService` | `SteamRemoteStorage`, local save service |

Avoid creating a single giant "SteamManager" that owns every feature. Keep the lifecycle manager small and let feature services subscribe/use it.

## Lifecycle Service

Use the official SteamManager as a behavior reference, not as a required architecture. A project-owned wrapper can expose a narrow API:

```csharp
public interface ISteamPlatform
{
    bool IsAvailable { get; }
    ulong UserId { get; }
    string PersonaName { get; }
}
```

Implementation rules:

- Initialize once.
- Pump callbacks once.
- Expose unavailable Steam as a valid state, not a crash path.
- Log actionable failures: missing Steam client, missing App ID, wrong DLL, wrong OS user, missing license.
- Do not call Steam APIs from unrelated `OnDestroy` methods after the lifecycle service may have shut down.

Minimal lifecycle sketch:

```csharp
using Steamworks;
using UnityEngine;

public sealed class SteamPlatformService : MonoBehaviour, ISteamPlatform
{
    static SteamPlatformService instance;
    bool initialized;

    public bool IsAvailable => initialized;
    public ulong UserId => initialized ? SteamUser.GetSteamID().m_SteamID : 0UL;
    public string PersonaName => initialized ? SteamFriends.GetPersonaName() : string.Empty;

    void Awake()
    {
        if (instance != null)
        {
            Destroy(gameObject);
            return;
        }

        instance = this;
        DontDestroyOnLoad(gameObject);

        if (!Packsize.Test())
        {
            Debug.LogError("Steamworks.NET packsize check failed.");
        }

        if (!DllCheck.Test())
        {
            Debug.LogError("Steamworks.NET DLL check failed.");
        }

        initialized = SteamAPI.Init();
        if (!initialized)
        {
            Debug.LogWarning("Steam is unavailable; Steam features will be disabled.");
        }
    }

    void Update()
    {
        if (initialized)
        {
            SteamAPI.RunCallbacks();
        }
    }

    void OnDestroy()
    {
        if (instance != this)
        {
            return;
        }

        if (initialized)
        {
            SteamAPI.Shutdown();
            initialized = false;
        }

        instance = null;
    }
}
```

This sketch is intentionally minimal and is not production-ready by itself. Production and release-like integrations should also decide `SteamAPI.RestartAppIfNecessary(realAppId)` behavior, catch `DllNotFoundException` around first Steam API use, and guard against reinitializing after shutdown. Use the official SteamManager as the baseline for those semantics, then adapt it to the project bootstrap.

If the project already imports `SteamManager.cs`, prefer adapting or wrapping it. Do not run this sketch alongside another manager.

## Feature Services

### Achievements and Stats

Expose API-name-based methods and hide `SteamUserStats` details:

```csharp
public interface ISteamAchievements
{
    bool Unlock(string apiName);
    bool Clear(string apiName);
}
```

Rules:

- Use achievement API names from Steamworks partner config, not display names.
- Model stats readiness explicitly: `Unavailable -> Initialized -> StatsRequested -> StatsReady -> Dirty -> StorePending -> Stored/Failed`.
- Request stats before reading user stats if the feature depends on current values.
- Call `StoreStats()` after mutations that must persist.
- Handle `UserStatsReceived_t` and `UserStatsStored_t`.
- Keep offline or not-initialized behavior explicit.

### Leaderboards

Use one service per leaderboard family or a keyed service with cached handles:

```csharp
sealed class PendingLeaderboard
{
    public SteamLeaderboard_t Handle;
    public CallResult<LeaderboardFindResult_t> FindResult;
    public CallResult<LeaderboardScoreUploaded_t> UploadResult;
}
```

Rules:

- Treat `SteamLeaderboard_t` as invalid until the find/create call succeeds.
- Keep `CallResult<T>` objects alive.
- Use one live `CallResult<T>` per pending Steam API call or a keyed pending-operation object. Reusing a `CallResult<T>` for another call before the first completes cancels/unregisters the previous pending result.
- Check `ioFailure`, found flags, score changed flags, and result values.
- Decide whether scores should use "keep best" semantics in Steamworks partner settings and document it in code comments where uploads happen.

### Lobbies

Keep lobby membership/discovery separate from FishNet transport:

```csharp
public interface ISteamLobbySession
{
    void CreateLobby(int maxMembers);
    void JoinLobby(ulong lobbyId);
    void LeaveLobby();
}
```

Rules:

- Use lobby metadata for discovery and session bootstrap data only.
- Keep host/client start calls in the networking/session layer.
- React to lobby owner changes and member leaving.
- Remove stale lobby metadata when ending a session.

Recommended lobby metadata keys:

| Key | Purpose | Trust level |
| --- | --- | --- |
| `build` or `protocol` | Reject incompatible clients before connecting. | Client-visible hint; still validate in session/auth. |
| `mode` | Filter game mode in UI. | UI/filter hint. |
| `scene` or `map` | Show intended content. | UI/filter hint. |
| `hostSteamId` | Bootstrap FishySteamworks/FishNet connection. | Must match lobby owner/session authority expectations. |
| `maxPlayers` | Display capacity. | UI hint; FishNet enforces actual capacity. |
| `joinable` | Hide in-progress/private sessions. | UI hint; session layer must enforce. |
| `region` | Optional matchmaking filter. | UI/filter hint. |

### Auth

Use auth tickets when a backend or server-authoritative flow needs proof:

- For web/backend login, prefer `SteamUser.GetAuthTicketForWebApi(identity)`, handle `GetTicketForWebApiResponse_t`, send the ticket to the backend, and verify with Steam Web API.
- For game server/session auth, use session-ticket APIs such as `GetAuthSessionTicket`, `BeginAuthSession`, and matching end/cancel calls.
- For encrypted app tickets, include the separate `sdkencryptedappticket` native library and keep encrypted ticket keys out of the client.
- Cancel/end tickets on disconnect/logout.

Do not accept `CSteamID`, persona name, lobby membership, or FishySteamworks connection success as authentication proof. Never ship publisher keys or backend secrets in the Unity client.

### Cloud Saves

Treat Steam Remote Storage as a sync transport for the project's save format:

- For simple folder syncing, prefer Steam Auto-Cloud configuration when it meets the product need.
- Keep local save versioning independent.
- Include Steam user identity in local save paths when several Steam users can share a machine.
- Check quota and file existence.
- Handle offline and cloud conflict cases.
- Do not block critical gameplay frames on large synchronous reads/writes.

Cloud strategy checklist:

| Topic | Decision |
| --- | --- |
| Sync type | Auto-Cloud configuration vs `SteamRemoteStorage` API. |
| Startup | Pull latest, merge with local, or defer until user selects profile. |
| Writes | Save immediately, batch at checkpoints, or flush on quit. |
| Conflict | Timestamp winner, user choice, slot-level conflict UI, or backend authority. |
| Failure UI | Silent retry, warning banner, or save-disabled state. |
| Quota | Preflight size and file count before writing. |
| Filename | Cross-platform legal names; no raw user text without sanitizing. |

## FishySteamworks Session Boundary

For FishNet + FishySteamworks:

```text
SteamLobbyService
  creates/finds/joins Steam lobby
  publishes host CSteamID or session metadata

GameSessionService
  decides host/client role
  starts FishNet ServerManager/ClientManager

FishySteamworks Transport
  handles Steam transport connection details
```

Rules:

- Steamworks.NET remains the only Steam wrapper.
- FishySteamworks remains the only FishNet Steam transport.
- If FishySteamworks samples or optional SteamManager assets are imported, remove/disable duplicate Steam managers and wire the transport to the existing lifecycle owner.
- Lobby code should not manipulate transport internals directly.
- Transport code should not own achievements, stats, overlay, friends, or cloud.
- Provide a non-Steam development transport only through explicit dev configuration.

Typical host flow:

```text
Steam initialized
-> SteamLobbyService.CreateLobby
-> Set lobby metadata: build/protocol/mode/hostSteamId/joinable
-> GameSessionService starts FishNet server/host
-> FishySteamworks transport handles Steam transport connection
```

Typical client flow:

```text
Steam initialized
-> Request/filter lobby list or receive invite
-> Join lobby
-> Validate metadata: build/protocol/joinable
-> Read hostSteamId/session data
-> GameSessionService starts FishNet client
-> Wait for FishNet connected + authenticated before spawning gameplay player
```

## Testing Strategy

For feature work, use test doubles around project interfaces and keep Steamworks.NET calls at the edge:

- Unit-test gameplay behavior against `ISteamPlatform`, `ISteamAchievements`, or similar interfaces.
- Use Play Mode or integration smoke tests for lifecycle and callback pumping.
- Manually verify Steam-only features with a running Steam client and correct App ID.
- For multiplayer, plan two accounts/machines or a dedicated test setup; same-machine multi-client testing is constrained by Steam.

Use Arrange/Act/Assert or Given/When/Then style for non-trivial cases:

```csharp
// Given Steam is unavailable
// When gameplay awards an achievement
// Then the game continues and reports a disabled Steam feature without throwing
```

## Implementation Checklist

- Define narrow project interfaces before spreading Steamworks.NET calls.
- Place the lifecycle service in an early-loaded bootstrap scene or installer.
- Confirm there is one `SteamAPI.Init`, one `RunCallbacks`, and one shutdown path.
- Keep feature services tolerant of `IsAvailable == false`.
- Store every callback/call-result object as a field.
- Use one active `CallResult<T>` per concurrent pending API call.
- Document Steam AppID, dev AppID, and release AppID handling.
- Validate the FishySteamworks transport path separately from Steam lobby discovery.
- Verify a player build, not only the Unity Editor.
