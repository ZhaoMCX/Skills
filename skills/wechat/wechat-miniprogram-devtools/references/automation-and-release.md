# Automation And Release

## Stable Pipeline Pattern

- Split slow GUI startup from fast gates. Use a DevTools warm/open step once, then run healthcheck, smoke, map/web-view checks, and visual capture against the already-open project when possible.
- Do not put DevTools cold start, login prompts, preview upload, or full visual capture inside a tight unit-test timeout. Give GUI steps their own timeout and clear failure category.
- On Windows, DevTools simulator automation is not reliable when the IDE is only a background/minimized process. Before route assertions, web-view checks, or OS screenshots, restore the main DevTools window, move/size it predictably, bring it to the foreground, and wait briefly for repaint.
- When starting from an unknown DevTools state, run the official CLI `quit` first, then clean leftover DevTools install-directory processes only as a fallback. A stale visible main window can cause automator to connect to a wrong or half-stale session.
- Open the generated mini program project window before enabling `auto`; for uni-app this means the compiled `mp-weixin` output. Then connect automator to the intended port.
- Prefer a fixed automation port for repeatable runs. Some DevTools versions support `auto --auto-port <port>` even when `auto --help` does not list it; connect automator to `ws://127.0.0.1:<auto-port>`. Do not assume the `ws connect <port>` printed by `--debug` is the automator endpoint.
- Avoid repeatedly killing or closing DevTools during a regression run. After automator checks, prefer `miniProgram.disconnect()` and leave the warmed DevTools session available for the next check.
- Do not default to `miniProgram.close()` or CLI `close` at the end of automation; DevTools can show close-confirm dialogs or hang on shutdown. Close only when the user asks, or when cache clearing requires it.
- When a test appears to wait forever, first add bounded waits around the operation that can hang: DevTools connection, route load, selector wait, `web-view` readiness, screenshot, preview generation, and close/quit.
- Report timeouts by stage. A DevTools startup timeout, app route timeout, screenshot timeout, and backend/API timeout imply different fixes.
- Treat cleanup steps after the main assertion as best-effort unless cleanup is the feature being tested. For example, a timeout returning from a notice page should not invalidate evidence that the workbench rendered and navigation opened the notice list.

## Uni-App Build And Cache Pitfalls

- Confirm which `manifest.json` the build actually uses. Some uni-app projects keep both root `manifest.json` and `src/manifest.json`; the generated `project.config.json` can fall back to `touristappid` if the active source manifest has an empty `mp-weixin.appid`.
- For local simulator checks, an empty generated appid is often better than `touristappid` because it avoids DevTools AppID-change dialogs. For preview, upload, real-device APIs, and release, require a real confirmed `wx...` appid.
- Treat `VITE_*` mini-program values as build-time inputs. If a test helper injects values such as TianDiTu URL/TK, rerun that prepare/build step after any normal `build:mp-weixin` or `verify` command that regenerates `dist/build/mp-weixin`.
- If generated files contain the expected env/config but the simulator still shows old UI, suspect DevTools compile cache before changing app code. Clear only compile cache first:

```powershell
& "<path-to-cli.bat>" quit
& "<path-to-cli.bat>" cache --clean compile --project "<path-to-dist/build/mp-weixin>"
```

Avoid `cache --clean all`, `auth`, or `storage` unless the user explicitly accepts losing local DevTools state.

## Web-View And Real-Device Pitfalls

- A remote H5 page inside `web-view` is a separate deployment surface. Changing the mini program bundle does not update remote map/search code unless that H5 asset is also deployed and fetched from the public URL used by the mini program.
- Before issuing a real-device preview QR after web-view changes, verify both the generated `web-view src` and the remote H5 content/version that the real device will load.
- `postMessage` from H5 to mini program is not a reliable sole mechanism for immediate real-device navigation. For embedded H5 actions such as "view task" or "start handling", prefer the official `wx.miniProgram.navigateTo` bridge when available, and keep messages for compatibility/logging evidence.
- Location and keyboard behavior can differ between simulator and phone. Include explicit checks for permission failure feedback, input focus, suggestion selection, and blur-on-map-tap behavior when those flows changed.
- Avoid competing location sources between the embedded H5 page and the mini program parent. If the parent owns native location polling, H5 should request intent and consume parent `showCurrentLocation` updates instead of calling its own native/browser location source.
- Do not use URL/current-location cache as the final answer for "my location" taps if the parent can provide a fresh native location. A cached point can show an initial blue dot, but the tap should either request a fresh host update or clearly report low confidence.
- Search boxes in map web-views should not hide map markers or jump the viewport while typing unless that is explicitly the product behavior. Prefer suggestions that filter independently; only selecting a suggestion should pan/open a marker.

## Automator Pattern

Use `miniprogram-automator` from the project when available. If it is missing and automation is needed, ask before adding it as a dev dependency unless the task already permits dependency installation.

```javascript
const automator = require('miniprogram-automator');

const miniProgram = await automator.connect({
  wsEndpoint: 'ws://127.0.0.1:<port>'
});

const page = await miniProgram.reLaunch('/pages/index/index');
await page.waitFor(500);
await miniProgram.screenshot({ path: 'tmp/wechat-index.png' });
await miniProgram.disconnect();
```

Adapt selectors and routes to the real project. Prefer waiting for a selector or route state over sleeping; use fixed waits only as a small fallback after navigation or animation.

For text assertions in `miniprogram-automator@0.12.x`, do not use Playwright-style `page.$eval` or `page.screenshot`. Use `current.$$('text')`, `element.text()`, `button.text()`, and `miniProgram.screenshot()` instead.

## Screenshot Reliability

`miniProgram.screenshot()` calls DevTools protocol `App.captureScreenshot`. On some Windows DevTools sessions it can hang even when selectors, text, size, route, API calls, and `web-view` attributes all work. Do not treat screenshot timeout alone as proof that the page failed to render. If repeated attempts have already confirmed persistent timeout and the root cause is not discoverable from logs or DevTools state, use OS/window capture as the default screenshot path for that environment instead of retrying protocol screenshots.

When this happens:

1. Keep functional checks in `miniprogram-automator`: route, required selector, element size, text, form input, API result, `web-view src`.
2. Wrap screenshot calls with a timeout and report them separately from functional failures.
3. For visual QA, use OS/window capture. On Windows, restore, move, foreground, and optionally topmost the WeChat DevTools window before capture. `CopyFromScreen` against the visible DevTools window is often more reliable for Electron-rendered DevTools; `PrintWindow` may return success but produce a blank white image, so treat it only as an optional attempt.
4. If the DevTools window is offscreen or blank, move/restore it before OS capture and wait for repaint.

If the repo already provides a helper such as `scripts/capture-wechat-simulator.ps1` or `scripts/wechat-visual-os.mjs`, prefer that over rewriting capture code.

## Commands And Logs

Do not rely on memory for exact DevTools CLI flags. Run the local CLI help and then use the installed version's syntax.

```powershell
& "<path-to-cli.bat>" --help
& "<path-to-cli.bat>" version
```

Common operation names to look for in help output: `open`, `preview`, `upload`, `build-npm`, automation/auto test startup, and project path arguments.

- `miniprogram-automator` can subscribe to AppService logs with `miniProgram.on("console", ...)` and runtime errors with `miniProgram.on("exception", ...)`. Save these into the test report when possible.
- DevTools CLI stdout/stderr is useful for project-level state: startup port, selected AppID, cache cleanup, preview/upload errors, and login/permission blockers.
- `web-view` content, including H5 TianDiTu pages, may not forward browser console/network logs to the mini-program AppService stream. For those logs, use an explicit H5-to-mini-program bridge, local H5 browser testing, DevTools local log files, or a dedicated DevTools/MCP integration if the user asks for deeper inspection.
- A clean report should distinguish: functional assertion failures, screenshot/capture failures, AppService console messages, AppService exceptions, DevTools CLI output, and web-view/H5 diagnostics.
- For regression runs with real backend writes, record run ID, record prefix, role, endpoint, returned or looked-up backend IDs, created time, and cleanup status. Do not mix writable data setup failures with read-only UI assertion failures.
- For role-based simulator regressions, reuse prepared fixture accounts and cached role tokens when the project provides them. Captcha recognition and account bootstrap failures should be reported as setup/token failures, not page-rendering failures.

## Preview QR Checklist

Before handing a QR to a tester:

1. Confirm the generated mini program output is current for the intended source changes.
2. Run the required simulator regression, not only a quick smoke gate, when the change affects navigation, role visibility, forms, maps, web-view, or writes.
3. If the change affects remote H5 inside `web-view`, verify the public remote asset/version separately.
4. Generate the preview using image QR output when supported.
5. Open/decode the generated QR image and report dimensions, byte size, and path. A terminal text QR saved as `.png`/`.jpg` is a broken artifact.
6. Tell the user when the QR is a preview artifact with limited validity; regenerate after expiry.

## Common Mistakes

- Opening a uni-app repo root in DevTools when the generated `mp-weixin` output is the actual mini program project.
- Assuming the CLI is globally available as `cli`; locate the installed `cli.bat` or equivalent first.
- Using automator before DevTools has opened the project and enabled automation.
- Trusting stale DevTools simulator output after env/AppID changes; clear `compile` cache and reopen the generated output first.
- Connecting automator to the internal `ws connect` port from `--debug` instead of the fixed `--auto-port`.
- Using Playwright-style APIs such as `page.$eval` or `page.screenshot` with `miniprogram-automator`.
- Failing a test solely because `miniProgram.screenshot()` timed out while route, selector, size, and API assertions passed.
- Assuming `web-view` H5 logs are available through mini-program `console` events.
- Publishing a QR code before rerunning simulator smoke for the changed flows.
- Treating a quick prepreview gate as proof that every role page, subpage, web-view action, and write path works.
- Handing over a QR file without validating that it is a real readable image.
- Forgetting that remote H5 assets, backend permissions, and the mini program bundle may each need separate deployment or verification.
- Treating preview/upload as harmless. Preview may require login; upload affects the mini program management workflow.
- Hiding DevTools login, appid, or permission blockers. Report them and ask the user to complete the interactive step.
