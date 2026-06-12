# 前端模式

若依经典版是服务端渲染后台：Thymeleaf、Hplus 风格 Bootstrap、jQuery、bootstrap-table、zTree、layer、layui，以及 `static/ruoyi/js/ry-ui.js`。

## 模板布局

页面通常从公共片段开始：

```html
<!DOCTYPE html>
<html lang="zh" xmlns:th="http://www.thymeleaf.org" xmlns:shiro="http://www.pollix.at/thymeleaf/shiro">
<head>
    <th:block th:include="include :: header('标题')" />
</head>
<body class="gray-bg">
    ...
    <th:block th:include="include :: footer" />
</body>
</html>
```

只在需要时引入 `include.html` 的额外片段：

- `ztree-css` / `ztree-js`
- `select2-css` / `select2-js`
- `datetimepicker-css` / `datetimepicker-js`
- `layout-latest-css` / `layout-latest-js`
- `summernote-css` / `summernote-js`
- `cropper-css` / `cropper-js`
- bootstrap-table 各扩展片段。

`include :: footer` 会定义：

- `ctx = [[@{/}]]`
- 锁屏跳转逻辑。
- jQuery、Bootstrap、bootstrap-table、validate、layer、common.js、`ry-ui.js`。

## 列表页模式

标准列表页包含：

- `.search-collapse` 中的搜索表单。
- 使用 Shiro 标签隐藏按钮的工具栏。
- id 为 `bootstrap-table` 的表格。
- 内联脚本定义权限 flag、`prefix` 和 `$.table.init(options)`。

典型 JS：

```javascript
var editFlag = [[${@permission.hasPermi('system:user:edit')}]];
var removeFlag = [[${@permission.hasPermi('system:user:remove')}]];
var prefix = ctx + "system/user";

$(function() {
    var options = {
        url: prefix + "/list",
        createUrl: prefix + "/add",
        updateUrl: prefix + "/edit/{id}",
        removeUrl: prefix + "/remove",
        exportUrl: prefix + "/export",
        modalName: "用户",
        columns: [...]
    };
    $.table.init(options);
});
```

`$.table.queryParams` 会发送：

- `pageSize`
- `pageNum`
- `searchValue`
- `orderByColumn`
- `isAsc`
- 表单序列化后的所有字段。

时间范围字段在生成页中常写成 `params[beginTime]` 和 `params[endTime]`；Mapper XML 通过 `params.beginTime` 和 `params.endTime` 读取。

## 操作助手

优先使用现有助手：

- `$.table.search()`、`$.table.refresh()`、`$.table.exportExcel()`、`$.table.importExcel()`。
- `$.operate.add()`、`$.operate.addTab()`、`$.operate.edit(id)`、`$.operate.editTab(id)`、`$.operate.remove(id)`、`$.operate.removeAll()`、`$.operate.post(url, data)`、`$.operate.view(id)`。
- `$.modal.open(title, url, width, height)`、`$.modal.openTab(title, url)`、`$.modal.confirm(message, callback)`、`$.modal.msgSuccess(...)`。
- `$.form.reset()`、`$.validate.form(formId)`。
- `$.tree.init(options)`、`$.tree.getCheckedNodes(column)`。

不要随手改成一次性 Ajax 或弹窗代码，除非该页面已有明确特殊实现。这些助手处理了 CSRF 请求头、加载态、返回值分发和父标签页刷新。

## 权限

前端有两种权限写法：

```html
<a shiro:hasPermission="system:user:add">新增</a>
```

以及：

```javascript
var editFlag = [[${@permission.hasPermi('system:user:edit')}]];
actions.push('<a class="btn btn-success btn-xs ' + editFlag + '">编辑</a>');
```

`@permission.hasPermi` 返回的是 `""` 或 `"hidden"`，不是布尔值。后端 `@RequiresPermissions` 仍然必须存在；前端隐藏按钮不是安全边界。

## 字典

Thymeleaf 中用 `@dict`：

```html
<select name="status" th:with="type=${@dict.getType('sys_normal_disable')}">
    <option value="">所有</option>
    <option th:each="dict : ${type}" th:text="${dict.dictLabel}" th:value="${dict.dictValue}"></option>
</select>
```

表格列通常先声明字典数据再格式化：

```javascript
var statusDatas = [[${@dict.getType('sys_normal_disable')}]];
formatter: function(value) {
    return $.table.selectDictLabel(statusDatas, value);
}
```

确保字典类型字符串与数据库 `sys_dict_type` / `sys_dict_data` 一致。

## 表单

新增/编辑页通常使用 Bootstrap form-group 和 jQuery Validate。提交函数调用 `$.operate.save(prefix + "/add", $('#form-id').serialize())` 或目标项目已有封装。

树选择和弹窗回调：

- 先读已有 `select*Tree`、`treeData` 和 modal callback。
- 保留 controller/domain 期望的隐藏字段名。

上传：

- 除非功能有专用端点，否则使用 `/common/upload` 或 `/common/uploads`。
- 服务端返回 `url`、`fileName`、`newFileName`、`originalFilename`。

## 局部模板

控制器可能返回 Thymeleaf fragment：

```java
return prefix + "/cache::fragment-cache-names";
```

编辑这类页面时保留 fragment 名称和 Ajax 刷新目标。
