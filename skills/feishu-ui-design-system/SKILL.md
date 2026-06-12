---
name: feishu-ui-design-system
description: Manages Feishu-backed UI design system facts, including UI rules, structured tokens/components, page templates, HTML visual examples, screenshot evidence, page overrides, and local implementation mappings. Use before frontend UI work, page/component design, UI review, visual acceptance, or when connecting ui-ux-pro-max recommendations to Feishu and code.
---

# Feishu UI Design System

## Ground Rules

First follow `feishu-agent-knowledge-base`: Feishu is the official structured UI design fact source, local Markdown/code holds versioned implementation facts, official writes require confirmation, and Feishu unavailability blocks official UI design completion.

Before official Feishu reads or writes, confirm the target project's declared `lark-cli` profile from project docs or explicit user instruction. Use `--profile <profile-name>` explicitly and default to `--as user` unless the project declares bot-only behavior or the target assets are app-owned. If no profile is declared, draft or inspect only; do not create or update official UI design systems, tokens, components, page templates, HTML examples, screenshot evidence, or implementation mappings.

Use `ui-ux-pro-max` for design intelligence: style, colors, typography, layout, UX guidance, and UI review. This skill manages the Feishu fact source and implementation mapping; it does not replace `ui-ux-pro-max`.

Use `lark-doc`, `lark-base`, and `lark-drive` for Feishu documents, Base records, HTML files, images, and permissions.

## Model

Use Feishu Doc + Base + HTML examples:

- Doc: UI design system narrative, product tone, audience, density, layout rules, accessibility, and anti-patterns.
- Base: structured tokens, components, page templates, page overrides, visual examples, screenshot evidence, and implementation mappings.
- HTML examples: visual constraints for key components and pages. They are reference artifacts, not the final application source.
- Local code: implemented tokens, CSS variables, theme config, components, and mapping from Feishu design IDs to code.

## Required Assets

Official UI design facts must have stable IDs:

- UI design system.
- Token.
- Component.
- Component variant/state.
- Page template.
- Page override.
- HTML example.
- Screenshot evidence.
- Implementation mapping.

Core records should capture:

- Token semantics, value, usage, surface, state, and status.
- Component purpose, variants, states, forbidden usage, accessibility rules, and example links.
- Page template goal, density, layout, hierarchy, primary action, empty/loading/error states, and evidence.
- HTML example path or Feishu file link, viewport assumptions, related component/page, and review status.
- Implementation mapping from Feishu IDs to code files, CSS variables, package tokens, or component names.

## Workflow

### Create Or Update UI Design System

1. Use `ui-ux-pro-max` to generate or review design recommendations.
2. Convert recommendations into structured UI rules, tokens, components, page templates, and anti-patterns.
3. Add HTML examples for key components and pages when visual proportion or layout must constrain implementation.
4. Present a structured draft before official Feishu writes, including the declared profile, identity, target Doc/Base/Drive container, and records or files to create or update.
5. After confirmation, write Feishu records and re-read them to verify stable IDs and links.

### Frontend Implementation

1. Read the UI design system, relevant page template, page override, HTML examples, and implementation mappings before editing UI.
2. Use local code for final implementation: tokens, CSS variables, components, and theme config.
3. Do not invent ad-hoc UI rules when a Feishu design fact exists.
4. If implementation creates or changes stable UI implementation facts, update the local mapping and the relevant Feishu record.

### Visual Acceptance

1. Validate pages against business-chain steps, UI rules, page templates, and HTML examples.
2. Use screenshots for visual evidence and review; do not default to pixel-baseline regression.
3. Record visual issues, missing evidence, and retest status in Feishu.
4. Re-read changed records and report IDs, statuses, screenshots, blockers, and next actions.

## Boundaries

- This skill covers UI design systems, not product requirements, business chains, architecture, data models, or final ADRs.
- Product and business facts belong to `feishu-business-chain`.
- Final ADRs and code-coupled implementation details belong in local Markdown/code.
