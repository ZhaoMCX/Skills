---
name: unity-steamworks-net
description: Use when integrating, reviewing, debugging, or planning Steamworks.NET in Unity projects, especially SteamManager/lifecycle, callbacks/CallResults, achievements/stats/leaderboards/lobbies/auth/cloud, FishySteamworks coexistence, Steam DLL/IL2CPP builds, SteamAPI.Init failures, or overlay issues.
---

# Steamworks.NET

## Overview

Use Steamworks.NET as the Unity-facing C# wrapper for Valve Steamworks APIs. Treat the local Unity package/source as the first source of truth, then confirm behavior with the official Steamworks.NET docs and Valve docs when the wrapper mirrors Valve's C++ API.

## Reference Map

- `references/integration-guide.md`: installation, lifecycle, callbacks, API areas, FishySteamworks boundary, and runtime checks.
- `references/service-patterns.md`: project-owned service boundaries, sample interfaces, achievements/stats, leaderboards, lobbies, auth, cloud, and FishNet/FishySteamworks integration patterns.
- `references/troubleshooting.md`: symptom-based diagnosis for init failures, missing DLLs, overlay, callbacks, achievements, stats, leaderboard, lobby, FishySteamworks, IL2CPP, and local multiplayer issues.
- `references/source-map.md`: official source layout, important files, generated wrapper map, SteamManager behavior, and useful `rg` searches.

## When Not To Use

- Facepunch-only projects unless the task is migration or conflict review.
- Pure Valve Web API/backend work with no Unity/Steamworks.NET client.
- Non-Unity Steam SDK work unless Steamworks.NET source mapping is still relevant.

## Read First

Before adding or changing Steamworks.NET behavior:

1. Identify how Steamworks.NET is installed: Unity UPM package, imported `.unitypackage`, embedded package, or vendor folder.
2. Inspect the local package/source for exact API signatures before writing code. Common paths:
   - `Packages/com.rlabrecque.steamworks.net`
   - `Assets/Plugins/Steamworks.NET`
   - `Assets/Steamworks.NET`
3. Find the active Steam lifecycle owner. A Unity project should have one Steam initialization path and one callback pump.
4. Read `references/integration-guide.md` for installation, SteamManager, callbacks, common APIs, FishySteamworks boundaries, and build checks.
5. Use online docs only when local files do not answer the question or the task asks for current version guidance.

If the task is a bug report, start with `references/troubleshooting.md`. If the task involves architecture or a first stable integration, read `references/service-patterns.md`. If exact signatures or wrapper behavior are unclear, read `references/source-map.md` and inspect the local package source.

Official sources:

- Steamworks.NET docs: `https://steamworks.github.io/`
- Installation: `https://steamworks.github.io/installation/`
- GitHub source/releases: `https://github.com/rlabrecque/Steamworks.NET`
- SteamManager source: `https://github.com/rlabrecque/Steamworks.NET-SteamManager`
- Valve Steamworks docs: `https://partner.steamgames.com/doc/home`

## Decision Rules

| Situation | Default choice |
| --- | --- |
| Unity project needs Steam APIs and FishNet transport uses FishySteamworks | Use Steamworks.NET as the only Steam wrapper and FishySteamworks as transport only. |
| Project already uses Facepunch.Steamworks | Do not add Steamworks.NET casually; use a Facepunch-compatible transport such as FishyFacepunch or plan a migration. |
| Multiple Steam managers exist | Consolidate to one lifecycle owner before adding features. |
| Callback does not fire | Verify `RunCallbacks`, callback field lifetime, correct `Callback<T>` vs `CallResult<T>`, and Steam initialization. |
| Steam API signature is uncertain | Inspect local `Runtime/autogen/*.cs`, `Runtime/types/*`, and Valve docs for semantics. |
| Cannot run Steam locally | Keep changes behind graceful failure paths and state that Steam runtime verification is still required. |

## Review Checklist

- There is exactly one Steam initialization/shutdown owner.
- `SteamAPI.RunCallbacks()` runs while initialized and is not called by multiple managers.
- Steamworks.NET and Facepunch.Steamworks are not both active.
- FishySteamworks is treated as transport, not the project-wide Steam service.
- Callback and CallResult objects are stored as fields, not local variables that can be collected.
- Concurrent async Steam calls do not reuse one `CallResult<T>` instance.
- Stats/achievements call `StoreStats()` when the change should be persisted.
- Async APIs check `EResult`, failure flags, and invalid handles before mutating game state.
- Editor and local builds have `steam_appid.txt`; shipping behavior is intentional.
- Platform native binaries match the target build.
- Steam APIs fail gracefully when Steam is unavailable or initialization fails.
- Lobby, matchmaking, and transport layers have clear boundaries.
- Backend auth flows do not trust a raw `CSteamID` without ticket verification.
- Unity Console, a real Steam client run, and at least one player build verify the integration path.
