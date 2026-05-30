# Steamworks.NET Integration Guide

## Contents

- When to Read This
- Source Priority
- Installation
- SteamManager and Lifecycle
- Callback and CallResult Rules
- API Quick Reference
- Common API Areas
- FishySteamworks Boundary
- Source Navigation
- Build and Runtime Checks

## When to Read This

Read this file for new Steamworks.NET integrations, library selection, lifecycle rules, API ownership, callback/call-result use, and release verification. For symptom diagnosis, read `troubleshooting.md`; for architecture and project service examples, read `service-patterns.md`; for exact source navigation, read `source-map.md`.

## Source Priority

1. Local Unity package/source files.
2. Steamworks.NET official docs: `https://steamworks.github.io/`.
3. Steamworks.NET GitHub source and releases: `https://github.com/rlabrecque/Steamworks.NET`.
4. SteamManager helper source: `https://github.com/rlabrecque/Steamworks.NET-SteamManager`.
5. Valve Steamworks partner docs for API semantics mirrored from the C++ SDK.

Steamworks.NET intentionally stays close to Valve's C++ API. When wrapper docs are thin, inspect the generated wrapper code for names/types and use Valve docs for behavior.

## Installation

Prefer Unity Package Manager with a pinned Steamworks.NET release tag. The official installation page recommends UPM for Unity and release pages publish install URLs such as:

```text
https://github.com/rlabrecque/Steamworks.NET.git?path=/com.rlabrecque.steamworks.net#2025.163.0
```

Use the project's chosen tag, not `master`, unless the task is explicitly to test unreleased changes.

Check:

- `Packages/manifest.json` for `com.rlabrecque.steamworks.net`.
- `Packages/packages-lock.json` for the resolved revision.
- `package.json` in the package for package version and Unity compatibility.
- Native plugins under the package for Windows, macOS, and Linux targets.
- Custom asmdefs reference `com.rlabrecque.steamworks.net` or otherwise have access to the package assembly.

Avoid:

- Importing a `.unitypackage` over an existing UPM install.
- Keeping multiple `Steamworks.NET` copies in `Assets` and `Packages`.
- Mixing Steamworks.NET and Facepunch.Steamworks in the same runtime unless the user explicitly accepts that risk.

## SteamManager and Lifecycle

A stable Unity integration has one lifecycle owner:

- `SteamAPI.Init()` once before Steam API calls.
- `SteamAPI.RunCallbacks()` once per frame while initialized.
- `SteamAPI.Shutdown()` once on application quit.

The official SteamManager helper is a useful reference, but local project ownership matters more than copying it blindly. If the project already has a Steam manager, adapt that owner.

Local development generally needs `steam_appid.txt` next to the executable or in the Unity working directory. Use Spacewar AppID `480` only for samples or local smoke tests, never as a production default.

The SteamManager helper also models these guardrails:

- Run `Packsize.Test()` and `DllCheck.Test()` early to catch wrong package/native binary versions.
- Use `SteamAPI.RestartAppIfNecessary(appId)` in release-like builds where relaunch-through-Steam behavior is intended.
- Set `SteamClient.SetWarningMessageHook(...)` and launch with `-debug_steamapi` when low-level warnings are useful.
- Avoid Steamworks calls from arbitrary `OnDestroy` methods because shutdown ordering is fragile; prefer `OnDisable` or explicit project-level shutdown sequencing.
- Reset static manager state when Unity domain reload is disabled.

Do not present a minimal `SteamAPI.Init()` wrapper as production-ready unless it explicitly omits release-launch handling. Production or release-like builds should decide whether to call `SteamAPI.RestartAppIfNecessary(realAppId)` before `SteamAPI.Init()`, catch `DllNotFoundException` around the first Steam API call, and guard against creating a second manager after shutdown. Use the official SteamManager as the baseline for these semantics, then adapt it to the project bootstrap.

## Callback and CallResult Rules

Use `Callback<T>` for events Steam sends to registered listeners:

```csharp
Callback<GameOverlayActivated_t> overlayActivated;

void Awake()
{
    overlayActivated = Callback<GameOverlayActivated_t>.Create(OnOverlayActivated);
}

void OnOverlayActivated(GameOverlayActivated_t callback)
{
    bool active = callback.m_bActive != 0;
}
```

Use `CallResult<T>` for async calls that return `SteamAPICall_t`:

```csharp
CallResult<LeaderboardFindResult_t> leaderboardFind;

void Awake()
{
    leaderboardFind = CallResult<LeaderboardFindResult_t>.Create(OnLeaderboardFind);
}

void FindLeaderboard(string name)
{
    SteamAPICall_t handle = SteamUserStats.FindLeaderboard(name);
    leaderboardFind.Set(handle, OnLeaderboardFind);
}

void OnLeaderboardFind(LeaderboardFindResult_t result, bool ioFailure)
{
    if (ioFailure || result.m_bLeaderboardFound == 0)
    {
        return;
    }
}
```

Store callbacks and call results as fields for the lifetime you need them. Local variables are a common source of lost callbacks.

Create callbacks/call results in `OnEnable` or another lifecycle point that runs after Unity assembly reload when the owner is scene/UI scoped. Dispose, unregister, or cancel them in `OnDisable` when the owner no longer wants events. Long-lived platform services may keep them for the whole Steam session; short-lived UI and screens should not leave callbacks registered after closing.

Choose the callback type by API shape:

| API shape | Use | Example |
| --- | --- | --- |
| Steam broadcasts an event whenever it occurs | `Callback<T>` | overlay activation, lobby chat update, user stats stored |
| Method returns `SteamAPICall_t` | `CallResult<T>` | find leaderboard, request lobby list, upload score |
| Server callback stream | `Callback<T>.CreateGameServer` | only for Steam game server APIs |

A `CallResult<T>` instance tracks one pending `SteamAPICall_t` at a time. Reusing the same instance for a second call before the first completes cancels or unregisters the previous pending result in Steamworks.NET. For concurrent operations, allocate one live `CallResult<T>` per pending call or keep a keyed pending-operation object that owns its `CallResult<T>` until completion or cancellation.

## API Quick Reference

| Need | Primary wrapper | Typical callback/result | Notes |
| --- | --- | --- | --- |
| Logged-in user ID | `SteamUser.GetSteamID()` | none | Use `CSteamID`/numeric ID for identity, not persona name. |
| Persona/friends/overlay | `SteamFriends` | `GameOverlayActivated_t`, persona callbacks | Overlay must be verified in player builds. |
| Achievements/stats | `SteamUserStats` | `UserStatsReceived_t`, `UserStatsStored_t` | Use backend API names and `StoreStats()`. |
| Leaderboards | `SteamUserStats` | `LeaderboardFindResult_t`, `LeaderboardScoreUploaded_t`, `LeaderboardScoresDownloaded_t` | Find/create before upload/download. |
| Lobby matchmaking | `SteamMatchmaking` | `LobbyCreated_t`, `LobbyEnter_t`, `LobbyMatchList_t`, lobby chat/update callbacks | Lobbies discover sessions; transport connects separately. |
| Client auth ticket | `SteamUser` | API-specific ticket handles/callbacks | Backend must verify tickets; raw Steam ID is not proof. |
| Remote storage/cloud | `SteamRemoteStorage` | storage/file callbacks where applicable | Keep local save versioning independent. |
| UGC/workshop | `SteamUGC` | query/update call results | Requires backend/workshop configuration. |
| Networking sockets | `SteamNetworkingSockets`, transport library | transport-specific callbacks | If using FishySteamworks, let the transport own this layer. |
| Steam input | `SteamInput` | input action events/callbacks | Some input data also updates through callback pumping. |

## Common API Areas

### Achievements and Stats

State machine:

```text
Unavailable -> Initialized -> StatsRequested -> StatsReady -> Dirty -> StorePending -> Stored/Failed
```

Typical flow:

1. Wait for Steam initialization.
2. Call `RequestCurrentStats()` or wait for current stats where the feature depends on existing values.
3. Use `SteamUserStats.SetAchievement`, `ClearAchievement`, `SetStat`, or `UpdateAvgRateStat`.
4. Call `SteamUserStats.StoreStats()` when changes should persist.
5. Handle `UserStatsReceived_t` and `UserStatsStored_t` for success/failure.

Common mistakes:

- Using achievement display names instead of API names from Steamworks partner configuration.
- Forgetting `StoreStats()`.
- Treating stats as immediately available before the stats callback.

### Leaderboards

Typical flow:

1. `FindLeaderboard` or `FindOrCreateLeaderboard`.
2. Store the `SteamLeaderboard_t` handle from `LeaderboardFindResult_t`.
3. `UploadLeaderboardScore` or `DownloadLeaderboardEntries`.
4. Handle `LeaderboardScoreUploaded_t` or `LeaderboardScoresDownloaded_t`.

Always branch on `ioFailure`, found/upload flags, and result codes. Do not assume handles are valid.

### Lobbies and Matchmaking

Use Steam matchmaking APIs for lobby discovery, metadata, invites, and user identity. Keep networking transport ownership separate:

- Lobby/session orchestration can live in a Steam matchmaking service.
- FishySteamworks should own FishNet transport connection mechanics.
- Do not let lobby code call FishNet transport internals except through a narrow session interface.

Common lobby flow:

1. Host creates a lobby and writes metadata needed for discovery.
2. Client lists or joins lobby via Steam matchmaking.
3. Session layer extracts host Steam ID or agreed connection data.
4. FishNet starts host/client through the configured FishySteamworks transport.
5. Lobby membership changes update UI/session state without owning low-level transport behavior.

### Auth

Use Steam auth tickets for backend identity verification or session authorization:

- Web/backend login: prefer `SteamUser.GetAuthTicketForWebApi(identity)`, handle `GetTicketForWebApiResponse_t`, then verify server-side with Steam Web API.
- Game server/session auth: use session-ticket APIs such as `GetAuthSessionTicket`, `BeginAuthSession`, and the matching end/cancel calls.
- Encrypted App Tickets require the separate `sdkencryptedappticket` native library from the Steamworks SDK and should not be assumed to work from the base Steamworks.NET package alone.

Do not treat `SteamID` alone as proof of authentication in server-authoritative flows.

For backend-owned games, document the trust boundary:

- Client code can identify the logged-in Steam user, but the backend decides account/session authority.
- Backend verification should use a Steam auth ticket or an equivalent trusted Steam flow.
- Ticket cancellation and session logout should be part of disconnect handling.
- Never put Steam Web API publisher keys, encrypted app ticket keys, or other backend secrets in the Unity client.

### Cloud Saves

Use `SteamRemoteStorage` only after deciding how it coexists with local saves:

- Keep local save format/versioning independent from Steam Cloud transport.
- Check quota and file existence.
- Handle offline and conflict cases explicitly.
- For simple save folders, consider Steam Auto-Cloud configuration before writing Remote Storage code.
- For API-driven cloud, document startup pull, save-time write, quit-time flush, conflict resolution, quota handling, and UI for sync failures.
- Include the Steam user ID in local save paths when multiple Steam users may share the same machine.

## FishySteamworks Boundary

When the project uses FishNet plus FishySteamworks:

- Steamworks.NET is the single Steam wrapper.
- FishySteamworks is the FishNet transport.
- A project-owned Steam service handles achievements, stats, leaderboards, lobbies, auth, cloud, overlay, and friends.
- The transport receives only the identifiers/settings it needs to connect.

Do not add Facepunch.Steamworks for unrelated Steam APIs. If the project chooses the Facepunch route, switch the transport to FishyFacepunch and remove Steamworks.NET-dependent code.

When importing FishySteamworks, check whether its optional SteamManager package or sample manager was imported. If the project already has a Steam lifecycle owner, do not keep the FishySteamworks/sample manager active. Wire FishySteamworks to the existing initialized Steamworks.NET lifecycle instead.

Use a non-Steam transport for fast local editor iteration when Steam account/client constraints make same-machine testing impractical. Keep this as a development setting, not a silent runtime fallback for shipped Steam builds.

## Source Navigation

Look for these names in the Steamworks.NET source:

- `SteamAPI` for init, callbacks, shutdown.
- `Callback<T>` and `CallResult<T>` for callback infrastructure.
- `SteamUser`, `SteamFriends`, `SteamUserStats`, `SteamMatchmaking`, `SteamRemoteStorage`, `SteamNetworkingSockets`.
- `SteamAPICall_t`, `SteamLeaderboard_t`, `CSteamID`, `AppId_t`.
- `NativeMethods` when a wrapper method's native binding matters.
- `Packsize` and `DllCheck` when package/native version mismatches are suspected.
- `Editor/RedistInstall.cs` and `Editor/RedistCopy.cs` when Steam redistributable copying behaves unexpectedly.

Useful searches:

```powershell
rg "class SteamManager|SteamAPI.Init|RunCallbacks|SteamAPI.Shutdown" .
rg "Callback<|CallResult<|SteamAPICall_t" .
rg "SetAchievement|StoreStats|FindLeaderboard|CreateLobby|BeginAuthSession" .
rg "Facepunch|FishySteamworks|FishyFacepunch" .
rg "Packsize.Test|DllCheck.Test|RestartAppIfNecessary|steam_appid" .
```

## Build and Runtime Checks

Before calling Steam integration complete:

- Unity compiles with no console errors.
- Steam client is running under a test account.
- App ID matches the intended environment.
- Overlay opens in a player build where overlay support is expected.
- Target platform has matching Steam native binaries.
- IL2CPP builds preserve required Steamworks.NET types and native libraries.
- A smoke test covers initialization, callback pumping, one feature API, and quit.

For local multiplayer, remember Steam account/client limitations. Testing two clients often needs two machines/accounts, or a non-Steam transport for local editor iteration.

Release verification matrix:

| Area | Editor | Player direct launch | Player launched through Steam |
| --- | --- | --- | --- |
| Compile and package import | Required | Required | Required |
| `SteamAPI.Init()` | Useful | Required for dev AppID | Required for release AppID |
| `RestartAppIfNecessary` behavior | Usually disabled | Intentional relaunch/quit behavior | No unexpected relaunch |
| Overlay | Not sufficient | Often unreliable | Required if feature uses overlay |
| Achievements/stats | Smoke only | Smoke with correct AppID | Required before release |
| Lobby + FishySteamworks | Limited | Useful with dev setup | Required with two accounts/machines |
| Auth | Mock/backend dev | Ticket negative/positive tests | Required against release backend |
| Cloud | Local smoke | Sync/conflict tests | Two-machine sync before release |
