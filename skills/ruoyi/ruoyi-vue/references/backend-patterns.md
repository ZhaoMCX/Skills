# 后端模式

## REST Controller

RuoYi-Vue 后端控制器使用 `@RestController`，不返回 Thymeleaf 页面。

典型结构：

```java
@RestController
@RequestMapping("/system/user")
public class SysUserController extends BaseController
{
    @PreAuthorize("@ss.hasPermi('system:user:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysUser user)
    {
        startPage();
        List<SysUser> list = userService.selectUserList(user);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('system:user:add')")
    @Log(title = "用户管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SysUser user)
    {
        return toAjax(userService.insertUser(user));
    }
}
```

常见 HTTP 约定：

- 列表：`GET /list` + query params。
- 详情：`GET /{id}`。
- 新增：`POST` + `@RequestBody`。
- 修改：`PUT` + `@RequestBody`。
- 删除：`DELETE /{ids}`。
- 导出：`POST /export`，直接写 `HttpServletResponse`。

## Spring Security 与 Token

`SecurityConfig`：

- 禁用 CSRF，因为前后端分离且无 session。
- 使用 `SessionCreationPolicy.STATELESS`。
- 放行 `/login`、`/register`、`/captchaImage`、静态资源、Swagger/Druid 等。
- 添加 `JwtAuthenticationTokenFilter`。
- 使用 `BCryptPasswordEncoder`。

`TokenService`：

- 登录时生成 UUID token，写入 JWT claim。
- 登录用户信息缓存在 Redis，key 通常是 `login_tokens:<uuid>`。
- 请求时从 header 取 Bearer token，解析 UUID，再从 Redis 取 `LoginUser`。
- token 接近过期时刷新 Redis 有效期。

规则：

- 不要把用户权限只放 JWT；权限和用户态要跟 Redis 中 `LoginUser` 保持一致。
- 修改角色权限后注意刷新在线用户权限或清理相关缓存。
- 自定义匿名接口优先用项目现有 `@Anonymous` / permitAll 机制，不要放宽全局鉴权。

## 权限

后端用：

```java
@PreAuthorize("@ss.hasPermi('system:user:list')")
```

`@ss` 通常是 `PermissionService`。前端按钮权限字符串必须与后端、菜单 SQL 的 `perms` 一致。

用户、角色、部门等数据变更要保留：

- `checkUserAllowed`
- `checkUserDataScope`
- `checkRoleDataScope`
- `checkDeptDataScope`

## 数据权限与 MyBatis

数据权限仍通过 `@DataScope` AOP 写入 `BaseEntity.params.dataScope`，Mapper XML 通过 `${params.dataScope}` 接入。别名必须匹配查询 SQL。

MyBatis 规则：

- 用户输入使用 `#{}`。
- `${}` 只允许受控片段，如 AOP 数据权限和已清洗排序字段。
- Mapper 接口、XML id、service 调用同步。
- `resultMap` 显式映射列和属性。

## Excel 与文件

导出通常是：

```java
ExcelUtil<SysUser> util = new ExcelUtil<>(SysUser.class);
util.exportExcel(response, list, "用户数据");
```

前端通过全局 `download` 插件下载 blob。新增导出时不要返回旧版 `AjaxResult` 文件名模式。

上传使用 `/common/upload`、`/common/uploads` 或具体业务接口。保留扩展名、大小、路径校验。

## 代码生成器

`ruoyi-generator` 同时包含：

- `vm/java/**`
- `vm/xml/**`
- `vm/js/api.js.vm`
- `vm/vue/**`
- `vm/vue/v3/**`
- `vm/vue/v3ts/**`
- `vm/ts/**`

生成 Vue2 页面时优先遵循 `vm/vue/index.vue.vm`、`index-tree.vue.vm`、`view.vue.vm` 和 `vm/js/api.js.vm`。如果目标是独立 Vue3 前端，则转到 `ruoyi-vue3` 技能。
