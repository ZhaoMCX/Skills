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

## Mini Program And Web-View Notes

- For `mp-weixin`, verify the generated mini program output, not the repo root, unless the root contains the active `project.config.json`.
- Rebuild after env/AppID/map key/H5 URL changes because `VITE_*` and related settings are build-time inputs.
- Treat `web-view`, remote map pages, location permission, keyboard behavior, upload, navigation, and tabBar flows as container-sensitive. See `references/implementation-workflow.md` for release and regression details.
- Separate release surfaces before testing or publishing:
  - Native/UniApp bundle changes require rebuilding the target output and retesting the mini program/app container.
  - Remote `web-view` assets require deploying the remote static page and verifying the public content hash/version; rebuilding the mini program does not update remote H5.
  - Backend permission or data changes may not require a frontend rebuild, but they do require role-token API checks and page evidence.
- For embedded maps or other `web-view` tools, keep the parent page responsible for live native capabilities such as location, permissions, task data refresh, and navigation intent coordination. Avoid competing location sources between H5 and the UniApp parent.
- Use explicit loading and empty states when data is prepared asynchronously for `web-view`; a page that is blank for the first refresh interval often means the parent mounted the `web-view` before required URL/data state was ready.

## Role And Data Regression

- For role-based apps, test by role, not only by page. Record which role token/account was used, which statuses or records are expected, and whether the backend API itself filters data correctly.
- Do not treat frontend filtering as authorization. If a page hides forbidden data but the role token can fetch it directly, report a backend filtering/authorization issue.
- When real writes are needed, make them explicit and traceable: unique run ID, stable prefix, role, endpoint, returned ID or lookup ID, key fields, created time, and cleanup status.
- Cache or reuse prepared fixture accounts/tokens for simulator regressions when appropriate. Do not let flaky captcha recognition or account creation become a false page-rendering failure.

## Verification

Choose verification from the project and target:

- Static checks: lint/typecheck scripts if present.
- H5: `npm run dev:h5` for manual browser verification or `npm run build:h5` for build verification.
- Mini program: `npm run dev:<platform>` or `npm run build:<platform>`, then inspect the generated target folder with the corresponding developer tool.
- App: `npm run build:app-plus` can generate resources for CI; run/debug usually needs HBuilderX.
- If no script exists, report that clearly and cite the closest available command or manual HBuilderX step.
- Before producing a real-device preview or release artifact, run the project’s full simulator/container regression for the changed surface, not only a quick smoke gate. Quick gates are useful for feedback, but they do not prove all role flows, subpages, `web-view` bridges, and write paths work.

When reporting results, mention the target platform(s), commands run, and any parts that still need device or mini-program-tool validation.
