---
name: uniapp-development
description: Use when working on uni-app, uni-app x, DCloud, HBuilderX, uniCloud-adjacent frontend projects, mini-program targets, or CLI builds using pages.json, manifest.json, App.vue, main.js, uni.scss, conditional compilation, uni APIs, or @dcloudio tooling.
---

# UniApp Development

This skill keeps uni-app work grounded in official DCloud documentation and in the current project's actual structure. Community skills may inspire comparisons, but do not use them as authority.

## First Pass

Before changing code:

1. Identify the project type:
   - uni-app vs uni-app x.
   - HBuilderX visual project vs CLI project.
   - Vue 2 / Vue 3, Vite / Vue CLI, JavaScript / TypeScript / UTS.
   - Target platform: H5, App, `mp-weixin`, another mini program, quick app, or multi-target.
2. Inspect the repo using `rg --files` and read the relevant files:
   - `package.json`, `src/package.json` if present.
   - `pages.json`, `manifest.json`, `App.vue` or `App.uvue`, `main.js` / `main.ts` / `main.uts`.
   - `vite.config.*`, `vue.config.js`, `uni.scss`, `pages/`, `components/`, `uni_modules/`, `static/`.
3. If an API, CLI command, lifecycle hook, platform identifier, or config field might have changed, verify it in the official docs before relying on memory.

## Reference Map

Load only the reference needed for the current task:

- `references/official-sources.md`: official doc links and source priority.
- `references/cli-and-build.md`: CLI creation, script naming, targets, Vite/Vue CLI, output folders, HBuilderX differences.
- `references/project-structure.md`: file roles, HBuilderX vs CLI layout, pages, lifecycle, `easycom`, static resources.
- `references/cross-platform.md`: conditional compilation, platform-specific code, CSS/rendering constraints.
- `references/runtime-apis.md`: `uni.*` APIs, Promise behavior, navigation, storage, network, UI feedback.
- `references/implementation-workflow.md`: editing and verification workflow for existing projects.

## Working Rules

- Prefer existing project conventions over generic examples.
- Register new pages in `pages.json`; unregistered pages are ignored by compilation.
- Keep page paths extensionless in `pages.json`.
- Use `uni.*` APIs for cross-platform behavior; do not use browser globals outside H5-only guarded code.
- Treat conditional compilation as a compile-time boundary, not a runtime feature flag.
- Preserve platform-specific config under the correct `manifest.json`, `pages.json`, `static/<platform>/`, or conditional block.
- For CLI projects, use actual `package.json` scripts first. Do not invent `npm run dev:*` / `build:*` commands unless the scripts or official docs support them.
- For App debugging, remember CLI can build App resources, but interactive App run/debug and uniCloud tooling may still require HBuilderX.

## Mini Program Regression and Release Notes

- For uni-app `mp-weixin`, test the generated mini program output such as `dist/dev/mp-weixin` or `dist/build/mp-weixin`; the repo root is not the WeChat DevTools project unless it contains the active `project.config.json`.
- Treat `VITE_*` values as build-time inputs. After changing env, AppID, map keys, H5 URLs, or remote web assets, rebuild and verify the generated output before trusting simulator or real-device behavior.
- H5 passing does not prove the mini program container passes. Recheck container-sensitive flows on `mp-weixin`: `web-view`, location permission, keyboard focus/blur, upload, navigation, tabBar, and platform-specific permissions.
- Before publishing a preview QR code for real-device testing, run the fastest available simulator gate for the changed surfaces. At minimum, cover launch/login, the changed page route, critical selectors, and any `web-view` URL/navigation contract.
- Real writes in regression tests must be explicit, traceable, and cleanable: use a unique run prefix, record backend IDs and roles, and provide a cleanup path.

## Web-View and Map Pages

- Add visible loading and error states around `web-view` or remote map pages; blank areas on real devices are hard to distinguish from network or permission failures.
- When leaving a page or switching tabs, invalidate pending async work. If the platform cannot physically abort a Promise/request, use an active flag or sequence number so stale results cannot update the UI.
- For `web-view` pages, clearing the bound URL on unload/hide can destroy the embedded page and stop continued loading when that behavior is desired.
- Do not rely on mini-program `postMessage` as the only immediate navigation path from an embedded H5 map. When running inside WeChat, prefer the supported mini-program bridge for direct navigation, and keep messages for logging or compatibility.
- Mobile keyboard behavior needs explicit UX handling: blur search inputs after map taps, marker taps, suggestion selection, filter changes, and primary actions when the keyboard should close.

## Verification

Choose verification from the project and target:

- Static checks: lint/typecheck scripts if present.
- H5: `npm run dev:h5` for manual browser verification or `npm run build:h5` for build verification.
- Mini program: `npm run dev:<platform>` or `npm run build:<platform>`, then inspect the generated target folder with the corresponding developer tool.
- App: `npm run build:app-plus` can generate resources for CI; run/debug usually needs HBuilderX.
- If no script exists, report that clearly and cite the closest available command or manual HBuilderX step.

When reporting results, mention the target platform(s), commands run, and any parts that still need device or mini-program-tool validation.
