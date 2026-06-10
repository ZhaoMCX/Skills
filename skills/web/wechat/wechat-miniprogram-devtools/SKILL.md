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
| visual evidence or screenshots | keep functional assertions in automator; prefer DevTools/automator screenshot capture; use OS/window capture only when explicitly approved or DevTools capture is impossible |
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
6. For interaction or screenshots, ensure DevTools automation is enabled, restore the DevTools main window so it is visible on the desktop and not minimized/off-screen, then connect with `miniprogram-automator`.
7. Verify results with concrete evidence: command output, screenshot path, page route, selector result, or assertion result.

## Field-Tested Failure Modes

- A minimized DevTools window is the most common cause of misleading automation failures. Keep the DevTools main window visible on the desktop; it does not need to own system focus for every assertion, but it must not be minimized, hidden behind virtual-desktop state, or off-screen.
- Screenshot and visual QA are more fragile than data assertions. First prove page route, AppService state, page data, and selectors with `miniprogram-automator`; then capture visual evidence with DevTools/automator screenshot tools.
- If screenshot capture times out while page data assertions pass, treat it as a DevTools/window-state problem first. Restore and size the DevTools window, wait for repaint, and retry the screenshot before blaming the mini program.
- Do not switch to the `computer-use` plugin as a screenshot fallback unless the user explicitly asks. For WeChat visual QA, prefer DevTools screenshot/capture so the evidence comes from the same simulator under test.
- Official CLI `quit` can show a visible close countdown/prompt on Windows. It is graceful but not silent. If the user requires silent close/restart, disconnect automator first, verify the DevTools install path and target project, then terminate only scoped DevTools processes from that install path before reopening.
- Restarting DevTools is not mandatory for every test. Reuse a visible, healthy session for the same generated project when route/data/config are current. Restart only for stale project state, wrong project/session attachment, changed AppID/project config, automation-port confusion, or unrecoverable screenshot/session timeouts.
- When testing real API flows, state which parts are real and which are intentionally mocked. For example, backend endpoints and local services may be real while a third-party payment QR provider such as Shouqianba is mocked by the backend for local regression.
- Keep test artifacts out of tracked files: screenshots, `.scratch`, `dist`, `test-results`, and reports should remain ignored unless the repo has an explicit artifact convention.

## Working Rules

- Use quoted paths on Windows; both CLI path and project path may contain spaces or localized characters.
- Prefer read-only or local simulator actions unless the user requests upload or publishing operations.
- Treat upload as a user-visible release action. Confirm appid, version, description, and target project before uploading.
- If DevTools reports login, appid, network, or permission errors, state the blocker plainly and avoid inventing workarounds.
- For build/npm operations inside the mini program output, use DevTools CLI when the project requires WeChat's npm build behavior.
- For simulator automation, keep exactly one target-project DevTools session active. Before opening a different generated project, prefer reusing the visible current session when it is the same project; otherwise close or clean the old session first, then confirm the intended automation port is no longer listening.
- DevTools must be visible on the desktop for simulator automation, screenshots, or visual QA. A covered, minimized, or off-screen DevTools window can make `App.captureScreenshot`, window capture, and some simulator operations hang or time out even when AppService has no errors.
- On Windows, always restore the DevTools main window, move/size it predictably, and allow a short repaint settle time immediately before screenshots or visual QA. Bringing DevTools to the top is useful for capture reliability, but do not describe this as a requirement to keep it permanently in the system foreground.
- For automator cleanup, prefer `miniProgram.disconnect()`. Do not use `miniProgram.close()` or click the window close button by default because either can trigger prompts, visible UI churn, or shutdown hangs.
- The official DevTools CLI `quit` command may show a visible "CLI/HTTP call is closing DevTools, auto close after 3 seconds" prompt in current Windows DevTools versions. Treat `quit` as the official graceful close path, not as a truly silent close path.
- When a test workflow requires restarting DevTools, do not use `cli quit` if the user requires silent restart/no close prompt. First disconnect automator, verify the target project/window and DevTools install directory, then terminate only processes from that DevTools install directory as scoped cleanup before reopening the project.
- If the user explicitly requires no close prompt, or a stale DevTools session must be removed before opening a different project, first disconnect automator, verify the target project/window and DevTools install directory, then terminate only processes from that DevTools install directory as scoped cleanup. Report that scoped process cleanup was used.
- Clean stale DevTools sessions with the least disruptive available path. A leftover old main window can make automator connect to the wrong or half-stale session.
- When starting a stable automation session, open the current generated project window first, then enable `auto` on the intended port. Reusing a warmed session is fine only after proving it belongs to the current project and is visible.
- If DevTools shows an interactive dialog, trust prompt, AppID-change prompt, tourist-mode prompt, login prompt, authorization prompt, or permission prompt, do not continue automation in the background. Confirm only when the action is clearly local and safe; otherwise stop and tell the user exactly what needs interactive confirmation.
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
- Mention whether the DevTools window was visible on the desktop and not minimized/off-screen, whether it was temporarily brought to the top for capture reliability, whether only one target-project DevTools session was active, and whether any dialog or interactive blocker appeared.
- Separate functional assertion failures, screenshot/capture failures, AppService logs, DevTools CLI output, and `web-view`/H5 diagnostics.
- If preview/upload was requested, report version, description, target project, and any login or permission blocker.
- For real-write regressions, include run ID, prefix, role, endpoint, returned or looked-up ID, and cleanup status.
- For role-based checks, report both page evidence and raw API evidence when possible. If the page is correct but the role token can fetch forbidden data, classify it as backend authorization/data filtering leakage.

Keep automation scoped to local development unless the user explicitly asks for preview/upload/release work. Never store credentials, tokens, QR codes, or uploaded package metadata in repo files unless the project already has a clear convention for that artifact.
