# Skills

[English](README.en.md)

个人 Codex 技能仓库，使用轻量级的 Matt Pocock 风格技能目录统一维护。

推荐参考：[mattpocock/skills](https://github.com/mattpocock/skills)，一个适合参考轻量级 Agent 技能结构与工作流的实践示例库。

## 目录结构

```text
skills/<category>/<skill-name>/
skills/<category>/<group>/<skill-name>/
  SKILL.md
  references/
  scripts/
```

只有 `SKILL.md` 是必需的。分类目录和可选分组目录只用于组织仓库源码；安装时技能会按技能名直接复制到本地 Codex 全局技能目录。

## 技能

### Agents

- [Matt Pocock Agent Workflow](skills/agents/matt-pocock-agent-workflow) - 路由 PRD、issue、triage、实现、诊断、TDD、架构和领域文档工作流，并维护 issue tracker 记录卫生。
- [Chinese Agent Rules](skills/agents/chinese-agent-rules) - 默认用中文处理 Agent 对话、计划、用户文档、标题和主题总结。

### Dev

- [Git Commit](skills/dev/git-commit) - 指导原子化 Git 提交、暂存检查、提交信息规范、确认模板和小步提交模式。

### Game

- [Game Structure](skills/game/game-structure) - 将玩法逻辑放入 Module、Data、State、Rule、Ability、UseCase、Result、Surface 和 Adapter 等职责边界。

#### Unity

- [Unity DOTween](skills/game/unity/unity-dotween) - 安全地实现、审查和调试生命周期清晰的 Unity DOTween 动画，并提供常用模式和检查清单。
- [Unity FishNet](skills/game/unity/unity-fishnet) - 基于本地包和源码检查实现、审查和调试 FishNet 网络功能，覆盖权限、SyncType 和生命周期模式。
- [Unity Odin](skills/game/unity/unity-odin) - 使用 Odin Inspector 和 Sirenix Serializer，并保持运行时/编辑器边界、常用模式和审查检查。
- [Unity Steamworks.NET](skills/game/unity/unity-steamworks-net) - 在 Unity 中集成和调试 Steamworks.NET 生命周期、回调、原生库和服务边界。
- [Unity TapTap SDK](skills/game/unity/unity-taptap-sdk) - 在 Unity 中集成和调试 TapTap SDK 模块、平台配置、PC 校验、合规、IAP、迁移和发布检查清单。

### Ops

- [Server Operation Guardrails](skills/ops/server-operation-guardrails) - 为远程服务器读检查、确认变更、备份、密钥、TLS、回滚和验证应用安全规则。

### Web

#### RuoYi

- [RuoYi Framework](skills/web/ruoyi/ruoyi-framework) - 处理经典若依单体项目，覆盖 Spring Boot、Shiro、Thymeleaf、MyBatis XML、Druid、Quartz 和内置代码生成器。
- [RuoYi Vue](skills/web/ruoyi/ruoyi-vue) - 处理若依前后端分离 Vue2 项目族，覆盖 Spring Security/JWT 后端和 Vue2/Element UI 前端。
- [RuoYi Vue3](skills/web/ruoyi/ruoyi-vue3) - 处理若依 Vue3 独立前端项目，覆盖 Vite、Element Plus、Pinia、动态路由和权限指令。
- [RuoYi Cloud](skills/web/ruoyi/ruoyi-cloud) - 处理若依微服务项目族，覆盖 Gateway、Auth、Nacos、Feign、Redis、Sentinel、Seata 和多模块服务。
- [RuoYi App](skills/web/ruoyi/ruoyi-app) - 处理若依移动端 App 模板，覆盖 uni-app Vue2、token 登录、请求封装、导航拦截和后端对接。

#### Spring

- [Spring Boot](skills/web/spring/spring-boot) - 处理 Spring Boot 应用、配置、starter、自动配置、Actuator、测试、打包和生产就绪工作。
- [Spring Cloud](skills/web/spring/spring-cloud) - 处理 Spring Cloud 微服务、Gateway、Config、OpenFeign、LoadBalancer、熔断、消息流、契约和分布式集成。
- [Spring Data](skills/web/spring/spring-data) - 处理 Spring Data 仓库和持久化，覆盖 JPA、JDBC、R2DBC、Redis、MongoDB、Elasticsearch、Neo4j、分页、审计和投影。
- [Spring Security](skills/web/spring/spring-security) - 处理 Spring Security 认证、授权、CSRF、会话、OAuth2、JWT 资源服务、方法安全、密码和测试。

#### UniApp

- [UniApp Development](skills/web/uniapp/uniapp-development) - 处理 uni-app、uni-app x、DCloud、H5、App 和小程序项目。

#### WeChat

- [WeChat Mini Program DevTools](skills/web/wechat/wechat-miniprogram-devtools) - 使用官方微信开发者工具 CLI、项目本地 automator API、生成的 mp-weixin 输出和预览/上传安全流程。

## 同步

使用这些脚本处理两个常见同步方向。

将仓库技能同步到本地 Codex 全局技能目录：

```powershell
.\scripts\sync-to-global.ps1
```

将全局技能同步回本仓库中已经存在的技能：

```powershell
.\scripts\sync-from-global.ps1
```

`sync-from-global.ps1` 默认跳过 Agent 专属的 `agents/` 元数据，让仓库保持跨 Agent 可用。只有当某个技能有意保存 Agent 专属 UI 元数据时，才传入 `-IncludeAgentMetadata`。

同步一个分类：

```powershell
.\scripts\sync-to-global.ps1 -Category game
.\scripts\sync-from-global.ps1 -Category game
.\scripts\sync-to-global.ps1 -Category web
.\scripts\sync-from-global.ps1 -Category web
```

同步一个技能：

```powershell
.\scripts\sync-to-global.ps1 -Skill game-structure
.\scripts\sync-from-global.ps1 -Skill game-structure
```

## 安装

安装所有技能到本地 Codex 技能目录：

```powershell
.\scripts\install.ps1
```

安装一个分类：

```powershell
.\scripts\install.ps1 -Category game
.\scripts\install.ps1 -Category web
```

安装一个技能：

```powershell
.\scripts\install.ps1 -Skill game-structure
```

`install.ps1` 保留为“仓库同步到全局技能目录”的向后兼容名称。日常新用法优先使用 `sync-to-global.ps1`。

## 校验

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1
```

校验会强制检查技能名、frontmatter、包含 `Use when` 的两句式 description、`SKILL.md` 行数、引用文件、README 链接和生成文件排除。

## 备注

Unity `.meta` 文件会被有意排除。本仓库打包的是 Codex 技能，不是 Unity 资源。
