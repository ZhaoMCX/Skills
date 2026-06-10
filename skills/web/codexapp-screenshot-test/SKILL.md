---
name: codexapp-screenshot-test
description: Guides business-flow visual QA with the CodexApp in-app browser, deciding when screenshots are required across a user journey, when DOM/data assertions are enough, and how to report evidence. Use when testing frontend business flows, page interactions, visual states, responsive layouts, modals, scroll behavior, or when the user mentions screenshots, visual verification, CodexApp browser, or page QA.
---

# CodexApp Screenshot Test

Use this skill to verify business flows visually with the CodexApp in-app browser. It is a decision layer above `browser:control-in-app-browser`; use that Browser skill for the actual navigation, clicking, DOM inspection, and screenshots.

## Business Flow First

Before screenshotting, define the business chain:

- User goal.
- Start page and state.
- Required business steps.
- Expected end state.
- Business blockers, guards, or permissions.

Screenshots must map to business states, not random clicks. Each screenshot should prove a step in the user journey.

## Screenshot Decision

1. Use DOM, data, URL, active state, network, or visible-text assertions first to prove state changes.
2. Screenshot only key business boundaries: entry context, important intermediate state, and final result.
3. Screenshot when the assertion is human-visible quality: overlap, clipping, scrolling, modal layout, placeholder layering, responsive layout, empty state, disabled state, success/failure panel, or bottom-bar obstruction.
4. Do not screenshot pure data facts when DOM or network evidence is enough, such as result count, active tab, order status field, button state, form value, toast text, or API success/failure.
5. If the business flow reaches sensitive real-world content, pause and ask before screenshotting. Sensitive content includes real payment QR codes, personal identity information, phone numbers, tokens, secrets, backend accounts, private logs, or credential-like values.

## Business-State Budget

Do not screenshot every click. Screenshot by state boundary:

- Short flow: entry state and result state.
- Medium flow: entry state, one key intermediate state, and result state.
- Long flow: at most one key screenshot per business phase, plus issue evidence if a visual problem is found.
- Visual bug fix: capture the problem state and the fixed state when possible.
- Pure data transition: record DOM/data assertions instead of spending screenshot budget.

## Evidence Rules

- Save screenshots under `.scratch/visual-qa/<business-flow>/`.
- Name files as `NN-step-state-viewport.png`, for example `01-rental-cart-before-scroll-mobile.png`.
- For each screenshot, record the business step, expected visual result, and actual result.
- Include key screenshots in the final report unless sensitive content is present.
- Never commit `.scratch` screenshots or visual QA scratch artifacts.

## Report Format

Report these items:

- Business chain tested.
- Environment and API mode, such as mock or real API.
- Viewport and device profile.
- DOM/data assertions used to reduce screenshot count.
- Screenshot paths and what each proves.
- Issues found, fixed, or still blocked.

## Examples

- Rental flow: search device -> add to cart -> scroll multiple cart items -> seat guard or payment waiting. Use DOM metrics for item count and `scrollHeight/clientHeight/scrollTop`; screenshot before-scroll, after-scroll, and the guard or payment waiting state.
- Shop flow: search product -> switch category -> insufficient points or exchange success -> order detail. Use DOM assertions for search and category changes; screenshot only the insufficient-points modal and success/detail result state.
- Order filter flow: status tab and type filter change active state and result count. If no layout risk exists, use DOM assertions only and do not screenshot.
- Real payment QR flow: pause before screenshotting and ask the user whether screenshot capture is allowed.
