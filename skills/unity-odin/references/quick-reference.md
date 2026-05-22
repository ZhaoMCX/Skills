# Odin Quick Reference

## Local Source Map

- Vendor root: `Assets/Plugins/Sirenix`
- DLLs: `Assets/Plugins/Sirenix/Assemblies`
- Runtime/no-editor DLL variants: `Assets/Plugins/Sirenix/Assemblies/NoEditor` and `NoEmitAndNoEditor`
- XML docs:
  - `Sirenix.OdinInspector.Attributes.xml`
  - `Sirenix.OdinInspector.Editor.xml`
  - `Sirenix.Serialization.xml`
  - `Sirenix.Utilities.xml`
  - `Sirenix.Utilities.Editor.xml`
- Linker config: `Assets/Plugins/Sirenix/Assemblies/link.xml`
- Editor config:
  - `Assets/Plugins/Sirenix/Odin Inspector/Config/Editor/InspectorConfig.asset`
  - `Assets/Plugins/Sirenix/Odin Inspector/Config/Editor/GeneralDrawerConfig.asset`
- Unity.Mathematics module: `Assets/Plugins/Sirenix/Odin Inspector/Modules/Unity.Mathematics`
- Demos:
  - `Assets/Plugins/Sirenix/Demos/Custom Attribute Processors`
  - `Assets/Plugins/Sirenix/Demos/Custom Drawers`
  - `Assets/Plugins/Sirenix/Demos/Editor Windows`
  - `Assets/Plugins/Sirenix/Demos/Sample - RPG Editor`

Observed local config:

- `InspectorConfig.asset` has Odin enabled in inspector and mouse-move processing enabled.
- `GeneralDrawerConfig.asset` has UI Toolkit support enabled, new object selector enabled, base type shown, and old Unity object/preview/type/polymorphic fields disabled.
- `link.xml` preserves `Sirenix.OdinInspector.Attributes`, `Sirenix.Serialization.Config`, `Sirenix.Serialization`, and `Sirenix.Utilities`.

## Attribute Choice By Goal

Layout and grouping:

- `Title`, `TitleGroup`, `BoxGroup`, `FoldoutGroup`, `ToggleGroup`, `TabGroup`
- `HorizontalGroup`, `VerticalGroup`, `ButtonGroup`, `ResponsiveButtonGroup`
- `PropertyOrder`, `PropertySpace`, `LabelText`, `LabelWidth`, `HideLabel`, `SuffixLabel`, `Indent`
- `InlineProperty`, `InlineEditor`, `PreviewField`

Visibility and editability:

- `ShowInInspector`, `HideInInspector`, `DisplayAsString`, `ReadOnly`, `EnableGUI`
- `ShowIf`, `HideIf`, `EnableIf`, `DisableIf`
- Prefab/play-mode variants: `ShowIn`, `HideIn`, `EnableIn`, `DisableIn`, `DisallowModificationsIn`, `RequiredIn`
- Play/editor shortcuts: `ShowInEditorMode`, `HideInPlayMode`, `DisableInPlayMode`, etc.

Validation and guidance:

- `Required`, `ValidateInput`, `InfoBox`, `DetailedInfoBox`, `TypeInfoBox`
- `MinValue`, `MaxValue`, `PropertyRange`, `MinMaxSlider`, `ProgressBar`
- `DontValidate`, `Optional`

Collections and data selection:

- `ListDrawerSettings`, `TableList`, `TableMatrix`, `Searchable`
- `ValueDropdown`, `AssetSelector`, `AssetList`
- `AssetsOnly`, `SceneObjectsOnly`, `ChildGameObjectsOnly`
- `FilePath`, `FolderPath`

Methods and callbacks:

- `Button`, `InlineButton`, `CustomContextMenu`
- `OnValueChanged`, `OnCollectionChanged`
- `OnInspectorInit`, `OnInspectorGUI`, `OnInspectorDispose`, `OnStateUpdate`

Visual polish:

- `GUIColor`, `ColorPalette`, `EnumToggleButtons`, `EnumPaging`, `ToggleLeft`, `Wrap`
- `HideMonoScript`, `DisableContextMenu`, `HideReferenceObjectPicker`, `HideDuplicateReferenceBox`

Important rule: `[ShowInInspector]` only draws a member. It does not serialize or persist the value.

## Serialization

Use Sirenix serialization when Unity serialization is not enough:

- `SerializedMonoBehaviour`
- `SerializedScriptableObject`
- `SerializedComponent`
- `SerializedBehaviour`
- `SerializedStateMachineBehaviour`

Use `[OdinSerialize]` for private members, dictionaries, interface fields, polymorphic graphs, and other data Unity does not serialize. Keep ordinary Unity-serialized fields as plain public fields or `[SerializeField] private` when Odin serialization is not needed.

Common pitfalls:

- Do not expect properties or `[ShowInInspector]` members to persist unless they are actually serialized.
- Do not put mutable runtime-only caches into Odin serialized fields.
- Be careful with Unity object references inside polymorphic graphs; verify prefab and asset behavior in Unity.
- If a type is serialized by Odin and drawn by Odin, prefer explicit labels and validation so the inspector exposes intent.

Demo references:

- Dictionaries: `Demos/Custom Attribute Processors/Scripts/CustomizeDictionaryKeyValueExample.cs`
- ScriptableObject data editor: `Demos/Sample - RPG Editor/Scripts/Character/Character.cs`
- Item data layout: `Demos/Sample - RPG Editor/Scripts/Items/Item.cs`

## Custom Drawers

Choose the drawer base by intent:

- `OdinValueDrawer<T>`: custom rendering for a value type or class.
- `OdinAttributeDrawer<TAttribute>`: custom behavior driven by an attribute, with flexible value type.
- `OdinAttributeDrawer<TAttribute, TValue>`: attribute drawer for a specific value type.
- `OdinGroupDrawer<TGroupAttribute>`: custom group rendering.
- `IDefinesGenericMenuItems`: add context-menu entries to a property.

Core drawer APIs:

- Override `Initialize()` for resolver setup and cached lookups.
- Override `DrawPropertyLayout(GUIContent label)` for IMGUI layout.
- Use `CallNextDrawer(label)` when extending default drawing.
- Use `ValueEntry.SmartValue` for typed single-value access.
- Use `ValueEntry.WeakValues` or `WeakSmartValue` when the type is dynamic or multi-selection matters.
- Use `Property.Children[i].Draw(...)` to draw child members explicitly.
- Use `Property.Tree.DelayActionUntilRepaint(...)` for mutations that should wait until repaint.
- Use `SirenixEditorGUI`, `SirenixEditorFields`, `GUIHelper`, and Unity `EditorGUILayout` for editor UI.

Demo references:

- Basic type drawer: `Demos/Custom Drawers/Scripts/CustomDrawerExample.cs`
- Attribute drawer: `Demos/Custom Drawers/Scripts/HealthBarExample.cs`
- Group drawer: `Demos/Custom Drawers/Scripts/CustomGroupExample.cs`
- Generic drawers: `Demos/Custom Drawers/Scripts/GenericDrawerExample.cs`
- Context menu: `Demos/Custom Drawers/Scripts/GenericMenuExample.cs`
- Drawer priority: `Demos/Custom Drawers/Scripts/PriorityExamples.cs`
- Resolver-based drawer strings: `Demos/Custom Drawers/Scripts/ValueAndActionResolversExample.cs`
- Validation example: `Demos/Custom Drawers/Scripts/ValidationExample.cs`
- Production-like custom value drawer: `Demos/Sample - RPG Editor/Scripts/Misc/StatList.cs`
- Item preview drawer: `Demos/Sample - RPG Editor/Scripts/Editor/ItemDrawer.cs`

## AttributeProcessors

Use `OdinAttributeProcessor<T>` when attributes should be added, removed, or rewritten without decorating every member by hand.

Core methods:

- `CanProcessSelfAttributes(InspectorProperty property)`
- `ProcessSelfAttributes(InspectorProperty property, List<Attribute> attributes)`
- `CanProcessChildMemberAttributes(InspectorProperty parentProperty, MemberInfo member)`
- `ProcessChildMemberAttributes(InspectorProperty parentProperty, MemberInfo member, List<Attribute> attributes)`

Control behavior:

- Use `[ResolverPriority(n)]` when several processors can touch the same type.
- Use `[OdinDontRegister]` for a processor that should only be used by a custom `OdinAttributeProcessorLocator`.
- Avoid broad processors for common Unity/Sirenix types unless the target scope is explicit.

Demo references:

- Basic self and child attributes: `Demos/Custom Attribute Processors/Scripts/BasicAttributeProcessorExample.cs`
- List-item-only processing: `AttributeProcessorForListItemsExample.cs`
- Processor priority: `AttributeProcessorPriorityExample.cs`
- Custom locator: `CustomAttributeProcessorLocatorExample.cs`
- Dictionary key/value customization: `CustomizeDictionaryKeyValueExample.cs`
- Add attributes to external types: `PutAttributesOnAnyType.cs`
- Inheritance/tab grouping: `TabGroupByDeclaringType.cs`
- Unity.Mathematics matrix processors: `Odin Inspector/Modules/Unity.Mathematics/MathematicsDrawers.cs`

## ValueResolver And ActionResolver

Use resolvers when a custom attribute should accept Odin resolved strings:

- Method/member reference such as `"OnClick"` or `"$MemberReferenceValue"`
- Expression string such as `"@UnityEngine.Debug.Log(DateTime.Now.ToString())"`

Editor namespaces:

- `Sirenix.OdinInspector.Editor.ValueResolvers`
- `Sirenix.OdinInspector.Editor.ActionResolvers`

Pattern:

- Create the resolver in `Initialize()`.
- In drawing, call `DrawError()` when `HasError` is true.
- Use `ActionResolver.DoActionForAllSelectionIndices()` for multi-selection-safe actions.
- Use `ValueResolver<T>.GetValue()` for the resolved value.

Demo reference: `Demos/Custom Drawers/Scripts/ValueAndActionResolversExample.cs`.

## Editor Windows

Use `OdinEditorWindow` when the window primarily inspects one or more objects. Override `GetTarget()` or `GetTargets()` when needed.

Use `OdinMenuEditorWindow` for asset browsers, data editors, or tools with a left-side navigation tree. Override `BuildMenuTree()` and return an `OdinMenuTree`.

Useful menu-tree APIs seen in local demos:

- `new OdinMenuTree(supportsMultiSelect: true)`
- `tree.Config.DrawSearchToolbar = true`
- `tree.Add(path, objectOrContent)`
- `tree.AddAllAssetsAtPath(menuPath, assetPath, type, includeSubDirectories, flattenSubDirectories)`
- `tree.AddAssetAtPath(menuPath, assetPath)`
- `tree.EnumerateTree()`
- `tree.SortMenuItemsByName()`
- `tree.MenuItems.Insert(...)`
- `TrySelectMenuItemWithObject(obj)`
- Override `OnBeginDrawEditors()` for toolbar/header controls.

Demo references:

- Basic window: `Demos/Editor Windows/Scripts/Editor/BasicOdinEditorExampleWindow.cs`
- Menu-tree window: `Demos/Editor Windows/Scripts/Editor/OdinMenuEditorWindowExample.cs`
- Menu styling: `Demos/Editor Windows/Scripts/Editor/OdinMenuStyleExample.cs`
- Multi-target inspection: `Demos/Editor Windows/Scripts/Editor/OverrideGetTargetsExampleWindow.cs`
- Object inspection helpers: `Demos/Editor Windows/Scripts/Editor/QuicklyInspectObjects.cs`
- Texture tool: `Demos/Editor Windows/Scripts/Editor/SomeTextureToolWindow.cs`
- RPG editor: `Demos/Sample - RPG Editor/Scripts/Editor/RPGEditorWindow.cs`

## RPG Demo Lessons

The RPG demo is the best local example for real data-authoring workflows:

- `Item.cs` combines `PreviewField`, nested groups, `ValueDropdown`, and `ValidateInput` for author-friendly ScriptableObject editing.
- `Character.cs` uses `SerializedScriptableObject` for richer character data.
- `CharacterOverview.cs` and `CharacterTable.cs` show table-style overview editing.
- `RPGEditorWindow.cs` builds an asset menu tree, adds search, draws a toolbar, creates assets, selects new assets, adds icons, and adds drag handles.
- `ScriptableObjectCreator.cs` implements a reusable ScriptableObject creation dialog.
- `ItemDrawer.cs`, `ItemSlotCellDrawer.cs`, and `StatList.cs` show editor custom drawing tailored to game data.

When building a project-specific Odin editor, copy the architecture, not the exact demo paths or mythology-themed sample data.

## Unity.Mathematics Module

The installed module provides drawers and processors for `bool2/3/4`, `float2/3/4`, `double2/3/4`, `int2/3/4`, `uint2/3/4`, and matrix types. It uses an asmdef at:

`Assets/Plugins/Sirenix/Odin Inspector/Modules/Unity.Mathematics/Sirenix.OdinInspector.Modules.UnityMathematics.asmdef`

Do not reimplement these drawers unless the module is missing or a project-specific behavior is explicitly needed.
