---
name: wechat-miniprogram-devtools
description: Guides WeChat Mini Program project work through official WeChat DevTools. Use when working with DevTools CLI, miniprogram-automator, uni-app mp-weixin output, preview/upload, simulator automation, screenshots, page inspection, clicks, input, or end-to-end checks.
---

# WeChat Mini Program DevTools

## Overview

Use the official WeChat DevTools CLI for project-level operations and `miniprogram-automator` for simulator interaction. Prefer official DevTools capabilities; do not install or rely on third-party MCP wrappers unless the user explicitly asks.

Load `references/automation-and-release.md` when the task involves stable regression pipelines, preview QR codes, upload/release work, `web-view`, real-device behavior, DevTools cache, screenshot reliability, or detailed logging.

## Decision Guide

| User asks for | Use |
| --- | --- |
| open, preview, upload, build npm, inspect project settings | DevTools CLI |
| click, type, navigate pages, read page data, screenshot, assert UI | `miniprogram-automator` after DevTools is open with automation enabled |
| uni-app / HBuilderX / `mp-weixin` project | build or locate the `dist/dev/mp-weixin` or `dist/build/mp-weixin` output first, then point DevTools at that output |
| CI-style checks | use CLI for setup and automator for deterministic assertions; report login, appid, or GUI blockers |
| visual evidence or screenshots | keep functional assertions in automator; use OS/window capture if DevTools protocol screenshots hang |
| stale simulator output after config/env changes | clear only `compile` cache, then reopen the generated mini program output |
| real-device preview QR | build, run the required simulator regression for the changed flows, then create and validate an image QR |

## Standard Workflow

1. Inspect the repo before running DevTools commands. Check `package.json`, `manifest.json`, `project.config.json`, `project.private.config.json`, and existing scripts.
2. If the workspace is uni-app, run or identify the existing `mp-weixin` build script. Typical outputs are `dist/dev/mp-weixin` for development and `dist/build/mp-weixin` for production.
3. Locate the DevTools CLI executable instead of assuming it is on `PATH`. Common Windows candidates include:
   - `C:\Program Files (x86)\Tencent\WeChat Web DevTools\cli.bat`
   - `C:\Program Files\Tencent\WeChat Web DevTools\cli.bat`
   - installation directories whose folder name is the localized WeChat Web DevTools name
   - user-installed WeChat DevTools locations under `%LOCALAPPDATA%` or shortcuts
4. Run the CLI help/version command first when the exact flags are uncertain. DevTools command names and flags can vary across versions.
5. Open/import the mini program project with the CLI. For uni-app, the project path is the compiled `mp-weixin` output, not the repo root unless `project.config.json` is there.
6. For interaction or screenshots, ensure DevTools automation is enabled, then connect with `miniprogram-automator`.
7. Verify results with concrete evidence: command output, screenshot path, page route, selector result, or assertion result.

## Working Rules

- Use quoted paths on Windows; both CLI path and project path may contain spaces or localized characters.
- Prefer read-only or local simulator actions unless the user requests upload or publishing operations.
- Treat upload as a user-visible release action. Confirm appid, version, description, and target project before uploading.
- If DevTools reports login, appid, network, or permission errors, state the blocker plainly and avoid inventing workarounds.
- For build/npm operations inside the mini program output, use DevTools CLI when the project requires WeChat's npm build behavior.
- On Windows, do not assume a background or minimized DevTools window is reliable. Before simulator automation or OS screenshots, restore the DevTools main window to the desktop, move/size it predictably, bring it to the foreground, and allow a short repaint settle time.
- Clean stale DevTools sessions with the official `quit` command first, then kill remaining processes from the DevTools install directory only if needed. A leftover old main window can make automator connect to the wrong or half-stale session.
- When starting a stable automation session, open the current generated project window first, then enable `auto` on the intended port. Reusing a warmed session is fine only after proving it belongs to the current project and is visible.
- Some DevTools versions accept `auto --auto-port <port>` even when help output omits it; prefer a fixed auto port for repeatable `miniprogram-automator` connections, and do not assume the `ws connect <port>` value from `--debug` is the automator endpoint.
- Prefer `miniProgram.disconnect()` after checks. Do not call `miniProgram.close()` by default because it can trigger close prompts or hang shutdown.
- Treat cleanup/navigation-after-assertion steps as best-effort unless the cleanup behavior itself is the feature under test. A timeout while returning from a diagnostic page should not fail an already-proven page assertion.
- Do not put cold start, window foregrounding, web-view loading, preview generation, and visual capture under one tight timeout. Use per-stage timeouts and report the exact stage that failed.

## Project Checks

Before automating, confirm:

- The target directory contains `project.config.json`.
- `appid` is suitable for the requested action. Empty appid can be acceptable for local simulator checks; `touristappid` can trigger DevTools dialogs; preview/upload/real-device capabilities require a confirmed real `wx...` appid.
- The compiled output is current after source changes.
- DevTools is installed, logged in when required, and its automation service is enabled.
- The page route exists in `app.json` or generated pages config.
- If role-based tests need prepared accounts, reuse the project’s latest fixture run or cached role tokens when available. Do not allow captcha solving/account bootstrap flakiness to masquerade as a simulator page failure.

## Preview QR Discipline

- Never create or hand over a real-device preview QR before the required simulator checks for the changed surface have passed. A quick prepreview/smoke gate is not the same as full simulator regression.
- If the change touches only remote `web-view` H5, verify the remote public content separately; a new mini program QR does not update the remote page by itself.
- Generate QR codes with the CLI's image output option when available, not terminal ASCII output. Validate the produced file with an image decoder and report dimensions/bytes/path.
- If a QR is expired, regenerate it from the current verified build. Do not reuse old QR paths or assume the previous preview still contains new changes.
- Keep preview QR artifacts out of repo-tracked files unless the project already has an artifact convention.

## Report

- Mention project path opened in DevTools, target appid, commands run, and whether automation connected.
- Separate functional assertion failures, screenshot/capture failures, AppService logs, DevTools CLI output, and `web-view`/H5 diagnostics.
- If preview/upload was requested, report version, description, target project, and any login or permission blocker.
- For real-write regressions, include run ID, prefix, role, endpoint, returned or looked-up ID, and cleanup status.
- For role-based checks, report both page evidence and raw API evidence when possible. If the page is correct but the role token can fetch forbidden data, classify it as backend authorization/data filtering leakage.

Keep automation scoped to local development unless the user explicitly asks for preview/upload/release work. Never store credentials, tokens, QR codes, or uploaded package metadata in repo files unless the project already has a clear convention for that artifact.
