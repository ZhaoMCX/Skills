# CLI And Build

## Project Recognition

CLI uni-app projects usually look like Node projects:

- App source under `src/`.
- `src/pages.json`, `src/manifest.json`, `src/App.vue`, `src/main.*`.
- Compiler dependencies in project `package.json`.
- Build output in `dist/`.

HBuilderX visual projects usually keep source at the project root:

- Root `pages.json`, `manifest.json`, `App.vue`, `main.*`.
- Compiler comes from HBuilderX.
- Build/run artifacts often live under `unpackage/`.

Do not assume one layout from the other. Check files first.

## Creation Commands

Official CLI creation differs by stack:

- Vue 3 / Vite JavaScript: `npx degit dcloudio/uni-preset-vue#vite my-vue3-project`
- Vue 3 / Vite TypeScript: `npx degit dcloudio/uni-preset-vue#vite-ts my-vue3-project`
- Vue 2 / Vue CLI: install `@vue/cli`, then use the DCloud preset.

Vue 3 / Vite projects require a modern Node version per the current official CLI docs. Re-check the CLI page before giving setup advice.

## Scripts And Targets

Official script shape:

```bash
npm run dev:%PLATFORM%
npm run build:%PLATFORM%
```

Common platform ids include:

- `h5`
- `app-plus`
- `mp-weixin`, `mp-alipay`, `mp-baidu`, `mp-toutiao`, `mp-lark`, `mp-qq`
- `mp-360`, `mp-kuaishou`, `mp-jd`, `mp-xhs`, `mp-harmony`
- `quickapp-webview`, `quickapp-webview-union`, `quickapp-webview-huawei`

Use the project's real `scripts` object as the command authority. Some projects rename commands or only include selected targets.

## Outputs

- CLI dev output for mini-program targets is under `dist/dev/<platform>`.
- CLI build output is under `dist/build/<platform>`.
- H5 dev may be served from memory/cache instead of a `dist/dev/h5` folder.
- App resources can be generated with `build:app-plus`; interactive App run/debug is normally HBuilderX territory.

## Dependency Updates

DCloud documents `@dcloudio/uvm` for managing compiler dependency versions. It updates major compiler dependencies, but newly added scripts may need manual comparison with a fresh project.

## Vite

For Vue 3 / Vite projects:

- `vite.config.js` is supported in CLI projects and HBuilderX 3.2.0+.
- It must include `@dcloudio/vite-plugin-uni` in `plugins`.
- Some Vite options are unsupported or overridden by uni-app compilation, including `root`, `mode`, `publicDir`, and several `build.*` fields. Check the official `vite.config.js` page before changing build config.

## Custom Platforms

`package.json` can contain a `uni-app` extension node for custom compile platforms. Use it only for web or mini-program extensions, not App packaging.
