---
name: unity-dotween
description: DOTween workflow for this Unity project. Use when implementing, reviewing, debugging, or refactoring tween animations with DG.Tweening, including Transform, UI, CanvasGroup, Image, SpriteRenderer, Material, AudioSource, Rigidbody/Rigidbody2D, Sequences, lifecycle cleanup, async/coroutine waits, DOTween settings, modules, performance capacity, and safe interaction with gameplay modules or Unity UI effects.
---

# DOTween

## Overview

Use DOTween as the default code-driven tweening library for runtime movement, UI transitions, feedback animation, fades, punches, shakes, material values, and timeline-like `Sequence` composition in this project.

The project currently anchors DOTween at `Assets/Plugins/Demigiant/DOTween` with settings in `Assets/Resources/DOTweenSettings.asset`. Treat local files as the source of truth before relying on memory or external docs.

## Read First

Before adding or changing DOTween behavior:

1. Inspect `Assets/Resources/DOTweenSettings.asset` for current defaults, module toggles, Safe Mode, AutoPlay, AutoKill, and capacity policy.
2. Inspect `Assets/Plugins/Demigiant/DOTween/DOTween.XML` for exact API signatures and extension method availability.
3. Inspect `Assets/Plugins/Demigiant/DOTween/Modules/*.cs` for enabled shortcut modules and conditional compile symbols.
4. Check whether the target assembly has a reference path to DOTween. If an asmdef cannot see `DG.Tweening`, add/adjust asmdef references deliberately instead of moving scripts.
5. Verify whether DOTween Pro components exist before using `DOTweenAnimation`, `DOTweenPath`, or visual tween authoring components. This project currently appears to use the base/plugin DLL plus modules.

## References

- Read `references/quick-reference.md` for detailed recipes, lifecycle rules, module map, code patterns, settings interpretation, and validation checklists.
- Use local XML/module files first. Use external DOTween documentation only when local files do not answer the question.

## Implementation Workflow

1. Identify the animated target type: `Transform`, `RectTransform`, `CanvasGroup`, `Graphic/Image/Text`, `SpriteRenderer`, `Material`, `AudioSource`, `Rigidbody`, custom value, or mixed sequence.
2. Pick the narrowest extension method available for that type, such as `DOAnchorPos` for UI layout, `DOFade` for alpha, `DOScale` for scale, or `DOTween.To` for custom values.
3. Decide ownership and lifetime before writing the tween:
   - Component-local one-shot: store a `Tween` field and kill it in `OnDisable` or `OnDestroy`.
   - UI panel transitions: store a `Sequence`, set initial state explicitly, and prevent duplicate open/close sequences.
   - Reusable gameplay feedback: expose a method such as `PlayHitFeedback()` that restarts a private tween/sequence.
   - Cross-module animation trigger: keep state mutation in the owning gameplay module; use DOTween only as a presentation-side effect.
4. Add fluent settings in a stable order: `SetEase`, `SetDelay`, `SetLoops`, `SetUpdate`, `SetLink`, callbacks.
5. Validate in Play Mode or with targeted tests when behavior depends on Unity update timing, destruction, disable/enable, layout rebuilds, physics, or pause state.

## Project Rules

- Always add `using DG.Tweening;`.
- Prefer code-driven tweens over hidden scene authoring unless DOTween Pro components are confirmed present and the prefab workflow needs them.
- Prefer `SetLink(gameObject)` or explicit `Kill` for GameObject-owned tweens. Remember `SetLink` has no effect after a tween is nested inside a `Sequence`; link or kill the owning sequence instead.
- Keep a field for any tween that can overlap with itself. Kill, rewind, complete, or restart it intentionally before creating another one.
- Use `SetId` for grouping/filtering tweens by feature, state, or owner.
- Use `SetUpdate(true)` for UI that must keep animating while `Time.timeScale == 0`, such as pause menus.
- Use `UpdateType.Fixed` for Rigidbody/Rigidbody2D tweens that should align with physics.
- Avoid allocating new sequences every frame. Build tweens in event handlers, lifecycle methods, or commands.
- Avoid tweening shared materials unless the shared asset is intentionally being animated globally. Use renderer instance material, material property blocks, or owned material instances as appropriate.
- Do not rely on default settings implicitly for user-facing animation. Specify ease, duration, loop, update behavior, and lifecycle cleanup in the code that owns the tween.
- Finish Unity work with the repository `unity-check` completion gate.
