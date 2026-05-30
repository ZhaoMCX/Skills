# TapSDK v4 Unity Reference

## Quick Navigation

- Package Installation
- v4 Module Map
- Platform Configuration Checklist
- Namespaces And Public Entry Points
- Initialization Patterns
- PC Flow Rules
- Feature Implementation Notes
- v3 To v4 Migration Checklist
- Verification Matrix
- Common Failure Modes

## Source Anchors

- Official Unity integration docs: `https://developer.taptap.cn/docs/sdk/integration-guides/unity/`
- Official download page: `https://developer.taptap.cn/docs/tap-download/`
- Login docs: `https://developer.taptap.cn/docs/sdk/taptap-login/guide/`
- Compliance docs: `https://developer.taptap.cn/docs/sdk/anti-addiction/guide/`
- Cloud save docs: `https://developer.taptap.cn/docs/sdk/tap-cloudsave/guide/`
- IAP docs: `https://developer.taptap.cn/docs/sdk/tap-iap/develop/unity/`
- PC quickstart: `https://developer.taptap.cn/docs/sdk/access/pc-quickstart/`
- v4 distribution repo: `https://github.com/taptap/tapsdk-unity-dist`
- v3 legacy repo: `https://github.com/taptap/tapsdk-v3-unity`

Check these again for version-sensitive work. At skill creation time, official stable docs/downloads pointed to `4.10.2`; GitHub main package manifests reported `4.10.3-beta.1`.

## Package Installation

Prefer UPM package references for new work.

GitHub URL pattern:

```json
{
  "dependencies": {
    "com.taptap.sdk.core": "https://github.com/taptap/tapsdk-unity-dist.git?path=/Core#4.10.2",
    "com.taptap.sdk.login": "https://github.com/taptap/tapsdk-unity-dist.git?path=/Login#4.10.2"
  }
}
```

NPM scoped package pattern:

```json
{
  "dependencies": {
    "com.taptap.sdk.core": "4.10.2",
    "com.taptap.sdk.login": "4.10.2"
  },
  "scopedRegistries": [
    {
      "name": "TapTap",
      "url": "https://registry.npmjs.org",
      "scopes": ["com.taptap"]
    }
  ]
}
```

Unity dependencies commonly required by the docs:

- `com.unity.nuget.newtonsoft-json`: `3.2.1`
- External Dependency Manager for Unity: `1.2.179` or the version required by the current docs/project
- `com.unity.purchasing`: source package currently declares `3.1.0` for TapTap IAP

Use local `.unitypackage` imports only when the project cannot use UPM or must mirror a vendor package artifact.

After UPM install, inspect every `Packages/packages-lock.json` TapSDK entry and `Packages/manifest.json` line. Mixed module versions are a high-risk source of native dependency and API mismatches.

## v4 Module Map

Source manifests at GitHub main currently declare Unity `2020.3.0f1` and version `4.10.3-beta.1` for these modules:

| Module | Package | Dependencies |
| --- | --- | --- |
| Core | `com.taptap.sdk.core` | none |
| Login | `com.taptap.sdk.login` | Core |
| Compliance | `com.taptap.sdk.compliance` | Core, Login |
| Achievement | `com.taptap.sdk.achievement` | Core, Login |
| CloudSave | `com.taptap.sdk.cloudsave` | Core, Login |
| Leaderboard | `com.taptap.sdk.leaderboard` | Core, Login |
| Moment | `com.taptap.sdk.moment` | Core, Login |
| Relation | `com.taptap.sdk.relation` | Core, Login |
| RelationLite | `com.taptap.sdk.relationlite` | Core, Login |
| OnlineBattle | `com.taptap.sdk.onlinebattle` | Core, Login |
| IAP | `com.taptap.sdk.iap` | Core, Unity Purchasing |
| License | `com.taptap.sdk.license` | Core |
| Rep | `com.taptap.sdk.rep` | Core |
| Review | `com.taptap.sdk.review` | Core |
| Update | `com.taptap.sdk.update` | Core |

Official downloads may list the same modules as separate `.unitypackage` artifacts. Keep all TapSDK module versions aligned.

## Platform Configuration Checklist

Android:

- Ensure External Dependency Manager for Unity is installed and dependency resolution has completed.
- Run `Assets > External Dependency Manager > Android Resolver > Force Resolve` when native classes are missing, Gradle dependencies are stale, or TapSDK modules changed.
- Inspect module `Mobile/Editor/NativeDependencies.xml` files. Source modules declare Android Maven artifacts such as `tap-core-unity`, `tap-login-unity`, `tap-compliance`, `tap-cloudsave-unity`, `tap-achievement-unity`, `tap-leaderboard-unity`, and TapTap payment artifacts.
- Inspect the merged Android manifest when login return flow, IAP, or payment provider callbacks fail.
- For TapTap IAP with WeChat Pay, verify official docs/current package requirements for `WXPayEntryActivity` or activity alias setup. Do not assume the package created the final app-level manifest entry.
- Test a real Android build, not only Editor play mode.

iOS/macOS:

- Ensure CocoaPods/EDM4U resolution runs for TapSDK pods.
- Source post-processors merge `TDS-Info.plist` from `Assets/Plugins` into the built app `Info.plist`.
- Source adds `LSApplicationQueriesSchemes`: `tapsdk`, `tapiosdk`, `taptap`.
- Source adds URL schemes from `client_id`: iOS `tt{client_id}`, macOS `open-taptap-{client_id}`.
- Login source adds `TapTapLoginResource.bundle` to the Xcode project.
- Core source adjusts Swift-related Xcode settings, disables bitcode, adds common frameworks, and injects Swift support glue for iOS builds.
- Verify the exported Xcode project after build: `Info.plist`, Podfile/pods, Swift settings, resource bundles, frameworks, and URL callback behavior.

Windows TapTap PC:

- Build target must be Windows standalone.
- `clientPublicKey` is required for startup validation.
- Test through TapTap PC, outside TapTap PC, and through any local debug helper separately.
- Do not include `taptap_client_id.txt` or equivalent local PC debug files in release packages.
- Configure launch items/package management in the TapTap PC backend as required by official docs.

## Namespaces And Public Entry Points

Core:

- Namespace: `TapSDK.Core`
- `TapTapSDK.Init(TapTapSdkOptions coreOption)`
- `TapTapSDK.Init(TapTapSdkOptions coreOption, TapTapSdkBaseOptions[] otherOptions)`
- `TapTapSDK.UpdateLanguage(TapTapLanguageType language)`
- `TapTapSDK.IsLaunchedFromTapTapPC()`
- Windows-only PC listener APIs may exist behind `UNITY_STANDALONE_WIN`.
  - `TapTapSDK.RegisterTapTapPCStateChangeListener(Action<int>)`
  - `TapTapSDK.UnRegisterTapTapPCStateChangeListener(Action<int>)`
  - `TapTapPCState.ONLINE`, `OFFLINE`, `SHUTDOWN`

Core options:

```csharp
new TapTapSdkOptions
{
    clientId = "...",
    clientToken = "...",
    clientPublicKey = "...", // TapTap PC
    region = TapTapRegionType.CN,
    preferredLanguage = TapTapLanguageType.Auto,
    gameVersion = Application.version,
    enableLog = Debug.isDebugBuild,
    screenOrientation = 1
};
```

Optional event options:

```csharp
new TapTapEventOptions
{
    enableTapTapEvent = true,
    channel = "TapTap",
    enableAutoIAPEvent = true,
    disableAutoLogDeviceLogin = false
};
```

Login:

- Namespace: `TapSDK.Login`
- `TapTapLogin.Instance.LoginWithScopes(string[] scopes)`
- `TapTapLogin.Instance.GetCurrentTapAccount()`
- `TapTapLogin.Instance.Logout()`
- Scopes include `basic_info`, `public_profile`, `email`, `user_friends` constants. Request only what the product needs.
- `TapTapAccount` exposes `accessToken`, `openId`, `unionId`, `name`, `avatar`, `email`.

Compliance:

- Namespace: `TapSDK.Compliance`
- Options: `TapTapComplianceOption(useAgeRange, showSwitchAccount)`
- `TapTapCompliance.RegisterComplianceCallback(Action<int, string>)`
- `TapTapCompliance.Startup(string userId)`
- `TapTapCompliance.Exit()`
- `TapTapCompliance.GetAgeRange()`
- `TapTapCompliance.GetRemainingTime()`
- `TapTapCompliance.GetCurrentAccessToken()`
- `TapTapCompliance.CheckPaymentLimit(long amount, ...)`
- `TapTapCompliance.SubmitPayment(long amount, ...)`

Compliance result codes observed in v4 source:

| Code | Constant | Meaning |
| --- | --- | --- |
| 500 | `LOGIN_SUCCESS` | Compliance passed; allow gameplay according to product policy. |
| 1000 | `EXITED` | User exited/logged out; end session and return to account flow. |
| 1001 | `SWITCH_ACCOUNT` | User requested account switch; clear account-bound state. |
| 1030 | `PERIOD_RESTRICT` | Curfew/period restriction; block play and show required UI. |
| 1050 | `DURATION_LIMIT` | Playtime limit; block or exit according to product policy. |
| 1100 | `AGE_LIMIT` | Age rating restriction; block access. |
| 1200 | `INVALID_CLIENT_OR_NETWORK_ERROR` | App config or network problem; fail closed for restricted gameplay. |
| 9002 | `REAL_NAME_STOP` | User closed real-name flow; block or return to account flow. |

Age range values observed in source:

| Value | Meaning |
| --- | --- |
| -1 | Unknown/unreal-name or legacy unknown. |
| 0 | Child. |
| 8 | Teen. |
| 16 | Young. |
| 18 | Adult. |

Achievements:

- Namespace: `TapSDK.Achievement`
- Options: `TapTapAchievementOptions(enableToast)`
- `TapTapAchievement.Unlock(string achievementId)`
- `TapTapAchievement.Increment(string achievementId, int step)`
- `TapTapAchievement.ShowAchievements()`
- `TapTapAchievement.SetToastEnable(bool enable)`
- Register/unregister callbacks through `ITapAchievementCallback`.

Cloud Save:

- Namespace: `TapSDK.CloudSave`
- `TapTapCloudSave.CreateArchive(metadata, archiveFilePath, archiveCoverPath)`
- `UpdateArchive`, `DeleteArchive`, `GetArchiveList`, `GetArchiveData`, `GetArchiveCover`
- Register callbacks through `ITapCloudSaveCallback`.
- Source calls `TapTapLogin.Instance.GetCurrentTapAccount()` internally for standalone/cloud operations, so handle login requirement up front.

Leaderboard:

- Namespace: `TapSDK.Leaderboard`
- `TapTapLeaderboard.OpenLeaderboard(leaderboardId, collection)`
- `TapTapLeaderboard.SubmitScores(List<SubmitScoresRequest.ScoreItem>)`
- `LoadLeaderboardScores`, `LoadCurrentPlayerLeaderboardScore`, `LoadPlayerCenteredScores`
- `ShowTapUserProfile(openId, unionId)`
- Register callbacks and share callbacks when UI flow needs them.

IAP:

- Namespace: `TapSDK.IAP`
- `TapPurchasingModule.Instance` configures a Unity IAP store named `TapTap` only when `Application.platform == RuntimePlatform.Android` in current source.
- `ITapTapStoreConfiguration` exposes `SetClientId`, `SetClientToken`, `SetRegionCode`, `SetEnableLog`, `SetIsRNDMode`.
- `ITapTapIAPBridge` exposes product query, purchase, finish transaction, and restore unfinished purchases through Unity IAP store callbacks.
- Product query success returns product details including product id, name, description, region id, formatted price, micros amount, and currency.
- Purchase success returns `productId`, `receipt`, and `transactionId`; restore returns transactions with `OrderId`, `PurchaseToken`, `OrderToken`, `PurchaseState`, and acknowledgement fields.
- Keep product definitions and receipt validation in the project's existing Unity IAP flow.

License:

- Namespace: `TapSDK.License`
- `TapTapLicense.RegisterLicenseCallBack(...)`
- `TapTapLicense.CheckLicense(bool force = false)`
- `TapTapLicense.QueryDLC(string[] dlcList)`
- `TapTapLicense.PurchaseDLC(string dlc)`
- Standalone source warns license/DLC calls must be invoked after successful `IsLaunchedFromTapTapPC`.
- On PC, source `CheckLicenseForcibly()` delegates to `CheckLicense()`, so do not rely on the `force` flag to bypass PC validation.
- `ITapLicenseCallback` exposes `OnLicenseSuccess` and `OnLicenseFailed`.
- `ITapDlcCallback` exposes DLC query and order callbacks. Query codes include OK, TapTap not installed, query error, and undefined error. Purchase codes include purchased, not purchased, return error, and undefined error.

Moment/Review/Update/Relation/Rep:

- Moment: `TapTapMoment.open()`, `OpenScene`, `Publish`, `Close`, `FetchNotification`, `SetCallback`.
- Review: `TapTapReview.OpenReview()`.
- Update: `TapTapUpdate.UpdateGame(onCancel)`, `CheckForceUpdate()`.
- Relation: `StartMessenger`, `Prepare`, `InviteGame`, `InviteTeam`, `ShowTapUserProfile`, unread/new-fans callbacks.
- Rep: `TapTapRep.Open(openUrl, callback)`.

Online Battle:

- Namespace: `TapSDK.OnlineBattle`
- Package depends on Core and Login.
- Source checks PC launch state on Windows before native calls and checks current TapTap account for most operations.
- Entry points include `Connect`, `Disconnect`, `CreateRoom`, `MatchRoom`, `GetRoomList`, `JoinRoom`, `LeaveRoom`, `UpdatePlayerCustomStatus`, `UpdatePlayerCustomProperties`, `UpdateRoomProperties`, `KickRoomPlayer`, `StartFrameSync`, `SendFrameInput`, `StopFrameSync`, `SendCustomMessage`, and `NewRandomNumberGenerator(seed)`.
- Register callbacks through `ITapOnlineBattleCallback` before room/match/frame-sync flows.
- Source disconnects when TapTap login state changes; game code must handle account switch and reconnect state.
- Custom properties and custom messages have size/rate constraints in source comments; check current docs/source before choosing payload formats.

## Initialization Patterns

Core + Login:

```csharp
using TapSDK.Core;
using TapSDK.Login;

TapTapSDK.Init(new TapTapSdkOptions
{
    clientId = clientId,
    clientToken = clientToken,
    region = TapTapRegionType.CN,
    preferredLanguage = TapTapLanguageType.Auto,
    enableLog = Debug.isDebugBuild
});

TapTapAccount account = await TapTapLogin.Instance.LoginWithScopes(new[]
{
    TapTapLogin.TAP_LOGIN_SCOPE_PUBLIC_PROFILE
});
```

Core + module options:

```csharp
TapTapSDK.Init(
    new TapTapSdkOptions
    {
        clientId = clientId,
        clientToken = clientToken,
        region = TapTapRegionType.CN,
        enableLog = Debug.isDebugBuild
    },
    new TapTapSdkBaseOptions[]
    {
        new TapTapComplianceOption(useAgeRange: true, showSwitchAccount: false),
        new TapTapAchievementOptions(enableToast: true),
        new TapTapEventOptions { channel = "TapTap" }
    });
```

Compliance session:

```csharp
TapTapCompliance.RegisterComplianceCallback((code, message) =>
{
    // Route to the game's session/access policy.
});

TapTapCompliance.Startup(account.openId);
```

Payment compliance wrapper:

```csharp
TapTapCompliance.CheckPaymentLimit(
    amount,
    result => { /* continue or block purchase */ },
    error => { /* show retry/error UI */ });

TapTapCompliance.SubmitPayment(
    amount,
    () => { /* reported */ },
    error => { /* retry or record for reconciliation */ });
```

PC startup validation:

```csharp
TapTapSDK.Init(new TapTapSdkOptions
{
    clientId = clientId,
    clientToken = clientToken,
    clientPublicKey = clientPublicKey,
    region = TapTapRegionType.CN,
    enableLog = Debug.isDebugBuild
});

#if UNITY_STANDALONE_WIN
bool launched = await TapTapSDK.IsLaunchedFromTapTapPC();
if (!launched)
{
    return;
}

TapTapSDK.RegisterTapTapPCStateChangeListener(state =>
{
    if (state == TapTapPCState.OFFLINE || state == TapTapPCState.SHUTDOWN)
    {
        // Pause protected PC-dependent flows and refresh entitlements/session state.
    }
});
#endif
```

## PC Flow Rules

Source-derived checks in `Core/Standalone` and `Login/Standalone` show:

- `IsLaunchedFromTapTapPC()` must be called after `TapTapSDK.Init`.
- `clientId` and `clientPublicKey` must both be non-empty for PC startup validation.
- Duplicate/running calls are guarded, and later calls can return cached state.
- PC login bridge errors if login is invoked before successful PC startup validation.
- License/DLC bridge errors if query/purchase/check calls run before successful PC startup validation.
- Some online-battle flows validate PC launch state too.
- Local debug uses `taptap_client_id.txt` next to the editor/application in source. Treat it as a development-only helper and exclude it from release.

Design the app boot state machine so startup validation is a single awaited step, not something every feature calls independently. Do it before main UI/heavy loading when the product depends on TapTap PC entitlements.

Strong PC dependency modules to gate behind launch validation:

- Login
- License validation and DLC
- Cloud save
- Online battle
- Any paid-content or account-bound flow that assumes TapTap PC identity

PC verification checklist:

- Launch through TapTap PC with a whitelisted/entitled account.
- Launch outside TapTap PC and confirm protected flow is blocked.
- Validate login after launch check, not before.
- Validate license success/failure and DLC query/purchase/refund callbacks.
- Simulate or test TapTap PC `OFFLINE` and `SHUTDOWN` states.
- Test cloud save list/upload/download after login and after account switch.
- Test online battle connect, room/match/join/leave, frame sync, custom messages, disconnect, reconnect, and account switch.
- Confirm release package excludes local debug files and logs no secrets.

## Feature Implementation Notes

Login:

- Keep scopes minimal. `public_profile` is common for display profile; request `email` or `user_friends` only when product features require them.
- Never log `TapTapAccount`, `AccessToken`, `macKey`, `openId`, `unionId`, or email directly.
- On logout/account switch, clear account-bound in-memory caches before loading new cloud/achievement/payment state.

Compliance:

- Register callback before calling `Startup`.
- Use a stable user identifier required by current official docs/project policy. For new v4 TapTap-login projects, `account.openId` is commonly used, but migration projects must prove identity continuity before changing keys.
- Map every `StartUpResult` code to a game access state. Do not let unknown or network/config errors fall through into unrestricted play.
- Call `Exit()` on logout, account switch, or session end.
- Wrap payment flows with `CheckPaymentLimit` before purchase and `SubmitPayment` after successful payment where required.

Achievements:

- Keep TapTap developer-center achievement IDs stable.
- Make unlock/increment idempotent in the game layer; retries and offline queues should not corrupt local state.
- Preserve pending legacy unlocks during v3 migration.
- Use callbacks when UX or retry policy depends on success/failure.

Cloud Save:

- `ArchiveMetadata` fields are `Name`, `Summary`, `Extra`, and `Playtime`.
- `ArchiveData` includes `Uuid`, `FileId`, name/summary/extra/playtime, archive/cover sizes, created time, and modified time.
- Handle `NEED_LOGIN` and `INIT_FAIL` result codes observed in source.
- Keep local save format migration separate from TapSDK upload/download. First prove account identity, then reconcile local/cloud records.
- Add conflict policy for multiple devices, account switch, retries, interrupted upload, and deleted cloud records.

IAP:

- Current source registers TapTap Unity IAP store on Android only. For iOS or other platforms, confirm official docs and project store policy before assuming TapTap IAP works the same way.
- Configure product definitions through Unity IAP and TapTap developer center.
- Set TapTap store configuration before Unity IAP initialization.
- On purchase success, validate receipt/order server-side when the project has a backend. Finish transactions only after the project considers the order granted.
- Restore unfinished purchases and reconcile unacknowledged transactions.
- For China compliance, run payment limit checks before purchase and submit payment after success.

License/DLC:

- Register license and DLC callbacks before checks/purchases.
- Treat callbacks as entitlement state changes, not just UI events.
- Test refund/entitlement loss and lock paid content accordingly.

Online Battle:

- Require init, PC launch validation on Windows, login, and callback registration before connect/room/frame-sync flows.
- Handle login changes, TapTap PC offline/shutdown, network disconnect, and reconnect explicitly.
- For deterministic gameplay, use the provided seed/random generator consistently across clients where required.

## Legacy v2/v3 Notes

Use legacy docs and repos only for existing projects:

- v3 repo: `taptap/tapsdk-v3-unity`
- v3 modules include names such as `Bootstrap`, `Common`, `Login`, `AntiAddiction`, `Achievement`, `Moment`, `Support`.
- v2/v3 APIs and package names differ from v4. Do not paste v3 snippets into a v4 project.
- For migration, inventory current modules and user data flows first, then replace one product capability at a time behind the project adapter.

## v3 To v4 Migration Checklist

1. Freeze and inventory:
   - Current v3 modules, package source, `.unitypackage` imports, asmdefs, native plugins, post-processors, Android manifests, iOS plists, and resource bundles.
   - Current game-owned identity keys, save keys, cloud save keys, achievement IDs, compliance user IDs, and account binding tables.
   - Current production/staging TapTap config and backend feature toggles.
2. Add a project adapter before replacing SDK calls:
   - Keep gameplay/UI code depending on game interfaces.
   - Preserve current behavior before swapping v3 internals for v4.
3. Prove identity mapping:
   - Compare v3 identity fields with v4 `openId`/`unionId`/account data using real legacy test accounts.
   - Do not rewrite saved data, cloud records, or account bindings until mapping is proven.
4. Migrate capability by capability:
   - Init/config first.
   - Login second.
   - Compliance third.
   - Achievements/cloud/IAP/other modules after account and compliance behavior are stable.
5. Preserve data:
   - Keep old save data readable.
   - Add a rollback/read-compatibility path.
   - Preserve queued/offline achievements and cloud-save records.
6. Verify with legacy scenarios:
   - Existing logged-in users.
   - Users with local saves only.
   - Users with unlocked achievements and pending unlock queues.
   - Users subject to compliance restrictions.
   - Account switch and logout.
7. Remove old v3 artifacts only after production-like validation:
   - Delete obsolete v3 packages/plugins/post-processors deliberately.
   - Re-run Android/iOS/Windows build verification.
   - Keep a release rollback plan until production telemetry confirms stability.

Do not assume `account.openId` is the right replacement for every v3 user identifier. Treat identity continuity as the highest migration risk.

## Verification Matrix

| Scenario | Required checks |
| --- | --- |
| Package setup | Same TapSDK version across modules; required Unity packages present; no v2/v3 modules mixed with v4. |
| Android build | EDM4U resolved; Gradle build passes; merged manifest has required callbacks; login returns to app; IAP provider callbacks work. |
| iOS build | Pods installed; `Info.plist` contains query schemes and URL scheme; resource bundles copied; Swift settings applied; login returns to app. |
| Login | Minimal scopes; success, cancel, failure, logout, account switch; no token/account logging. |
| Compliance | Every startup code mapped; curfew/duration/age-limit paths block play; payment check/submit paths tested. |
| Cloud save | Login required; create/update/list/download/delete; conflict, retry, account switch, deleted archive, and network failure. |
| Achievements | Unlock/increment/show; duplicate retry; offline queue; developer-center ID mismatch; callback failure. |
| IAP | Product query; purchase success/failure; receipt/order validation; finish transaction; restore unfinished purchases; compliance payment gates. |
| PC startup | Launch through TapTap PC; launch outside TapTap PC blocked; local debug helper excluded from release. |
| PC license/DLC | Callback registered first; license success/failure; DLC query; purchase; refund/entitlement loss. |
| Online battle | Connect/disconnect; room create/match/join/leave; frame sync; custom message; reconnect; account switch; PC offline/shutdown. |

## Common Failure Modes

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| Compile cannot find `TapSDK.Core` | Package missing or asmdef cannot reference package assembly | Check `Packages/manifest.json`, package cache, and asmdef references. |
| Native Android/iOS build dependency errors | EDM4U/native dependencies missing or unresolved | Re-run dependency resolution and inspect platform post-process logs. |
| PC login fails with order error | Login called before successful `IsLaunchedFromTapTapPC()` | Add a boot gate and await startup validation once. |
| PC startup validation fails | Missing/wrong `clientPublicKey` or mismatched `clientId` | Check TapTap developer center values and build config. |
| Compliance never gates gameplay | `Startup(userId)` not called after login/account selection | Tie compliance lifecycle to account session start. |
| Payments rejected or legally risky | Compliance payment limit not checked/submitted | Wrap payment flow with compliance APIs where required. |
| Cloud save returns auth/network errors | User is not logged in or account changed | Ensure current Tap account exists and retry through account/session service. |
| Package versions conflict | Modules use different TapSDK versions | Align every `com.taptap.sdk.*` version/tag. |
| Release logs leak data | `enableLog` left true or app logs token/account objects | Disable SDK logs and redact project logs. |
| iOS login cannot return to app | URL scheme or `TDS-Info.plist` merge failed | Inspect exported `Info.plist` for `tt{client_id}` and query schemes. |
| Android native class missing | EDM4U did not resolve TapSDK Maven artifacts | Force Resolve and inspect `NativeDependencies.xml`/Gradle dependencies. |
| TapTap PC protected flow works outside client | Startup validation result ignored | Fail closed when `IsLaunchedFromTapTapPC()` is false. |
| DLC entitlement stale after refund | Callback not registered or entitlement not re-queried | Register callbacks before query/purchase and update game entitlement state. |
| v3 migration loses saves | New identity key used before mapping was proven | Add compatibility mapping and rollback/read path. |
