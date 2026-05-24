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

## Verification

Choose verification from the project and target:

- Static checks: lint/typecheck scripts if present.
- H5: `npm run dev:h5` for manual browser verification or `npm run build:h5` for build verification.
- Mini program: `npm run dev:<platform>` or `npm run build:<platform>`, then inspect the generated target folder with the corresponding developer tool.
- App: `npm run build:app-plus` can generate resources for CI; run/debug usually needs HBuilderX.
- If no script exists, report that clearly and cite the closest available command or manual HBuilderX step.

When reporting results, mention the target platform(s), commands run, and any parts that still need device or mini-program-tool validation.
