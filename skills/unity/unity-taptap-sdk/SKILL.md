---
name: unity-taptap-sdk
description: Guides TapTap SDK/TapSDK integration in Unity projects. Use when integrating, reviewing, debugging, upgrading, or planning UPM/package manifest setup, TapTap login, compliance/anti-addiction, cloud save, achievements, leaderboards, IAP, license validation, TapTap PC startup validation, Android/iOS/Windows builds, or migrations from TapSDK v2/v3 to v4.
---

# TapTap SDK For Unity

## Overview

Use TapSDK v4 as the default TapTap integration path for new Unity projects. Treat official TapTap developer docs and the local/installed package source as the authority, then apply the project architecture around a thin game-owned adapter instead of scattering SDK calls through gameplay code.

## Read First

Before adding or changing TapSDK behavior:

1. Inspect the Unity project for existing TapSDK packages, `Packages/manifest.json`, imported `.unitypackage` assets, asmdefs, and platform targets.
2. Prefer the official v4 docs and `taptap/tapsdk-unity-dist`; read `references/tapsdk-v4.md` for package names, module dependencies, platform checklists, migration rules, and source-derived warnings.
3. If TapSDK is already installed locally, inspect `Packages/com.taptap.sdk.*`, `Assets/TapSDK*`, `Assets/Plugins/TapSDK*`, or package cache source for exact public APIs and versions before relying on memory.
4. Re-check official docs before locking versions. TapSDK package versions, native dependencies, and PC/IAP rules are version-sensitive.
5. For existing TapSDK v2/v3 projects, identify the installed generation first. Do not mix v2/v3 package names or APIs with v4 modules.

## Integration Workflow

1. Choose only the modules required by the product feature.
   - Login or user identity: `Core + Login`.
   - China compliance: `Core + Login + Compliance`.
   - Cloud save, achievements, leaderboards, friends/relation, moments, online battle: include `Login` unless the local docs prove otherwise.
   - IAP: `IAP` plus Unity IAP, payment provider setup, and platform store configuration. Source currently registers the TapTap Unity IAP store only for Android.
   - TapTap PC: include `Core`, add `clientPublicKey`, and gate business calls behind PC startup validation.
2. Install through Unity Package Manager when possible. Use official stable versions by default; only use beta tags when the user asks or the target bug requires them.
3. Resolve mobile native dependencies and platform settings before writing feature code.
4. Initialize once at game startup, before any module call. Pass module option objects through the `TapTapSDK.Init(coreOptions, otherOptions)` overload when a module has options.
5. Put SDK calls behind a project-owned service/facade so gameplay, UI, and save systems depend on game interfaces, not static SDK calls.
6. Handle every async SDK call with cancellation/lifecycle guards suitable for Unity objects.
7. Validate on the actual target platform. Editor-only compilation is not enough for Android/iOS native dependencies, iOS post-processing, Unity IAP, or Windows TapTap PC flows.

## Project Rules

- Do not invent TapSDK method names. Check local package source or `references/tapsdk-v4.md` before writing code.
- Do not store TapTap `clientToken`, access tokens, receipts, or compliance tokens in logs, screenshots, commits, or plain debug output.
- Set `enableLog = false` for release builds unless the project has an explicit diagnostics policy.
- Keep SDK initialization idempotent from the game side. Avoid repeated `TapTapSDK.Init` calls from scene-local MonoBehaviours.
- For TapTap PC on Windows, call `await TapTapSDK.IsLaunchedFromTapTapPC()` once at the earliest boot stage after initialization and before main UI, heavy loading, login, license, DLC, cloud save, or online-battle calls.
- Do not call `IsLaunchedFromTapTapPC()` concurrently. Source shows duplicate/running calls are guarded and may return cached state.
- For TapTap PC, register `TapTapSDK.RegisterTapTapPCStateChangeListener` after successful launch validation when license, DLC, cloud save, or online battle depends on the client staying online.
- Remove any local PC debug helper such as `taptap_client_id.txt` from release packages.
- For China compliance, register callbacks and call `TapTapCompliance.Startup(userId)` after the user identity is known. Call `Exit()` when the game session ends or the user switches accounts.
- For IAP, configure TapTap as a Unity IAP store through `TapPurchasingModule`; verify the target platform is supported, and do not bypass the project receipt-validation or order-reconciliation flow.
- For v2/v3 migration, do not delete old modules or rewrite account/save keys until identity mapping, compliance behavior, achievement state, and rollback/read compatibility are proven with real legacy accounts.
- Keep editor-only code, platform post-processors, and runtime assemblies separated through folders/asmdefs.
- Do not edit vendor package files unless the user explicitly asks to patch TapSDK itself.
- Finish Unity work with a compile/build verification appropriate to the repo, and inspect Console/build logs for native dependency failures.
