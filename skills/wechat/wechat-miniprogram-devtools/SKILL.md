---
name: wechat-miniprogram-devtools
description: Use when working with WeChat Mini Program projects through official WeChat DevTools, DevTools CLI, miniprogram-automator, uni-app mp-weixin output, preview/upload, simulator automation, screenshots, page inspection, clicks, input, or end-to-end checks.
---

# WeChat Mini Program DevTools

## Overview

Use the official WeChat DevTools CLI for project-level operations and `miniprogram-automator` for simulator interaction. Prefer official DevTools capabilities; do not install or rely on third-party MCP wrappers unless the user explicitly asks.

## Decision Guide

| User asks for | Use |
| --- | --- |
| open, preview, upload, build npm, inspect project settings | DevTools CLI |
| click, type, navigate pages, read page data, screenshot, assert UI | `miniprogram-automator` after DevTools is open with automation enabled |
| uni-app / HBuilderX / `mp-weixin` project | build or locate the `dist/dev/mp-weixin` or `dist/build/mp-weixin` output first, then point DevTools at that output |
| CI-style checks | use CLI for setup and automator for deterministic assertions; report when login, appid, or GUI state blocks automation |
| visual evidence after `miniProgram.screenshot()` is confirmed to hang | use OS/window capture as the default visual capture path, while keeping functional assertions in `miniprogram-automator` |
| stale simulator output after config/env changes | quit DevTools, clear only `compile` cache, then reopen the generated mini program output |
| app/web-view logs | capture automator `console`/`exception` for AppService logs; use CLI/stdout/local DevTools logs or an explicit web-view bridge for deeper logs |
| real-device preview QR | build, warm DevTools, run simulator smoke for changed flows, then create preview; never assume a new QR includes changes without verifying the generated output |

## Standard Workflow

1. Inspect the repo before running DevTools commands. Check `package.json`, `manifest.json`, `project.config.json`, `project.private.config.json`, and existing scripts.
2. If the workspace is uni-app, run or identify the existing `mp-weixin` build script. Typical outputs are `dist/dev/mp-weixin` for development and `dist/build/mp-weixin` for production.
3. Locate the DevTools CLI executable instead of assuming it is on `PATH`. Common Windows candidates include:
   - `C:\Program Files (x86)\Tencent\WeChat Web DevTools\cli.bat`
   - `C:\Program Files\Tencent\WeChat Web DevTools\cli.bat`
   - installation directories whose folder name is the localized WeChat Web DevTools name
   - user-installed WeChat DevTools locations under `%LOCALAPPDATA%` or shortcuts
4. Run the CLI help/version command first when the exact flags are uncertain. DevTools command names and flags can vary across versions.
5. Open/import the mini program project with the CLI. For uni-app, the project path is the compiled `mp-weixin` output, not the repo root unless `project.config.json` is there.
6. For interaction or screenshots, ensure DevTools automation is enabled, then connect with `miniprogram-automator`.
7. Verify results with concrete evidence: command output, screenshot path, page route, selector result, or assertion result.

## Stable Pipeline Pattern

- Split slow GUI startup from fast gates. Use a DevTools warm/open step once, then run healthcheck, smoke, map/web-view checks, and visual capture against the already-open project when possible.
- Do not put DevTools cold start, login prompts, preview upload, or full visual capture inside a tight unit-test timeout. Give GUI steps their own timeout and clear failure category.
- Avoid repeatedly killing or closing DevTools during a regression run. After automator checks, prefer `miniProgram.disconnect()` and leave the warmed DevTools session available for the next check.
- Do not default to `miniProgram.close()` or CLI `close` at the end of automation; DevTools can show close-confirm dialogs or hang on shutdown. Close only when the user asks, or when cache clearing requires it.
- When a test appears to "wait forever", first add bounded waits around the operation that can hang: DevTools connection, route load, selector wait, `web-view` readiness, screenshot, preview generation, and close/quit.
- Report timeouts by stage. A DevTools startup timeout, app route timeout, screenshot timeout, and backend/API timeout imply different fixes.

## Uni-App Build and Cache Pitfalls

- Confirm which `manifest.json` the build actually uses. Some uni-app projects keep both root `manifest.json` and `src/manifest.json`; the generated `project.config.json` can fall back to `touristappid` if the active source manifest has an empty `mp-weixin.appid`.
- Treat `VITE_*` mini-program values as build-time inputs. If a test helper injects values such as TianDiTu URL/TK, rerun that prepare/build step after any normal `build:mp-weixin` or `verify` command that regenerates `dist/build/mp-weixin`.
- If generated files contain the expected env/config but the simulator still shows old UI, suspect DevTools compile cache before changing app code. Clear only compile cache first:

```powershell
& "<path-to-cli.bat>" quit
& "<path-to-cli.bat>" cache --clean compile --project "<path-to-dist/build/mp-weixin>"
```

Avoid `cache --clean all`, `auth`, or `storage` unless the user explicitly accepts losing local DevTools state.

## Web-View and Real-Device Pitfalls

- A remote H5 page inside `web-view` is a separate deployment surface. Changing the mini program bundle does not update remote map/search code unless that H5 asset is also deployed and fetched from the public URL used by the mini program.
- Before issuing a real-device preview QR after web-view changes, verify both the generated `web-view src` and the remote H5 content/version that the real device will load.
- `postMessage` from H5 to mini program is not a reliable sole mechanism for immediate real-device navigation. For embedded H5 actions such as "view task" or "start handling", prefer the official `wx.miniProgram.navigateTo` bridge when available, and keep messages as compatibility/logging evidence.
- Location and keyboard behavior can differ between simulator and phone. Include explicit checks for `wx.getLocation`, permission failure feedback, input focus, suggestion selection, and blur-on-map-tap behavior when those flows changed.

## DevTools CLI Notes

- Use quoted paths on Windows; both the CLI path and project path may contain spaces or localized characters.
- Prefer read-only or local simulator actions unless the user requests upload or publishing operations.
- Treat upload as a user-visible release action. Confirm appid, version, description, and target project before uploading.
- If DevTools reports login, appid, network, or permission errors, state the blocker plainly and avoid inventing workarounds.
- For build/npm operations inside the mini program output, use DevTools CLI when the project requires WeChat's npm build behavior.

## Automator Pattern

Use `miniprogram-automator` from the project when available. If it is missing and automation is needed, ask before adding it as a dev dependency unless the task already permits dependency installation.

```javascript
const automator = require('miniprogram-automator');

const miniProgram = await automator.connect({
  wsEndpoint: 'ws://127.0.0.1:<port>'
});

const page = await miniProgram.reLaunch('/pages/index/index');
await page.waitFor(500);
await page.screenshot({ path: 'tmp/wechat-index.png' });
await miniProgram.disconnect();
```

Adapt selectors and routes to the real project. Prefer waiting for a selector or route state over sleeping; use fixed waits only as a small fallback after navigation or animation.

### Screenshot Reliability

`miniProgram.screenshot()` calls DevTools protocol `App.captureScreenshot`. On some Windows DevTools sessions it can hang even when selectors, text, size, route, API calls, and `web-view` attributes all work. Do not treat screenshot timeout alone as proof that the page failed to render. If repeated attempts have already confirmed persistent timeout and the root cause is not discoverable from logs or DevTools state, use OS/window capture as the default screenshot path for that environment instead of retrying protocol screenshots.

When this happens:

1. Keep functional checks in `miniprogram-automator`: route, required selector, element size, text, form input, API result, `web-view src`.
2. Wrap screenshot calls with a timeout and report them separately from functional failures.
3. For visual QA, use OS/window capture. On Windows, `PrintWindow` can capture the WeChat DevTools main window and avoid `App.captureScreenshot`; crop the simulator area for review. `CopyFromScreen` is less reliable because foreground windows can cover DevTools.
4. If the DevTools window is offscreen or blank, move/restore it before OS capture and wait for repaint.

If the repo already provides a helper such as `scripts/capture-wechat-simulator.ps1` or `scripts/wechat-visual-os.mjs`, prefer that over rewriting capture code.

## Project Checks

Before automating, confirm:

- The target directory contains `project.config.json`.
- `appid` is suitable for the requested action. For local simulator checks, test appids may be acceptable; for upload, confirm the real appid.
- The compiled output is current after source changes.
- DevTools is installed, logged in when required, and its automation service is enabled.
- The page route exists in `app.json` or generated pages config.

## Common Commands To Discover

Do not rely on memory for exact DevTools CLI flags. Run the local CLI help and then use the installed version's syntax.

```powershell
& "<path-to-cli.bat>" --help
& "<path-to-cli.bat>" version
```

Common operation names to look for in help output: `open`, `preview`, `upload`, `build-npm`, automation/auto test startup, and project path arguments.

## Logging Boundaries

- `miniprogram-automator` can subscribe to AppService logs with `miniProgram.on("console", ...)` and runtime errors with `miniProgram.on("exception", ...)`. Save these into the test report when possible.
- DevTools CLI stdout/stderr is useful for project-level state: startup port, selected AppID, cache cleanup, preview/upload errors, and login/permission blockers.
- `web-view` content, including H5 TianDiTu pages, may not forward browser console/network logs to the mini-program AppService stream. For those logs, use an explicit H5-to-mini-program bridge, local H5 browser testing, DevTools local log files, or a dedicated DevTools/MCP integration if the user asks for deeper inspection.
- A clean report should distinguish: functional assertion failures, screenshot/capture failures, AppService console messages, AppService exceptions, DevTools CLI output, and web-view/H5 diagnostics.
- For regression runs with real backend writes, record run ID, record prefix, role, endpoint, returned or looked-up backend IDs, created time, and cleanup status. Do not mix writable data setup failures with read-only UI assertion failures.

## Common Mistakes

- Opening a uni-app repo root in DevTools when the generated `mp-weixin` output is the actual mini program project.
- Assuming the CLI is globally available as `cli`; locate the installed `cli.bat` or equivalent first.
- Using automator before DevTools has opened the project and enabled automation.
- Trusting stale DevTools simulator output after env/AppID changes; clear `compile` cache and reopen the generated output first.
- Failing a test solely because `miniProgram.screenshot()` timed out while route, selector, size, and API assertions passed.
- Assuming `web-view` H5 logs are available through mini-program `console` events.
- Publishing a QR code before rerunning simulator smoke for the changed flows.
- Forgetting that remote H5 assets, backend permissions, and the mini program bundle may each need separate deployment or verification.
- Treating preview/upload as harmless. Preview may require login; upload affects the mini program management workflow.
- Hiding DevTools login, appid, or permission blockers. Report them and ask the user to complete the interactive step.

## Safety

Keep automation scoped to local development unless the user explicitly asks for preview/upload/release work. Never store credentials, tokens, QR codes, or uploaded package metadata in repo files unless the project already has a clear convention for that artifact.
