# Cross Platform

## Conditional Compilation

Conditional compilation is compile-time filtering based on special comments. Use it when code, template, style, config, or assets truly differ by target.

Common pattern:

```js
// #ifdef MP-WEIXIN
// WeChat-only code
// #endif

// #ifndef H5
// Non-H5 code
// #endif
```

Use official platform ids. Verify uncommon ids in current docs or project config.

Conditional compilation can apply to:

- JavaScript / TypeScript / UTS logic.
- Template blocks.
- Style blocks.
- `pages.json`.
- Platform-specific static assets.
- Whole platform directories when the project uses that structure.

Do not replace platform-specific compile-time differences with runtime `if/else` unless both branches are valid and available on every target.

## Platform-Specific APIs

- Prefer cross-platform `uni.*` APIs.
- Use native APIs (`wx.*`, `my.*`, `plus.*`, etc.) only inside the matching platform boundary.
- If using native platform APIs, verify that platform's official documentation as well as DCloud's compatibility notes.

## Browser Globals

H5 runs in a browser. App and mini-program logic layers do not provide normal browser globals such as `window`, `document`, or `navigator`. Guard browser-only code with `#ifdef H5` or isolate it behind a platform adapter.

## Rendering And CSS

- `.vue` pages generally use webview rendering.
- `.nvue` App pages use native rendering with more CSS restrictions.
- `.uvue` is used by uni-app x and has its own constraints.
- CSS support differs between webview and native renderers; verify before using advanced layout, selectors, or DOM-dependent behavior.
- `rpx` is a cross-device responsive unit commonly used by uni-app.
- `pages.json` cannot use SCSS variables; change native navigation/tabbar dynamically through APIs where supported.

## Components

- Use uni-app built-in components or project-approved component libraries when possible.
- `easycom` handles Vue components, not platform-native mini-program components.
- Platform-native components should live in the documented platform component directories and be guarded by target.

## Multi-Target Change Checklist

Before finalizing cross-platform work:

- Confirm target platforms with the user or project scripts.
- Search changed code for unguarded `window`, `document`, `navigator`, `wx.`, `my.`, `plus.`.
- Check `pages.json` / `manifest.json` platform nodes if behavior depends on navigation, permission, App module, or mini-program config.
- Build or run at least one representative target from the affected platform family.
