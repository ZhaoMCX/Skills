# Project Structure

## Core Files

- `App.vue` / `App.uvue`: global app component, global styles, app lifecycle hooks.
- `main.js` / `main.ts` / `main.uts`: Vue app entry. Vue 2 and Vue 3 startup code differ.
- `pages.json`: page routes, window styles, native navigation, `tabBar`, subpackages, `easycom`.
- `manifest.json`: app name, app id, icon, version, permissions, platform-specific config.
- `uni.scss`: common SCSS variables automatically available to style blocks.
- `pages/`: page files.
- `components/`: Vue component directory.
- `uni_modules/`: uni_modules plugins and components.
- `static/`: local static assets that should be copied into build output.

In CLI projects these files commonly live under `src/`; in HBuilderX visual projects they commonly live at root.

## Pages

- A uni-app page is a Vue SFC (`.vue` / `.nvue`) or, in uni-app x, a `.uvue` file.
- New pages must be registered in `pages.json -> pages`.
- Page paths in `pages.json` omit file extensions.
- Deleting or renaming a page requires updating both the file and `pages.json`.
- `tabBar` pages stay alive after first display; switching back usually triggers `onShow`, not `onLoad`.

## Lifecycle

App lifecycle belongs in `App.vue` / `App.uvue`:

- `onLaunch`
- `onShow`
- `onHide`
- other app-level hooks if supported by the target.

Page lifecycle can include:

- `onLoad`, `onShow`, `onReady`, `onHide`, `onUnload`
- `onPullDownRefresh`, `onReachBottom`, `onPageScroll`, share/navigation hooks where supported.

Composition API usage differs between Vue 2 and Vue 3; check the project stack before moving lifecycle code.

## Components And easycom

`easycom` lets pages use qualifying Vue components without explicit import/registration.

Default qualifying paths include:

- `components/<component-name>/<component-name>.vue`
- `uni_modules/<plugin-id>/components/<component-name>/<component-name>.vue`

If a component is outside the convention, either import it manually or configure `pages.json -> easycom`.

## Static Assets

- Put runtime-referenced local images, fonts, videos, and files under `static/`.
- Assets referenced through variables may not be statically analyzable unless placed in `static/`.
- Avoid putting unused large files in `static/`; the directory can be copied into output.
- `static` supports platform subdirectories such as `static/mp-weixin` and `static/app`.
- CSS, SCSS, JS, and Vue components should usually live outside `static/` and be imported normally.
