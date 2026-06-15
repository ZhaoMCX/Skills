# Development Workflow

## PRD And Issues

1. Use the project's `docs/agents/` setup from `setup-matt-pocock-skills` to find the issue tracker, labels, and domain docs.
2. Read the PRD or issue that defines the work. If none exists for a new feature, create the PRD with `to-prd` before implementation planning.
3. Break approved PRDs or plans into vertical-slice issues with `to-issues`.
4. Treat PRDs and issues as the source for acceptance criteria. Complex business chains may be described inside PRDs/issues, but they are not a separate required workflow.

## Module Planning

Each business module should clarify:

- Backend domain model and database authority.
- Admin management capability.
- User-facing public API.
- Web/H5 presentation or interaction.
- Native WeChat mini program presentation or interaction.
- Shared contracts, API client, tokens, and pure utilities.
- Test and verification commands.

Default implementation order:

1. Read the issue, PRD, domain glossary, and relevant ADRs.
2. Identify the business module and affected surfaces.
3. Run a `Web Structure Check` for complex frontend business logic.
4. Implement backend model, tables, Mapper, Service, and admin CRUD as needed.
5. Add user-facing VO, facade, and `/api/**` endpoints.
6. Confirm runtime OpenAPI contract at `/v3/api-docs`.
7. Update `packages/contracts` and `packages/api-client` only when needed.
8. Connect admin pages to admin APIs.
9. Connect Web/H5 pages to public APIs.
10. Connect native WeChat mini program pages to public APIs.
11. Verify with TDD, integration tests, builds, and surface checks.

## Frontend Rules

- Use `web-structure` to place business logic: Feature/Module owns business boundaries, State records runtime facts, Feature API orchestrates, Result describes outcomes, Surface renders, and Adapter touches external systems.
- Keep page shells thin: collect input, render state, call Feature API, and present Results.
- Put business rules, validation, state transitions, and cross-page flows in Feature APIs, composables, or business components.
- Request wrappers are Remote API Adapters and should not contain business decisions.
- Isolate API clients, router, storage, toast/loading, WeChat SDK, and platform APIs behind adapters.
- Web/H5 and native WeChat mini program may share tokens, types, API clients, and pure utilities; they should not share page shells.
- User-facing surfaces do not use admin UI frameworks as their default design system.
- Page issues should include empty, loading, error, and key interaction states when relevant.

## TDD

- Use `tdd` for high-risk domain rules, state machines, money, inventory, points, order flows, permissions, and API contract transformations.
- Backend tests should verify behavior through public service/API boundaries where practical.
- Frontend TDD should cover Feature APIs, state transitions, validation, API data adaptation, permissions, and login-state decisions.
- UI styling, static display, and low-risk field mapping do not require TDD by default.
- Tests verify PRD/issue acceptance criteria; they do not create a separate source of business truth.

## Native WeChat Mini Program

- Use `app.js`, `app.json`, `app.wxss`, `project.config.json`, `pages/`, and `components/` as source anchors.
- Use `wechat-miniprogram-devtools` for DevTools CLI and `miniprogram-automator`.
- Local simulation may use an empty AppID; preview, upload, and real-device capabilities need a real AppID and authenticated DevTools session.

## Completion Report

Report:

- PRD or issue identifiers.
- Affected modules, surfaces, and API boundaries.
- Backend tests, frontend logic tests, build commands, and mini program checks actually run.
- Whether Web/H5 and native mini program interaction checks were performed.
- Unverified items and blockers requiring real accounts, AppID, server, database, or external services.
