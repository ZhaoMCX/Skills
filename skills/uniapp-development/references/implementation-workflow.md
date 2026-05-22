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

## Report

Include:

- Files changed.
- Target platform assumptions.
- Commands run and their result.
- Any required manual HBuilderX, App device, or mini-program developer-tool follow-up.
