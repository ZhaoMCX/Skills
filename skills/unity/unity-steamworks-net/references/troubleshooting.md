# Steamworks.NET Troubleshooting

## Contents

- When to Read This
- Debugging Order
- Symptom Table
- Initialization Failures
- Missing DLL or Wrong Binary
- Callback Problems
- Achievements and Stats
- Leaderboards
- Overlay and Friends
- Lobbies and FishySteamworks
- IL2CPP and Build Issues
- Verification Scriptlets

## When to Read This

Read this file when Steam initialization, callbacks, overlay, achievements, stats, leaderboards, lobbies, FishySteamworks, native binaries, or builds behave unexpectedly. For planned architecture, read `service-patterns.md`; for initial integration rules, read `integration-guide.md`.

## Debugging Order

1. Confirm the project has exactly one Steamworks.NET install.
2. Confirm the project has exactly one Steam lifecycle owner.
3. Confirm `SteamAPI.Init()` result and logs.
4. Confirm `SteamAPI.RunCallbacks()` runs every frame after init.
5. Confirm `steam_appid.txt`, Steam client, account license, and OS user context.
6. Confirm native Steam binaries match platform and package version.
7. Confirm the feature-specific callback or `CallResult<T>` is stored and handled.

Do not start by rewriting feature code. Steam integration bugs often come from lifecycle, environment, or callback pumping.

## Symptom Table

| Symptom | Likely causes | First checks |
| --- | --- | --- |
| `SteamAPI.Init()` returns false | Steam client closed, missing/wrong App ID, app not owned by account, wrong OS user/admin context, app not configured | Steam running, `steam_appid.txt`, account license, App ID setup |
| `DllNotFoundException` for steam API | Missing native binary, wrong platform import settings, wrong output folder | `Plugins/steam_api*.dll`, `.so`, `.dylib`, build output |
| `Packsize.Test()` fails | Managed wrapper and native SDK mismatch | Duplicate install, package version, old DLL |
| `DllCheck.Test()` fails | Native binaries don't match wrapper version | Remove stale binaries, reinstall package |
| Callbacks never fire | `RunCallbacks()` not called, callback stored as local, wrong callback type, Steam not initialized | Lifecycle owner, callback fields, `Callback<T>` vs `CallResult<T>` |
| `CallResult<T>` never returns | `Set(handle, handler)` not called, call handle invalid, object collected | Store field, check returned `SteamAPICall_t`, callback pump |
| One async result disappears when another starts | Reusing one `CallResult<T>` for concurrent calls | One live `CallResult<T>` per pending call |
| Achievements don't unlock | Wrong API name, stats not loaded, no `StoreStats`, App ID mismatch | Partner config API names, logs, `UserStatsStored_t` |
| Overlay does not open | Not launched through Steam, overlay disabled, unsupported environment, wrong App ID | Player build, Steam launch, account settings |
| Lobby found but connection fails | Lobby/session metadata mismatch, transport not started, FishySteamworks config issue | Separate lobby success from FishNet transport logs |
| Works in Editor, fails in build | Missing binary/output file, different working directory, missing App ID file, platform settings | Build folder, current working directory, package import settings |
| Auth works in dev but fails against backend | Wrong ticket type, unverified ticket, expired/cancelled ticket, backend secret missing | Auth flow choice, ticket callback, backend verification logs |

## Initialization Failures

When `SteamAPI.Init()` fails, check the same causes documented by the official SteamManager comments:

- The Steam client is not running.
- Steam cannot determine the App ID.
- `steam_appid.txt` is missing, malformed, or in the wrong working directory for direct launches.
- The game is running under a different OS user/admin context than Steam.
- The active Steam account does not own the App ID or package.
- The App ID is not fully configured for the test account.

For release-like builds, decide whether to use:

```csharp
SteamAPI.RestartAppIfNecessary(new AppId_t(appId));
```

Use it only when relaunch-through-Steam behavior is intended. During editor/dev workflows, it can be disruptive.

## Missing DLL or Wrong Binary

Check both managed package and native binaries:

- UPM package: `Packages/com.rlabrecque.steamworks.net`.
- Package plugins: `Plugins/steam_api.dll`, `steam_api64.dll`, `libsteam_api.so`, `steam_api.bundle/.../libsteam_api.dylib`.
- Build output contains the expected native binary for the target.
- No older native Steam binaries exist elsewhere under `Assets`.

If `Packsize.Test()` or `DllCheck.Test()` fails, suspect duplicate installs or stale binaries before changing code.

## Callback Problems

Rules:

- `Callback<T>` handles broadcast callbacks.
- `CallResult<T>` handles a specific async call returned as `SteamAPICall_t`.
- Both require callback pumping.
- Both should be fields or otherwise strongly referenced.

Bad:

```csharp
void Start()
{
    var callback = Callback<GameOverlayActivated_t>.Create(OnOverlay);
}
```

Good:

```csharp
Callback<GameOverlayActivated_t> overlayActivated;

void Start()
{
    overlayActivated = Callback<GameOverlayActivated_t>.Create(OnOverlay);
}
```

For `CallResult<T>`, verify all three pieces:

```csharp
CallResult<LeaderboardFindResult_t> findResult;

void Awake()
{
    findResult = CallResult<LeaderboardFindResult_t>.Create();
}

void Find()
{
    SteamAPICall_t call = SteamUserStats.FindLeaderboard("score");
    findResult.Set(call, OnFind);
}
```

A `CallResult<T>` instance tracks one pending `SteamAPICall_t` at a time. If several leaderboard, lobby list, UGC, auth, or cloud operations can run concurrently, keep a pending-operation object per call and dispose/cancel it after completion.

## Achievements and Stats

Checklist:

- Stats readiness is tracked explicitly, not assumed immediately after Steam init.
- Achievement/stat API name matches Steamworks partner backend exactly.
- Steam initialized successfully before use.
- Current user stats have been requested/received if reading values.
- Mutation calls return success where available.
- `SteamUserStats.StoreStats()` is called after changes.
- `UserStatsStored_t` and `UserStatsReceived_t` are handled or logged.
- The test App ID has the achievement/stat configured.

Common trap: the Unity UI label "Win 10 Games" is not the API name. Use the backend API key such as `ACH_WIN_10_GAMES`.

## Leaderboards

Checklist:

- `FindLeaderboard` or `FindOrCreateLeaderboard` completed successfully.
- `LeaderboardFindResult_t.m_bLeaderboardFound` is checked.
- `SteamLeaderboard_t` handle is cached only after success.
- Upload/download uses a live handle.
- Upload callback checks `ioFailure`, `m_bSuccess`, and score changed details.
- Leaderboard sort/display settings in Steamworks backend match game expectations.

Do not upload before the leaderboard handle is known.

## Overlay and Friends

Overlay checks:

- Use a player build when possible; Editor overlay behavior can be misleading.
- Launch through Steam or use a valid local App ID setup.
- Check Steam client overlay settings globally and per game.
- Ensure no incompatible graphics/plugin environment is blocking overlay.
- Register `GameOverlayActivated_t` only to observe overlay state; it does not force overlay availability.

Friends checks:

- Persona names and friend lists depend on Steam client state and privacy.
- Use `CSteamID` for identity, not mutable persona names.
- Avoid making gameplay authority depend on friend display data.

## Lobbies and FishySteamworks

Separate the diagnosis:

1. Can Steam create/find/join the lobby?
2. Is lobby metadata correct?
3. Does the session service choose the correct host/client role?
4. Does FishNet start server/client successfully?
5. Does FishySteamworks connect through the expected Steam ID/transport settings?

If lobby works but connection fails, inspect FishNet/FishySteamworks configuration and logs. If connection works by direct configuration but lobby join fails, inspect Steam matchmaking callbacks and metadata.

Do not fix FishySteamworks by adding Facepunch.Steamworks. FishySteamworks is a Steamworks.NET transport.

Also check whether FishySteamworks sample or optional SteamManager assets were imported. Duplicate managers can make initialization and callback behavior look random.

Lobby metadata is not authority. Validate build/protocol/joinability in the session/auth layer before spawning gameplay players.

## Auth

Auth checks:

- Decide the flow before debugging: Web API ticket, session ticket, or encrypted app ticket.
- `GetAuthTicketForWebApi` should be paired with `GetTicketForWebApiResponse_t` and backend Web API verification.
- Session-ticket flows should pair ticket creation with `BeginAuthSession` and matching end/cancel calls.
- Encrypted App Tickets require separate `sdkencryptedappticket` native binaries and key handling.
- Never accept raw `CSteamID`, persona name, lobby membership, or FishySteamworks connection success as proof.
- Never log full tickets in production logs.
- Never place publisher keys or encrypted-ticket secrets in the Unity client.

## IL2CPP and Build Issues

Check:

- Target platform is supported by the Steamworks.NET package/native binaries.
- Managed stripping does not remove project wrapper code or callback holders.
- Native plugin import settings match CPU and OS.
- Build output includes the correct Steam native library.
- Steamworks calls are guarded on unsupported platforms.
- Conditional compilation does not disable Steam unexpectedly.
- Exact Steamworks.NET release notes and local package source have been checked before blaming project code.
- `DISABLESTEAMWORKS` or project-defined Steamworks symbols match the intended target platforms.
- Any custom native callback delegates are AOT-safe, usually static methods with the correct callback annotations/pinning pattern.
- Steamworks.NET editor redist scripts and build output were inspected before adding manual copy scripts.

The official SteamManager uses platform guards like standalone Windows/Linux/macOS or explicit Steamworks defines. Match the project target list deliberately.

## Verification Scriptlets

Useful local searches:

```powershell
rg "SteamAPI\.Init|RunCallbacks|SteamAPI\.Shutdown|RestartAppIfNecessary" Assets Packages
rg "new SteamManager|class SteamManager|SteamPlatformService" Assets Packages
rg "Callback<|CallResult<|SteamAPICall_t" Assets Packages
rg "steam_api64\.dll|steam_api\.dll|libsteam_api\.so|libsteam_api\.dylib" Assets Packages
rg "Facepunch\.Steamworks|FishySteamworks|FishyFacepunch" Assets Packages
```

Verification matrix:

| Check | Editor | Player build |
| --- | --- | --- |
| Compile clean | Required | Required |
| `SteamAPI.Init()` success | Useful | Required |
| Callback pump | Required | Required |
| Overlay | Useful but not sufficient | Required if used |
| Achievement/stat smoke test | Useful | Required before release |
| FishySteamworks multiplayer | Limited | Required with proper test setup |
