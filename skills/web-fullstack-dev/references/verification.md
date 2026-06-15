# Verification

## Root Commands

```powershell
pnpm install
pnpm run test:web
pnpm run test:miniprogram
pnpm run build:web
pnpm run build:miniprogram
pnpm run build:admin
pnpm run verify:apps
```

`verify:apps` should cover key backend tests, Admin, Web/H5, and native WeChat mini program tests/builds when the project provides those scripts.

## Verification Layers

1. Use `tdd` or lightweight integration tests for high-risk business rules, state transitions, API contracts, and frontend business logic.
2. Use runtime OpenAPI, builds, local page checks, and API checks to confirm each surface can run.
3. Use CodexApp Browser for Web/H5 local interaction, routing, and desktop/mobile viewport checks.
4. Use WeChat DevTools CLI and `miniprogram-automator` for native mini program page open, text assertions, clicks, inputs, and screenshots when visual proof is needed.

## Evidence Strategy

- Prefer DOM, data, route, network, page-data, API response, log, and test assertions over screenshots.
- Use screenshots only for visual risks: layout, overlap, responsive behavior, modals, scroll, empty state, error state, or other human-visible quality concerns.
- Report actual commands and observations. Do not write "tested" without evidence.
- Tie verification back to PRD/issue acceptance criteria.

## Backend Server

```powershell
cd server
mvn -pl BUSINESS_MODULE -am test
mvn -pl ruoyi-admin -am package -DskipTests
```

Verify:

- Business module tests pass.
- Admin APIs cover permissions, pagination, and CRUD behavior.
- User-facing APIs cover VO shape, enabled state, sorting, 404, and disabled-state behavior.
- `/v3/api-docs` is accessible and includes admin and public APIs.

## Admin

```powershell
pnpm run build:admin
pnpm run dev:admin
```

Verify:

- RuoYi-Vue3-TS starts and builds.
- Login, menus, permissions, dictionaries, and baseline CRUD pages still work.
- Business admin pages call admin management APIs.
- Permission buttons match backend permission strings.

## Desktop Web / Browser H5

```powershell
pnpm run test:web
pnpm run build:web
pnpm run dev:web
```

Verify:

- Logic tests cover API clients, Feature APIs, composables, validation, state transitions, and key business states.
- Local browser checks cover main pages, lists, details, error states, empty states, loading states, primary actions, and routing.
- Pages have no horizontal overflow, text overflow, incoherent overlap, or hidden primary actions.

## Native WeChat Mini Program

```powershell
pnpm run test:miniprogram
pnpm run build:miniprogram
pnpm run dev:miniprogram
```

Verify:

- `app.json`, `project.config.json`, `pages/`, and `components/` exist and match native mini program structure.
- WeChat DevTools can open the native mini program project directory.
- DevTools CLI automation can open pages and perform text assertions, clicks, inputs, and screenshots when needed.
- Local simulation may use an empty AppID; preview, upload, and real-device capabilities require a real AppID and authenticated session.

## Verification Report

- List commands actually run.
- Separate logic tests, builds, browser checks, mini program automation, and real backend integration.
- Name unverified items and the external condition needed to verify them.
- Mention PRD or issue identifiers covered by the verification.
