# 开发工作流

## 判断项目变体

1. 读取根目录 `pom.xml`：
   - Java 版本。
   - Spring Boot 版本。
   - 模块列表。
   - Shiro、MyBatis、Druid、PageHelper 版本。
2. 判断 imports 是 Jakarta（`jakarta.servlet`，Spring Boot 3/4）还是 Javax（`javax.servlet`，旧 Spring Boot 2 分支）。
3. 确认这是经典 Thymeleaf RuoYi。如果仓库有 Vue 前端和 REST Controller，按目标项目的 RuoYi-Vue 约定工作。
4. 编辑前读取本地定制：
   - `application.yml`、`application-druid.yml`
   - `mybatis/mybatis-config.xml`
   - `templates/include.html`
   - `static/ruoyi/js/ry-ui.js`
   - `ruoyi-generator/src/main/resources/vm/**`

## 新增 CRUD

表驱动 CRUD 优先使用内置代码生成器。

清单：

- 创建或检查表 SQL；表注释、字段注释要完整，因为生成器会读取它们。
- 通过代码生成器导入表，或按生成器输出模式手写。
- 设置包名、模块名、业务名、功能名、作者、模板类型、上级菜单、字典、查询方式、是否生成详情页。
- 应用前审阅生成的 Java、XML、HTML 和菜单 SQL。
- 按项目已有模块和包结构放置文件。
- 应用菜单 SQL；如果数据库变更不在当前范围，明确说明。

手写 CRUD 清单：

- 需要审计字段、搜索参数、时间范围或数据权限时，Domain 继承 `BaseEntity`。
- 添加 validation 注解；需要导入导出时添加 `@Excel`。
- 添加 mapper 接口和 XML，XML 中使用显式 `resultMap`。
- 添加 service 接口和实现；多表写入加 `@Transactional`。
- 添加继承 `BaseController` 的 controller。
- 在 `ruoyi-admin/src/main/resources/templates/<module>/<business>/` 添加页面。
- 添加菜单和按钮权限，匹配 `module:business:view/list/add/edit/remove/export`。
- 前端使用字典时，补齐对应字典数据。

## 修改既有功能

先读取整条纵切：

- Controller 的 page/list/add/edit/remove/export 方法。
- Service 接口和实现。
- Mapper 接口和 XML。
- Domain 字段和校验。
- list/add/edit/detail 模板。
- 菜单权限字符串和字典类型。
- 相关 SQL 表结构、索引、种子数据。

除非正在做权限迁移，否则保持权限字符串稳定。只改后端权限名而不改菜单/按钮数据，会导致按钮消失或接口鉴权失败。

## 数据与 Schema

- SQL 变更沿用 `sql/` 目录约定。
- 既有软删表保留删除标记和正常/停用状态值。
- 常用列表筛选字段新增索引。
- Java 属性名、XML 列名、表单字段名保持一致。
- 树形数据先看部门/菜单模式、`Ztree`、parent/ancestors 字段和生成器树模板。

## 前端验证

列表页检查：

- 搜索表单字段和 Mapper XML 期望一致。
- bootstrap-table 收到 `{ code: 0, rows, total }`。
- 工具栏按钮由权限隐藏，并由 `single` / `multiple` class 随选中状态启禁。
- 新增/编辑弹窗提交到正确 URL。
- 导入/导出 URL 配置正确。
- 字典标签能正常渲染。
- `dept.deptName` 等嵌套字段确实存在于返回行数据。

表单页检查：

- `name` 属性匹配领域字段。
- 前端必填校验和后端 validation 一致。
- 编辑页包含隐藏 ID。
- 树选择和文件上传写入预期隐藏值。

## 验证命令

使用目标仓库已有命令。常见命令：

```powershell
mvn clean package -DskipTests
mvn -pl ruoyi-admin -am package -DskipTests
mvn -pl ruoyi-admin -am spring-boot:run
```

无法访问数据库时，至少编译并对照 SQL 检查 Mapper XML。如果本地 MySQL 已配置，初始化 `sql/ry_*.sql` 和 `sql/quartz.sql`，再冒烟测试登录和受影响页面。

## 评审清单

- 后端路由和前端按钮都具备权限控制。
- 数据权限注解中的别名和 Mapper XML 别名一致。
- 写操作按既有风格设置 `createBy` / `updateBy`。
- 多表写入有事务。
- Mapper XML 对用户输入使用 `#{}`，没有危险 `${}`。
- 分页只作用于目标列表查询。
- 表格和操作响应符合 `ry-ui.js` 预期。
- 导入导出使用 `ExcelUtil` 和正确注解。
- 敏感字段不会被日志记录或 JSON 序列化。
- 文件上传下载路径受限。
- Quartz invoke target 仍有白名单和校验。
- Javax/Jakarta imports 与分支一致。
