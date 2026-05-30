# Implementation Workflow

## Read

1. List files with `rg --files`.
2. Determine whether root or `src/` contains uni-app source.
3. Read `package.json`, `pages.json`, `manifest.json`, `App.*`, `main.*`, config files, and directly affected pages/components.
4. Identify target platforms from user request, scripts, comments, conditional blocks, and config nodes.

## Plan The Edit

For new or changed pages:

- Add or update `pages.json` route entries.
- Check `globalStyle`, page `style`, `tabBar`, subpackages, and `easycom`.
- Keep route paths extensionless.

For platform behavior:

- Prefer `uni.*`.
- Guard native APIs and browser globals.
- Keep platform-specific assets/config in the documented location.

For CLI/build behavior:

- Use existing scripts.
- If adding scripts, compare with current official CLI docs and existing project conventions.
- Do not modify package manager lockfiles unless dependencies actually change.

## Edit

- Make the smallest change that fits the existing project style.
- Keep Options API vs Composition API consistent unless the task is explicitly a migration.
- Keep Vue 2 vs Vue 3 startup and lifecycle patterns intact.
- Avoid unrelated refactors.

## Verify

Run the most relevant available checks:

- Unit/lint/typecheck scripts if present.
- `npm run build:h5` for broad compile feedback when H5 is relevant.
- `npm run build:<mini-program>` for affected mini-program target.
- `npm run build:app-plus` for App resource generation where appropriate.

If a dev server or mini-program developer tool is needed, say what was and was not verified.

## Mini Program Regression

- For uni-app `mp-weixin`, test the generated mini program output such as `dist/dev/mp-weixin` or `dist/build/mp-weixin`; the repo root is not the WeChat DevTools project unless it contains the active `project.config.json`.
- Treat `VITE_*` values as build-time inputs. After changing env, AppID, map keys, H5 URLs, or remote web assets, rebuild and verify the generated output before trusting simulator or real-device behavior.
- If the active manifest leaves `mp-weixin.appid` empty, inspect generated `project.config.json`. DCloud may fall back to `touristappid`, which can trigger DevTools AppID dialogs. For stable local simulator checks, add a documented post-build patch that clears generated `appid`; for preview, upload, real-device APIs, and release, require a real `wx...` AppID.
- H5 passing does not prove the mini program container passes. Recheck container-sensitive flows on `mp-weixin`: `web-view`, location permission, keyboard focus/blur, upload, navigation, tabBar, platform-specific permissions, and any page relying on generated mini-program config.
- A practical mobile sequence is: run unit tests, build H5, inspect H5 in the browser/CodexApp, build `mp-weixin`, open the generated output in WeChat DevTools, then run route/text/click assertions and visual capture.
- Before publishing a preview QR code for real-device testing, run the fastest available simulator gate for the changed surfaces. At minimum, cover launch/login, the changed page route, critical selectors, and any `web-view` URL/navigation contract.
- Real writes in regression tests must be explicit, traceable, and cleanable: use a unique run prefix, record backend IDs and roles, and provide a cleanup path.

## Web-View And Map Pages

- Add visible loading and error states around `web-view` or remote map pages; blank areas on real devices are hard to distinguish from network or permission failures.
- When leaving a page or switching tabs, invalidate pending async work. If the platform cannot physically abort a Promise/request, use an active flag or sequence number so stale results cannot update the UI.
- For `web-view` pages, clearing the bound URL on unload/hide can destroy the embedded page and stop continued loading when that behavior is desired.
- Do not rely on mini-program `postMessage` as the only immediate navigation path from an embedded H5 map. When running inside WeChat, prefer the supported mini-program bridge for direct navigation, and keep messages for logging or compatibility.
- Mobile keyboard behavior needs explicit UX handling: blur search inputs after map taps, marker taps, suggestion selection, filter changes, and primary actions when the keyboard should close.

## Report

Include:

- Files changed.
- Target platform assumptions.
- Commands run and their result.
- Any required manual HBuilderX, App device, or mini-program developer-tool follow-up.
