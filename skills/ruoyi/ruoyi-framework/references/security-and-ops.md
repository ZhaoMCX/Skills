# 安全与运行

## Shiro

`ShiroConfig` 定义静态匿名路径、登录/注册/验证码过滤器、退出、踢人、在线会话同步、可选 CSRF 过滤器，以及兜底认证过滤链。

规则：

- 受保护页面和数据接口使用 `@RequiresPermissions`。
- 新增匿名路由前，先检查目标项目里的 `@Anonymous` 和 `PermitAllUrlProperties` 机制。
- 修改角色、菜单、权限后，使用本地工具清权限缓存，常见为 `AuthorizationUtils.clearAllCachedAuthorizationInfo()`。
- Shiro 会话和用户信息通常通过 `ShiroUtils` 或 `BaseController.getSysUser()` 获取。

RememberMe 的 `cipherKey` 未配置时可能每次启动生成随机 key；生产部署通常需要固定配置。

## CSRF 与 XSS

`application.yml` 中有 `csrf.enabled` 和白名单配置。`include.html` 写入 `<meta name="csrf-token">`；`ry-ui.js` 在助手 Ajax 中附加 `X-CSRF-Token`。

规则：

- 优先用 `$.operate` 等若依 Ajax 助手，让 CSRF 请求头自动生效。
- 自写 Ajax 时先读本地 `ry-ui.js`，同步它的 CSRF 处理。
- 会回显到页面的文本字段使用 `@Xss`、Bean Validation 和既有转义工具。
- 除非内容已明确净化，不要用 Thymeleaf 非转义输出渲染用户 HTML。

## MyBatis 注入边界

`#{}` 是参数绑定，`${}` 是文本替换，不能接收原始用户输入。

已知受控替换：

- `DataScopeAspect` 清空并写入后的 `${params.dataScope}`。
- 分页排序辅助中经过 `SqlUtil.escapeOrderBySql` 清洗的排序字符串。

新增动态排序或过滤时，使用白名单或既有工具，不要拼接 SQL。

## 文件上传下载

上传使用 `FileUploadUtils` 和 `RuoYiConfig` 的路径：

- `getUploadPath()`：`<profile>/upload`
- `getAvatarPath()`：`<profile>/avatar`
- `getImportPath()`：`<profile>/import`
- `getDownloadPath()`：`<profile>/download/`

规则：

- 使用 `MimeTypeUtils` 的允许扩展名数组，或功能专属白名单。
- 保留文件大小和文件名长度检查。
- 不要把请求中的任意路径写入磁盘。
- 下载必须经过 `FileUtils.checkAllowDownload`，并校验/剥离资源前缀。
- 上传资源的静态访问由 `ResourcesConfig` 映射到 `Constants.RESOURCE_PREFIX`。

## Quartz 调用安全

Quartz 任务允许配置方法调用，风险较高。`SysJobController` 会校验：

- Cron 表达式。
- invoke target 不含 RMI/LDAP/HTTP/HTTPS。
- 不含黑名单字符串。
- 调用目标包或 Bean 在 `Constants.JOB_WHITELIST_STR` 白名单中。

规则：

- 不要削弱 `ScheduleUtils.whiteList` 或 controller 校验。
- 新定时方法应是参数很窄的简单 service 方法。
- `JobInvokeUtil` 支持字符串、布尔、`L` 结尾 long、`D` 结尾 double 和整数参数；复杂对象不是常规调用目标。
- 明确设置 `concurrent` 和 misfire policy。

## 操作日志

`@Log` 由 `LogAspect` 处理，异步记录请求方法、URL、用户、部门、标题、业务类型、参数、结果、状态、异常和耗时。

规则：

- 管理端写操作、导入、导出添加 `@Log`。
- 额外敏感字段用 `excludeParamNames` 排除。
- 密码字段默认排除；如果新增类似密码的字段名，不要让它进入日志。

## 防重复提交

`@RepeatSubmit` 由 `RepeatSubmitInterceptor` 和 `SameUrlDataInterceptor` 执行，在 session 中按 URL 和请求参数 JSON 比较重复提交间隔。

适合用户可能双击的非幂等表单。若相同重复请求本来就是合法业务，不要添加。

## 演示模式

一些部署开启演示模式。若目标项目有演示模式注解或切面，新增写操作时不要绕过这些守卫。

## Druid 与数据源

Druid 控制台通常位于 `/druid/*`，账号密码在 `application-druid.yml`。不要提交更危险的默认配置。新增数据源时沿用 `DruidConfig` 和 `DynamicDataSourceContextHolder`，不要单独另建连接池体系。

## 异常处理

`GlobalExceptionHandler` 对 Ajax 返回 JSON，对部分非 Ajax 异常返回页面。用户可读的业务失败抛 `ServiceException`。新响应不要泄漏堆栈或原始 SQL 错误。
