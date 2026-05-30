# DOTween Quick Reference

## Project Anchors

| Need | Path or type |
| --- | --- |
| DOTween runtime DLL | `Assets/Plugins/Demigiant/DOTween/DOTween.dll` |
| DOTween runtime XML docs | `Assets/Plugins/Demigiant/DOTween/DOTween.XML` |
| DOTween editor DLL/XML | `Assets/Plugins/Demigiant/DOTween/Editor/` |
| Modules source | `Assets/Plugins/Demigiant/DOTween/Modules/*.cs` |
| Module asmdef | `Assets/Plugins/Demigiant/DOTween/Modules/DOTween.Modules.asmdef` |
| Project settings asset | `Assets/Resources/DOTweenSettings.asset` |
| Namespace | `DG.Tweening` |

## Current Project Settings Snapshot

Read `DOTweenSettings.asset` again before making sensitive changes. At skill creation time the asset indicated:

| Setting | Current value | Practical meaning |
| --- | --- | --- |
| `useSafeMode` | `1` | DOTween catches common tween target failures. Still write explicit lifecycle cleanup. |
| `defaultAutoPlay` | `3` | New tweens autoplay by default. Pause explicitly when composing deferred tweens. |
| `defaultAutoKill` | `1` | Completed tweens are killed by default. Use `SetAutoKill(false)` only when replay/reuse is intentional. |
| `defaultEaseType` | `6` | Do not rely on this implicitly for UX-critical animations. |
| `defaultUpdateType` | `0` | Normal Update by default. Use `Fixed`, `Late`, or independent update where needed. |
| `defaultTimeScaleIndependent` | `0` | Tweens respect `Time.timeScale` unless `SetUpdate(true)` is used. |
| `defaultRecyclable` | `0` | Tweens are not recyclable by default. |
| Enabled modules | Audio, Physics, Physics2D, Sprite, UI | Shortcuts for these targets should be available. |
| Disabled modules | UI Toolkit, TextMeshPro, 2D Toolkit, DeAudio, EPO Outline | Do not use those shortcuts unless settings/modules are changed and compiled. |

## Module Map

| Target | Common extensions | Source |
| --- | --- | --- |
| `Transform` | `DOMove`, `DOLocalMove`, `DORotate`, `DOLocalRotate`, `DOScale`, `DOLookAt`, `DOPath` | `DOTween.dll` shortcuts/XML |
| `RectTransform` | `DOAnchorPos`, `DOAnchorPos3D`, `DOSizeDelta`, `DOPivot`, `DOAnchorMin`, `DOAnchorMax`, `DOPunchAnchorPos`, `DOShakeAnchorPos`, `DOJumpAnchorPos` | `DOTweenModuleUI.cs` |
| `CanvasGroup` | `DOFade` | `DOTweenModuleUI.cs` |
| `Graphic`/`Image`/`Text` | `DOColor`, `DOFade`, `DOBlendableColor`, `DOFillAmount`, `DOCounter`, `DOText` | `DOTweenModuleUI.cs` |
| `ScrollRect`/`Slider` | `DONormalizedPos`, `DOHorizontalNormalizedPos`, `DOVerticalNormalizedPos`, `DOValue` | `DOTweenModuleUI.cs` |
| `SpriteRenderer` | `DOColor`, `DOFade`, `DOGradientColor`, `DOBlendableColor` | `DOTweenModuleSprite.cs` |
| `Material` | `DOColor`, `DOFade`, `DOFloat`, `DOVector`, `DOOffset`, `DOTiling`, `DOGradientColor` | `DOTween.dll`, `DOTweenModuleUnityVersion.cs` |
| `AudioSource`/`AudioMixer` | `DOFade`, `DOPitch`, `DOSetFloat` | `DOTweenModuleAudio.cs` |
| `Rigidbody` | `DOMove`, `DORotate`, `DOLookAt`, `DOJump`, `DOPath`, `DOLocalPath` | `DOTweenModulePhysics.cs` |
| `Rigidbody2D` | `DOMove`, `DORotate`, `DOJump`, `DOPath`, `DOLocalPath` | `DOTweenModulePhysics2D.cs` |
| Custom data | `DOTween.To`, `DOTween.ToAlpha`, `DOTween.Sequence` | `DOTween.XML` |

## Selection Guide

| Situation | Prefer | Avoid |
| --- | --- | --- |
| UI panel fade | `CanvasGroup.DOFade` | Fading every child Graphic separately. |
| UI layout movement | `RectTransform.DOAnchorPos` | `transform.DOMove` on layout-controlled UI. |
| Button tap feedback | `DOPunchScale` or a short `Sequence` | Creating a new infinite tween each click without killing the old one. |
| Pause menu animation | `.SetUpdate(true)` | Scaled-time tweens that freeze while paused. |
| Physics object movement | Rigidbody/Rigidbody2D shortcuts with fixed update intent | `transform.DOMove` on physics bodies. |
| Shader/material value | Owned material or property-specific tween | Animating `sharedMaterial` accidentally. |
| Reusable presentation state | Stored `Tween`/`Sequence` fields | Anonymous fire-and-forget tween when state can change. |
| Group control | `SetId` and stored references | Overwriting shortcut target with `SetTarget`. |
| One-off destruction cleanup | `SetLink(gameObject)` | Depending only on Safe Mode. |

## Fluent API Cheat Sheet

| API | Use |
| --- | --- |
| `SetEase(Ease.OutCubic)` | Control timing feel. Always specify for user-facing animation. |
| `SetDelay(seconds)` | Delay before startup. Remember delayed tweens still need cleanup. |
| `SetLoops(count, LoopType.Yoyo)` | Repeat behavior. Use `-1` only for intentional infinite loops. |
| `SetUpdate(true)` | Ignore `Time.timeScale`; useful for pause overlays. |
| `SetUpdate(UpdateType.Fixed)` | Align with fixed update. |
| `SetLink(gameObject)` | Kill on destroy. Has no effect for tweens already nested inside a `Sequence`. |
| `SetId(id)` | Group/filter tweens without changing shortcut target. |
| `SetAutoKill(false)` | Keep tween alive for rewind/restart reuse. Requires manual `Kill`. |
| `SetRecyclable(true)` | Allow pooling if lifecycle is understood; clear references on kill. |
| `OnComplete(callback)` | Final successful completion action. |
| `OnKill(callback)` | Clear stored references and guard lifecycle cleanup. |
| `Pause`, `Play`, `Restart`, `Rewind`, `Complete`, `Kill` | Runtime control on stored tween/sequence references. |

## Lifecycle Patterns

### One Field Per Overlapping Motion

```csharp
Tween moveTween;

void MoveTo(Vector3 target)
{
    moveTween?.Kill();
    moveTween = transform
        .DOMove(target, 0.25f)
        .SetEase(Ease.OutCubic)
        .SetLink(gameObject)
        .OnKill(() => moveTween = null);
}

void OnDestroy()
{
    moveTween?.Kill();
}
```

### Reusable Tween With AutoKill Disabled

Use this only when repeated replay is materially cheaper or stateful control is required.

```csharp
Tween pulseTween;

void Awake()
{
    pulseTween = transform
        .DOScale(1.08f, 0.2f)
        .SetEase(Ease.InOutSine)
        .SetLoops(2, LoopType.Yoyo)
        .SetAutoKill(false)
        .Pause()
        .SetLink(gameObject);
}

public void Pulse()
{
    pulseTween.Restart();
}

void OnDestroy()
{
    pulseTween?.Kill();
}
```

### Disable-Safe UI

`SetLink(gameObject, LinkBehaviour.PauseOnDisablePlayOnEnable)` is useful for passive looping UI, but explicit `OnDisable` cleanup is clearer for panel transitions where close/open semantics matter.

```csharp
void OnDisable()
{
    sequence?.Kill();
    sequence = null;
}
```

## Sequence Rules

- Use `Append` for serial steps.
- Use `Join` for simultaneous steps.
- Use `Insert(time, tween)` for timeline placement.
- Use `AppendInterval(seconds)` for gaps.
- Use `AppendCallback` for ordering callbacks inside the sequence.
- Store and kill the `Sequence`, not only child tweens.
- Use `DOTween.Sequence(target)` or `SetLink(gameObject)`/stored field for sequence ownership.
- Remember child tween settings such as `SetLink` can be ignored once nested; control lifetime through the sequence.
- Avoid infinite loops inside sequences unless the sequence owner is explicit and killed on disable/destroy.

Example:

```csharp
Sequence BuildShowSequence(CanvasGroup group, RectTransform panel, GameObject owner)
{
    group.alpha = 0f;
    panel.anchoredPosition = new Vector2(0f, -24f);

    return DOTween.Sequence()
        .SetUpdate(true)
        .SetLink(owner)
        .Append(group.DOFade(1f, 0.12f))
        .Join(panel.DOAnchorPos(Vector2.zero, 0.2f).SetEase(Ease.OutCubic))
        .AppendCallback(() => group.blocksRaycasts = true);
}
```

## UI Recipes

### Fade Panel

```csharp
canvasGroup.DOFade(visible ? 1f : 0f, 0.15f)
    .SetEase(visible ? Ease.OutQuad : Ease.InQuad)
    .SetUpdate(true)
    .SetLink(gameObject);
```

Set `interactable` and `blocksRaycasts` separately at the correct moment. DOTween does not manage them.

### Move RectTransform

```csharp
rectTransform
    .DOAnchorPos(targetAnchoredPosition, 0.2f, snapping: false)
    .SetEase(Ease.OutCubic)
    .SetUpdate(true)
    .SetLink(gameObject);
```

Use anchored position for normal UGUI layout. Use world move only for world-space UI with intentional world coordinates.

### Fill Image

```csharp
fillImage
    .DOFillAmount(normalizedValue, 0.2f)
    .SetEase(Ease.OutQuad)
    .SetLink(gameObject);
```

Clamp `normalizedValue` before tweening if input may be outside 0..1.

### Scroll Rect

```csharp
scrollRect
    .DOVerticalNormalizedPos(1f, 0.25f)
    .SetEase(Ease.OutCubic)
    .SetUpdate(true)
    .SetLink(gameObject);
```

Wait for layout rebuild before scrolling to a newly created element.

## Sprite And Material Recipes

### Sprite Flash

```csharp
Tween flashTween;

void Flash(SpriteRenderer sprite)
{
    flashTween?.Kill();
    sprite.color = Color.white;
    flashTween = sprite
        .DOColor(Color.red, 0.08f)
        .SetLoops(2, LoopType.Yoyo)
        .SetEase(Ease.OutQuad)
        .SetLink(gameObject)
        .OnKill(() => flashTween = null);
}
```

### Material Float

```csharp
static readonly int DissolveId = Shader.PropertyToID("_Dissolve");

Tween dissolveTween = material
    .DOFloat(1f, DissolveId, 0.35f)
    .SetEase(Ease.InOutSine);
```

Use property IDs where possible. Confirm shader property names in the material/shader before writing code.

## Physics Recipes

```csharp
rb.DOMove(targetPosition, 0.3f)
    .SetEase(Ease.OutQuad)
    .SetUpdate(UpdateType.Fixed)
    .SetLink(gameObject);
```

Use Rigidbody shortcuts when physics ownership matters. Do not mix direct transform tweens and physics movement on the same body without a deliberate reason.

## Async And Coroutine Waits

DOTween exposes coroutine-style waits such as `WaitForCompletion`, and this project includes module support for async wait methods in `DOTweenModuleUnityVersion.cs`.

Coroutine:

```csharp
yield return transform.DOMove(target, 0.25f).WaitForCompletion();
```

Async:

```csharp
Tween tween = transform.DOMove(target, 0.25f).SetLink(gameObject);
await tween.AsyncWaitForCompletion();
```

Guard async continuations after awaits:

```csharp
if (this == null || !isActiveAndEnabled) return;
```

## Performance And Capacity

- DOTween can grow capacity automatically, but growth may cause hitches. For a feature with many concurrent tweens, measure or estimate peak counts and consider `DOTween.SetTweensCapacity(tweeners, sequences)` at startup before tweens are running.
- Do not call `DOTween.Init` or `SetTweensCapacity` from arbitrary gameplay objects if central initialization already exists. Search first.
- Avoid generating tweens per-frame. Tween when state changes.
- Use `DOKill`, stored fields, or ids to stop old tweens before starting new ones.
- Prefer short, simple tweens for high-count list UI. Heavy shake/punch loops on many elements can be expensive and visually noisy.

## Common Failure Modes

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| Tween freezes in pause menu | Tween respects `Time.timeScale` | Add `.SetUpdate(true)` for pause UI. |
| UI moves to unexpected place | Used world transform tween on layout UI | Use `RectTransform.DOAnchorPos` and verify anchors/pivots. |
| Duplicate wobble or runaway animation | Repeated calls create overlapping tweens | Store a field and `Kill`, `Rewind`, or `Restart`. |
| Callback fires after close/destroy | Tween outlives owner | Link/kill tween and guard callback owner state. |
| Target-based kill no longer works | `SetTarget` overwrote shortcut target | Use `SetId` for grouping. |
| Sequence child link ignored | `SetLink` applied to nested tween | Link/kill the parent sequence. |
| TMP tween extension missing | TMP module disabled | Enable module/settings and compile, or use custom `DOTween.To`. |
| Compile cannot find `DG.Tweening` | asmdef reference issue | Add the correct assembly reference instead of moving code. |

## Validation Checklist

1. Run or inspect code path that creates the tween.
2. Trigger repeated calls rapidly and confirm old tweens do not stack accidentally.
3. Disable and destroy the owner during an active tween.
4. Test pause/time-scale behavior if UI or pause flow is involved.
5. For UI, test layout rebuild, resolution changes, and inactive/active transitions.
6. For materials, inspect whether the asset material or instance material changed.
7. For physics, test collisions and fixed-step behavior.
8. Check Unity Console for compile/runtime errors and finish with `unity-check`.
