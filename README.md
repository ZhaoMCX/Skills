# Skills

Personal Codex skills maintained as a single repository with lightweight, Matt Pocock-style skill folders.

## Layout

```text
skills/<category>/<skill-name>/
  SKILL.md
  references/
  scripts/
```

Only `SKILL.md` is required. Categories organize source files only; installed skills are copied directly into the local Codex skills directory by skill name.

## Skills

### Game

- [Game Structure](skills/game/game-structure) - Place gameplay logic into Module, Data, State, Rule, Ability, UseCase, Result, Surface, and Adapter responsibilities.

### Unity

- [Unity DOTween](skills/unity/unity-dotween) - Implement, review, and debug Unity DOTween animation safely.
- [Unity FishNet](skills/unity/unity-fishnet) - Implement, review, and debug FishNet networking.
- [Unity Odin](skills/unity/unity-odin) - Work with Odin Inspector and Sirenix Serializer.
- [Unity Steamworks.NET](skills/unity/unity-steamworks-net) - Integrate and debug Steamworks.NET in Unity.
- [Unity TapTap SDK](skills/unity/unity-taptap-sdk) - Integrate and debug TapTap SDK in Unity.

### UniApp

- [UniApp Development](skills/uniapp/uniapp-development) - Work on uni-app, uni-app x, DCloud, H5, app, and mini-program projects.

### WeChat

- [WeChat Mini Program DevTools](skills/wechat/wechat-miniprogram-devtools) - Use official WeChat DevTools CLI and miniprogram-automator workflows.

## Install

Install all skills into the local Codex skills directory:

```powershell
.\scripts\install.ps1
```

Install one category:

```powershell
.\scripts\install.ps1 -Category unity
```

Install one skill:

```powershell
.\scripts\install.ps1 -Skill game-structure
```

## Validate

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1
```

## Notes

Unity `.meta` files are intentionally excluded. This repository packages Codex skills, not Unity assets.
