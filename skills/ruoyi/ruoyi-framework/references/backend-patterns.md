# 后端模式

## Controller 模式

经典 CRUD 控制器位于 `ruoyi-admin` 或生成模块的 controller 包，使用 `@Controller` 并继承 `BaseController`。

典型结构：

```java
@Controller
@RequestMapping("/system/user")
public class SysUserController extends BaseController
{
    private String prefix = "system/user";

    @RequiresPermissions("system:user:view")
    @GetMapping()
    public String user()
    {
        return prefix + "/user";
    }

    @RequiresPermissions("system:user:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(SysUser user)
    {
        startPage();
        List<SysUser> list = userService.selectUserList(user);
        return getDataTable(list);
    }
}
```

遵守这些契约：

- 页面路由返回 `templates/<prefix>/` 下的模板名。
- Ajax 路由添加 `@ResponseBody`。
- 列表返回 `TableDataInfo`。
- 写操作返回 `AjaxResult`，通常用 `success()`、`error("...")`、`toAjax(rows)`。
- 新增/修改表单通常绑定领域对象，可加 `@Validated`。
- 编辑/详情页用 `ModelMap` 填数据。
- 重定向使用 `BaseController.redirect(url)`。

## 响应与分页

`AjaxResult` 是 `HashMap`，关键字段为：

- `code`：`0` 成功，`301` 警告，`500` 错误。
- `msg`：面向用户的消息。
- `data`：可选数据。

`TableDataInfo` 字段为：

- `code`：`ry-ui.js` 期望为 `0`。
- `rows`：列表数据。
- `total`：PageHelper 总数。

`startPage()` 必须紧贴真正要分页的 service 查询。不要在 `startPage()` 和目标列表查询之间插入其他 MyBatis 查询。只做排序时可用 `BaseController.startOrderBy()`，它会通过 `SqlUtil.escapeOrderBySql` 清洗 `orderByColumn/isAsc`。

## Service 模式

服务层拆成 `I<Name>Service` 和 `<Name>ServiceImpl`。涉及多表写入时在 service 方法上加 `@Transactional`，例如用户-角色、用户-岗位关联维护。

常见职责：

- 领域校验和业务校验。
- 唯一性检查，返回 `UserConstants.UNIQUE` / `NOT_UNIQUE` 布尔结果。
- 数据权限守卫，例如 `checkUserDataScope`、`checkRoleDataScope`、`checkDeptDataScope`。
- 审计字段：controller 通常用 `getLoginName()` 设置 `createBy` / `updateBy`。
- 修改角色、菜单、字典、参数后清理对应缓存。

如果 service 内部自调用仍需要触发 AOP，沿用本地模式 `SpringUtils.getAopProxy(this).method(...)`。

## Mapper XML 模式

Mapper 接口放在业务模块代码中，XML 放在 `src/main/resources/mapper/<module>`。

保持三处同步：

- Mapper 接口方法名。
- XML 的 `<select|insert|update|delete id="...">`。
- `parameterType`、`resultMap` 和领域类型别名。

若依通常没有开启全局下划线转驼峰，所以 `resultMap` 显式把 `user_id` 映射为 `userId`。除非目标项目 MyBatis 配置已开启，否则不要依赖隐式映射。

常用写法：

- 用 `<sql id="...">` 抽共享查询片段。
- 用 `<if test="...">` 写可选筛选。
- 用 `<foreach>` 处理 `ids` 数组。
- 自增主键使用 `useGeneratedKeys="true" keyProperty="..."`。
- 既有表如果使用状态/删除标记，删除操作应保持软删语义。

避免：

- 把用户输入放进 `${}`。
- 新查询遗漏 `del_flag`、状态、租户/部门限制或既有数据权限片段。
- 返回字段不完整，导致前端列如 `dept.deptName` 取不到值。

## 数据权限

`@DataScope` 通常加在 service 列表方法上。它读取当前 Shiro 用户和角色数据范围，然后把 SQL 片段写入 `BaseEntity.params.dataScope`。Mapper XML 追加：

```xml
${params.dataScope}
```

规则：

- 方法第一个参数必须是 `BaseEntity` 子类，AOP 才能注入数据权限。
- 设置正确 SQL 别名，例如 `@DataScope(deptAlias = "d", userAlias = "u")`。
- XML 中的表别名必须与注解一致。
- 超级管理员跳过数据过滤。
- 详情、修改、删除等按 ID 访问的动作，要调用对应 `check*DataScope(id)` 守卫。

不要信任请求里的 `params.dataScope`。AOP 会先清空再写入，但新代码不应暴露或依赖这个入参。

## 动态数据源

`DruidConfig` 创建 `masterDataSource`、可选 `slaveDataSource` 和主 `DynamicDataSource`。只有确实适合走只读库的路径，才在方法或类上使用 `@DataSource(DataSourceType.SLAVE)`。

`DataSourceAspect` 会在方法执行后清理线程变量。不要绕过既有 holder 模式手动管理数据源上下文。

## 代码生成器形态

生成器会输出：

- Domain、Mapper 接口、Service、ServiceImpl、Controller。
- Mapper XML。
- 列表、新增、编辑、详情、树形页面。
- 菜单/权限 SQL。

生成权限格式为 `module:business:action`。文件路径由 `VelocityUtils` 中的 `packageName`、`moduleName`、`businessName` 推导。修改生成结果前先看本地模板，因为很多项目会定制它们。
