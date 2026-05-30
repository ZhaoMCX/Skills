---
name: unity-odin
description: Odin Inspector and Sirenix Serializer workflow for this Unity project. Use when implementing, reviewing, debugging, or refactoring Odin attributes, SerializedMonoBehaviour/SerializedScriptableObject data, Odin editor windows, OdinMenuEditorWindow tools, custom Odin drawers, AttributeProcessors, ValueResolver/ActionResolver usage, table/list inspectors, asset selectors, validation attributes, or Sirenix asmdef/API integration.
---

# Odin

## Overview

Use Odin Inspector as the default inspector-authoring and editor-tooling layer when a Unity workflow needs richer serialized data editing, clean ScriptableObject inspectors, editor windows, menu-tree tools, or custom drawers in this project.

The project installs Sirenix under `Assets/Plugins/Sirenix`. Treat those local files as the source of truth before relying on memory or external docs.

## Read First

Before adding or changing Odin behavior:

1. Inspect the target runtime/editor script and any asmdef that must reference Sirenix.
2. Check local XML docs for exact API names:
   - `Assets/Plugins/Sirenix/Assemblies/Sirenix.OdinInspector.Attributes.xml`
   - `Assets/Plugins/Sirenix/Assemblies/Sirenix.OdinInspector.Editor.xml`
   - `Assets/Plugins/Sirenix/Assemblies/Sirenix.Serialization.xml`
   - `Assets/Plugins/Sirenix/Assemblies/Sirenix.Utilities.Editor.xml`
3. Inspect relevant demos under `Assets/Plugins/Sirenix/Demos`, especially when writing drawers, AttributeProcessors, or editor windows.
4. Read `references/quick-reference.md` for attribute choices, serialization rules, editor extension patterns, and local demo path map.

## Implementation Workflow

1. Decide the smallest Odin feature that solves the problem:
   - Inspector layout only: attributes on fields/properties/methods.
   - Persistence of non-Unity data: Odin serialized base class plus `[OdinSerialize]`.
   - Reusable data editor: `SerializedScriptableObject` assets with layout and validation attributes.
   - Custom rendering: `OdinValueDrawer<T>`, `OdinAttributeDrawer<TAttribute, TValue>`, or `OdinGroupDrawer<TGroup>`.
   - Global/conditional attribute injection: `OdinAttributeProcessor<T>`.
   - Tool window: `OdinEditorWindow` or `OdinMenuEditorWindow`.
2. Keep runtime and editor code separated:
   - Runtime inspectors and serialization use `using Sirenix.OdinInspector;`.
   - Editor drawers/windows/processors use `using Sirenix.OdinInspector.Editor;` and live in an `Editor` folder or `#if UNITY_EDITOR`.
   - GUI helper code commonly uses `Sirenix.Utilities.Editor`.
3. Preserve data semantics:
   - `[ShowInInspector]` displays a member; it does not serialize it.
   - Use `SerializedMonoBehaviour`, `SerializedScriptableObject`, `SerializedComponent`, or related Sirenix bases before relying on Odin serialization.
   - Use `[OdinSerialize]` intentionally for dictionaries, interface fields, polymorphic data, and private members that Unity cannot serialize.
4. Prefer declarative attributes over custom drawers until a drawer removes real complexity.
5. When writing custom drawers, handle multi-object editing through Odin APIs (`ValueEntry`, `Property`, `Property.Tree`) instead of direct target-object reflection where possible.
6. Validate with Unity compilation and Console checks after edits. Finish with the repository `unity-check` completion gate.

## Project Rules

- Do not edit vendor files under `Assets/Plugins/Sirenix` unless the user explicitly asks to patch the plugin or demos.
- Do not place `UnityEditor`, Odin editor drawers, editor windows, or `Sirenix.OdinInspector.Editor` references in runtime-only assemblies.
- Use local demo code as the preferred pattern source:
  - Custom drawers: `Assets/Plugins/Sirenix/Demos/Custom Drawers/Scripts`
  - AttributeProcessors: `Assets/Plugins/Sirenix/Demos/Custom Attribute Processors/Scripts`
  - Editor windows: `Assets/Plugins/Sirenix/Demos/Editor Windows/Scripts/Editor`
  - Data editor sample: `Assets/Plugins/Sirenix/Demos/Sample - RPG Editor/Scripts`
- If an asmdef cannot see Odin, add explicit references deliberately; do not move scripts to avoid the reference problem.
- For IL2CPP/linker-sensitive changes, preserve the existing Sirenix linker policy in `Assets/Plugins/Sirenix/Assemblies/link.xml`.
- Check `Assets/Plugins/Sirenix/Odin Inspector/Config/Editor/InspectorConfig.asset` and `GeneralDrawerConfig.asset` before changing global Odin behavior.
