---
name: web-structure
description: Guides responsibility placement for Web, Vue, uni-app, H5, and mini-program frontend business logic. Use when pages, components, stores, request wrappers, SDK callbacks, router guards, or platform APIs mix validation, calculation, workflow orchestration, state transitions, navigation, or user feedback rules.
---

# Web Structure

Use this skill to decide where frontend business logic should live before writing, refactoring, or reviewing Web/Vue/uni-app code. It is a responsibility-placement skill, not a UI design system or framework generator.

## Quick Start

Inspect the project before inventing structure:

1. Identify the framework and runtime: Vue 2, Vue 3, uni-app, H5, mini program, App, SSR, or another Web stack.
2. Identify state management: local component state, page state, Vuex, Pinia, composables, stores, or existing feature services.
3. Identify external boundaries: HTTP client, `uni.*`, browser globals, router, storage, payment, scan, map, auth SDK, analytics, or generated clients.
4. Read existing directories and naming before adding new ones. Prefer local conventions when they keep responsibilities clear.
5. For uni-app platform behavior, also use `uniapp-development`. For full-stack contracts or multi-surface delivery, also use `web-fullstack-dev`.

## Placement Table

| Writing | Role |
| --- | --- |
| Stable business ownership boundary | Feature/Module |
| Current frontend truth and runtime facts | State |
| Public business operation called by UI | Feature API |
| Structured success/failure, notices, refresh, navigation, or next-step intent | Result |
| Page, component, form, button handler, lifecycle hook, visual state | Surface |
| HTTP/Remote API, `uni.*`, SDK, router, storage, payment, scan, map, filesystem | Adapter |

## Role Rules

- Feature/Module owns the business language and boundaries.
- State records current facts. It does not validate, call adapters, navigate, toast, or mutate unrelated features directly.
- Feature API validates, calculates, orchestrates State, calls Adapters, and returns Results.
- Result describes what happened and what the Surface may present or do next.
- Surface collects user input, renders state/results, and calls Feature API. Do not hide business rules in page or component handlers.
- Adapter touches external systems only. Do not hide business rules in request wrappers, SDK callbacks, storage helpers, or router helpers.
- Remote API means backend or platform calls. Feature API means frontend business operations. Keep these names distinct.

## Web Structure Check

Before editing complex frontend business code, state:

```md
Web Structure Check:
- Feature/Module:
- Role:
- Why here:
- Must not live in:
- External boundary:
- Verification:
```

## Extraction Standard

Keep behavior local unless one is true:

- Reused by more than one Surface.
- Hard to test where it is.
- Crosses pages, stores, features, routes, or platforms.
- Touches HTTP, SDKs, router, storage, permissions, payment, scan, map, or other external systems.
- Hides validation, calculation, authorization assumptions, workflow status, or another business invariant.
- Likely to be reused across H5, mini program, App, desktop Web, or management/mobile variants.

Do not split every feature into every role by default.

## Common Misplacements

- Bad: A uni-app scan callback directly changes order status and navigates. Good: Surface receives the scan result; Feature API validates and updates State; Adapter wraps scan and navigation.
- Bad: A Vuex/Pinia action calls HTTP, calculates totals, shows toast, and pushes routes. Good: Feature API owns calculation and workflow; Remote API Adapter only requests; Surface decides presentation from Result.
- Bad: `api/order.js` validates order transitions before posting. Good: order Feature API validates transitions; Remote API Adapter posts a prepared payload.
- Bad: Router guards contain role business rules for a feature. Good: Auth or feature Feature API answers access intent; router Adapter applies navigation.

## Defaults

Feature owns. State records. Feature API decides. Result explains. Surface presents. Adapter integrates.
