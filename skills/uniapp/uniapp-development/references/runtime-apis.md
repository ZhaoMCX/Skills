# Runtime APIs

## API Model

uni-app JavaScript consists of standard ECMAScript plus DCloud's `uni` object. Prefer `uni.*` APIs for cross-platform behavior.

Browser-only APIs are not portable. Mini-program and App logic layers support standard JavaScript, but not normal browser objects unless the target explicitly provides them.

## Promise Behavior

For many asynchronous `uni.*` APIs:

- If no `success`, `fail`, or `complete` callback is provided, the API may return a Promise.
- Synchronous APIs ending in `Sync` are not Promise-based.
- `create*` APIs and `*Manager` APIs are not Promise-based.
- APIs that return task objects, such as socket/upload/download style APIs, may require callback form when the task handle is needed.
- Vue 2 and Vue 3 Promise return formats differ. Vue 2 Promise-wrapped APIs commonly resolve to `[err, res]` and do not report the error through `catch`; Vue 3 APIs resolve to `res` and reject through `catch`. Confirm the project stack before refactoring callback code to `await`.

## Common Groups

Check the official API pages before changing detailed parameters:

- Navigation: `uni.navigateTo`, `uni.redirectTo`, `uni.reLaunch`, `uni.switchTab`, `uni.navigateBack`.
- Network: `uni.request`, `uni.uploadFile`, `uni.downloadFile`.
- Storage: `uni.setStorage`, `uni.getStorage`, `uni.removeStorage`, sync variants.
- UI feedback: `uni.showToast`, `uni.showLoading`, `uni.showModal`, `uni.showActionSheet`.
- System/device: `uni.getSystemInfo`, `uni.getSystemInfoSync`.
- File/media/location/payment/share APIs vary heavily by platform; verify compatibility for the target.

## Navigation Notes

- Only `tabBar` pages can be opened with `uni.switchTab`.
- Normal pages use `navigateTo` or `redirectTo`.
- Large route changes or auth resets often use `reLaunch`, but it clears the current page stack.
- Keep page paths consistent with `pages.json`.

## Error Handling

- Preserve existing callback or Promise style unless changing it deliberately.
- If converting to `async` / `await`, handle Vue 2 `[err, res]` vs Vue 3 `try/catch` return shape.
- Surface user-visible failures through project-standard UI feedback, not raw console output.
- For platform-native failures, include the platform and API name in diagnostic logs.
