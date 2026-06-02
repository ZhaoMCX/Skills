# Steamworks.NET Source Map

## Contents

- When to Read This
- Official Repositories
- Unity Package Layout
- Runtime Files
- Editor Files
- Generated Wrapper Pattern
- SteamManager Behavior
- Source Search Recipes
- When to Use Valve Docs

## When to Read This

Read this file when exact Steamworks.NET source locations, generated wrapper signatures, package layout, native plugin files, or SteamManager behavior are unclear. For general integration flow, read `integration-guide.md`; for architecture, read `service-patterns.md`.

## Official Repositories

- Steamworks.NET: `https://github.com/rlabrecque/Steamworks.NET`
- SteamManager helper: `https://github.com/rlabrecque/Steamworks.NET-SteamManager`
- Official docs: `https://steamworks.github.io/`
- Valve partner docs: `https://partner.steamgames.com/doc/home`

The UPM package is named `com.rlabrecque.steamworks.net`. Do not treat this file's version notes as current. For latest guidance, check the installed package `package.json`, `Version.cs`, and the GitHub release/tag being used. `master` may differ from the latest released UPM tag.

## Unity Package Layout

UPM package root:

```text
com.rlabrecque.steamworks.net/
  package.json
  Runtime/
  Editor/
  Plugins/
```

Common local project locations:

```text
Packages/com.rlabrecque.steamworks.net/
Assets/Plugins/Steamworks.NET/
Assets/Steamworks.NET/
```

If more than one exists, stop and resolve duplicate package ownership before debugging feature code.

## Runtime Files

Important files in `Runtime/`:

| File/path | Purpose |
| --- | --- |
| `Steam.cs` | `SteamAPI` and `GameServer` lifecycle wrappers, callback pumping, restart/shutdown helpers. |
| `CallbackDispatcher.cs` | `Callback<T>`, `CallResult<T>`, callback registration and dispatch. |
| `InteropHelp.cs` | Interop helpers and `DllCheck`. |
| `Packsize.cs` | Struct packing validation. |
| `Version.cs` | Wrapper version data. |
| `autogen/*.cs` | Generated wrappers for Steam interfaces, callbacks, constants, enums, structs. |
| `types/*` | Strongly typed Steam handles and custom types. |
| `com.rlabrecque.steamworks.net.asmdef` | Runtime assembly definition. |

Important native plugin files in `Plugins/`:

| File | Platform |
| --- | --- |
| `steam_api.dll` | Windows x86 |
| `steam_api64.dll` | Windows x64 |
| `libsteam_api.so` | Linux |
| `steam_api.bundle/.../libsteam_api.dylib` | macOS |

## Editor Files

Important files in `Editor/`:

| File/path | Purpose |
| --- | --- |
| `RedistInstall.cs` | Editor helper for installing Steamworks redistributables. |
| `RedistCopy.cs` | Editor/build helper for copying redistributables. |
| `Settings/*` | Project settings UI for package/editor integration. |
| `com.rlabrecque.steamworks.net.editor.asmdef` | Editor assembly definition. |

If a build lacks native Steam binaries, inspect editor copy/install behavior before adding manual post-build hacks.

## Generated Wrapper Pattern

Steamworks.NET closely mirrors Valve's C++ APIs:

- Static C# classes commonly map to Steam interfaces: `SteamUserStats`, `SteamMatchmaking`, `SteamFriends`, `SteamRemoteStorage`.
- Methods often call `NativeMethods.*` with handles from `CSteamAPIContext`.
- Async Valve APIs returning `SteamAPICall_t` need `CallResult<T>`.
- Broadcast callbacks are structs in `Runtime/autogen/SteamCallbacks.cs`.
- Enums are in `Runtime/autogen/SteamEnums.cs`.
- Handles and value types are under `Runtime/types`.

When implementing an API:

1. Search the local generated wrapper method.
2. Read the method return type and callback struct.
3. Check Valve docs for semantic rules and backend configuration requirements.
4. Write project wrapper code that hides raw Steamworks.NET details from gameplay/UI.

## SteamManager Behavior

The official `SteamManager.cs` helper:

- Is `[DisallowMultipleComponent]`.
- Creates/preserves one manager instance.
- Uses `DontDestroyOnLoad`.
- Prevents reinitializing Steam after it has already been initialized once in the session.
- Runs `Packsize.Test()` and `DllCheck.Test()`.
- Optionally calls `SteamAPI.RestartAppIfNecessary(AppId_t.Invalid)` as a placeholder to replace with a real App ID.
- Catches `DllNotFoundException` around restart/init flow.
- Calls `SteamAPI.Init()` in `Awake`.
- Sets a warning hook in `OnEnable` when initialized.
- Calls `SteamAPI.RunCallbacks()` in `Update`.
- Calls `SteamAPI.Shutdown()` in `OnDestroy`.
- Warns against Steamworks calls from arbitrary `OnDestroy` methods because shutdown order is unreliable; prefer `OnDisable`.
- Resets static state for Unity domain-reload-disabled play mode via `RuntimeInitializeOnLoadMethod`.

Use it as a reference for lifecycle behavior. In larger projects, it is often better to wrap/adapt this behavior into the project's bootstrap/service pattern.

## Source Search Recipes

Find lifecycle owners:

```powershell
rg "SteamAPI\.Init|SteamAPI\.RunCallbacks|SteamAPI\.Shutdown|RestartAppIfNecessary" Assets Packages
rg "class SteamManager|SteamPlatformService|Packsize\.Test|DllCheck\.Test" Assets Packages
```

Find callbacks:

```powershell
rg "Callback<|CallResult<|SteamAPICall_t|CreateGameServer" Assets Packages
rg "UserStatsReceived_t|UserStatsStored_t|LeaderboardFindResult_t|LobbyCreated_t|LobbyEnter_t" Assets Packages
```

Find package conflicts:

```powershell
rg "Facepunch\.Steamworks|namespace Steamworks|com\.rlabrecque\.steamworks\.net" Assets Packages
rg --files Assets Packages | rg "Steamworks.NET|steam_api|Facepunch|FishySteamworks|FishyFacepunch"
```

Find generated wrapper definitions:

```powershell
rg "public static .*SetAchievement|public static .*FindLeaderboard|public static .*CreateLobby" Packages/com.rlabrecque.steamworks.net/Runtime
rg "struct .*_t" Packages/com.rlabrecque.steamworks.net/Runtime/autogen
```

## When to Use Valve Docs

Use Valve docs when:

- Steamworks.NET docs only expose a wrapper signature.
- Backend configuration affects behavior, such as achievements, stats, leaderboards, depots, packages, auth, or cloud.
- A return value or callback field needs semantic interpretation.
- Steam networking or matchmaking behavior depends on platform policy.

Keep code examples in C# and Steamworks.NET style, but use Valve docs for the underlying rules.
