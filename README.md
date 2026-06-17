# Skills

[English](README.en.md)

作者维护的 Codex 技能库，收纳可复用的 Agent 技能、参考资料和配套脚本。

README 是本仓库的分类、状态和依赖关系说明；技能目录保持平铺，便于浏览、校验和跨 Agent 复用。

## 目录结构

```text
skills/<skill-name>/
  SKILL.md
  references/
  scripts/
```

只有 `SKILL.md` 是必需的。仓库中的技能目录必须平铺在 `skills/` 下；README 是唯一的分类与状态说明来源，文件系统目录不表达分类。

## Agent 使用方式

当 agent 需要选择技能时，先按任务类型查找“本仓库技能模块”，再检查“直接依赖关系”。如果目标技能依赖其他本仓库技能，应一并安装；如果依赖外部技能，则按“外部依赖技能”中的来源另行获取。

安装一个技能：

```powershell
.\scripts\install.ps1 -Skill web-fullstack-dev
```

常用入口：

| 任务类型 | 优先安装技能 |
| --- | --- |
| 中文对话、计划和文档输出 | [Chinese Agent Rules](skills/chinese-agent-rules) |
| Git 提交整理 | [Git Commit](skills/git-commit) |
| 远程服务器或生产环境操作 | [Server Operation Guardrails](skills/server-operation-guardrails) |
| Web-first 全栈业务开发 | [Web Fullstack Dev](skills/web-fullstack-dev) |
| Web、Vue、H5、uni-app、小程序职责边界 | [Web Structure](skills/web-structure) |
| uni-app / DCloud / 多端项目 | [UniApp Development](skills/uniapp-development) |
| 原生微信小程序与微信开发者工具 | [WeChat Mini Program DevTools](skills/wechat-miniprogram-devtools) |
| 若依项目族 | [RuoYi Framework](skills/ruoyi-framework), [RuoYi Vue](skills/ruoyi-vue), [RuoYi Vue3](skills/ruoyi-vue3), [RuoYi Cloud](skills/ruoyi-cloud), [RuoYi App](skills/ruoyi-app) |
| Spring 后端专项 | [Spring Boot](skills/spring-boot), [Spring Cloud](skills/spring-cloud), [Spring Data](skills/spring-data), [Spring Security](skills/spring-security) |
| Unity 专项 | [Unity DOTween](skills/unity-dotween), [Unity FishNet](skills/unity-fishnet), [Unity Odin](skills/unity-odin), [Unity Steamworks.NET](skills/unity-steamworks-net), [Unity TapTap SDK](skills/unity-taptap-sdk) |

## 外部依赖技能

这些技能不收纳到本仓库目录中，但会作为本仓库技能设计、编排、追问、验收和 UI/UX 判断的外部依赖来源。

### mattpocock/skills

#### Engineering

- [`diagnose`](https://github.com/mattpocock/skills/tree/main/skills/engineering/diagnose)
- [`grill-with-docs`](https://github.com/mattpocock/skills/tree/main/skills/engineering/grill-with-docs)
- [`improve-codebase-architecture`](https://github.com/mattpocock/skills/tree/main/skills/engineering/improve-codebase-architecture)
- [`prototype`](https://github.com/mattpocock/skills/tree/main/skills/engineering/prototype)
- [`setup-matt-pocock-skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/setup-matt-pocock-skills)
- [`tdd`](https://github.com/mattpocock/skills/tree/main/skills/engineering/tdd)
- [`to-issues`](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-issues)
- [`to-prd`](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-prd)
- [`triage`](https://github.com/mattpocock/skills/tree/main/skills/engineering/triage)
- [`zoom-out`](https://github.com/mattpocock/skills/tree/main/skills/engineering/zoom-out)

#### Productivity

- [`caveman`](https://github.com/mattpocock/skills/tree/main/skills/productivity/caveman)
- [`grill-me`](https://github.com/mattpocock/skills/tree/main/skills/productivity/grill-me)
- [`handoff`](https://github.com/mattpocock/skills/tree/main/skills/productivity/handoff)
- [`teach`](https://github.com/mattpocock/skills/tree/main/skills/productivity/teach)
- [`write-a-skill`](https://github.com/mattpocock/skills/tree/main/skills/productivity/write-a-skill)

#### Misc

- [`git-guardrails-claude-code`](https://github.com/mattpocock/skills/tree/main/skills/misc/git-guardrails-claude-code)
- [`migrate-to-shoehorn`](https://github.com/mattpocock/skills/tree/main/skills/misc/migrate-to-shoehorn)
- [`scaffold-exercises`](https://github.com/mattpocock/skills/tree/main/skills/misc/scaffold-exercises)
- [`setup-pre-commit`](https://github.com/mattpocock/skills/tree/main/skills/misc/setup-pre-commit)

#### Personal

- [`edit-article`](https://github.com/mattpocock/skills/tree/main/skills/personal/edit-article)
- [`obsidian-vault`](https://github.com/mattpocock/skills/tree/main/skills/personal/obsidian-vault)

### nextlevelbuilder/ui-ux-pro-max-skill

#### UI/UX

- [`ui-ux-pro-max`](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) - 用于 UI/UX 设计建议、视觉评审、颜色、字体、布局和可访问性判断。

## 本仓库技能模块

`Stable` 表示已稳定收纳、可作为常规触发入口；`In Progress` 表示已收纳但仍在磨合模型、依赖关系或编排口径。

### In Progress

- [Web Fullstack Dev](skills/web-fullstack-dev) - 处理 Web-first 全栈模块开发，覆盖 RuoYi 后端、Vue3 后台、桌面 Web/H5、原生微信小程序、共享包、OpenAPI、PRD/issues/TDD 工作流和 web-structure 职责归位。

### Stable

#### Agent 协作规则

- [Chinese Agent Rules](skills/chinese-agent-rules) - 默认用中文处理 Agent 对话、计划、用户文档、标题和主题总结。

#### 工程流程与安全

- [Git Commit](skills/git-commit) - 指导原子化 Git 提交、暂存检查、提交信息规范、确认模板和小步提交模式。
- [Server Operation Guardrails](skills/server-operation-guardrails) - 为远程服务器读检查、确认变更、备份、密钥、TLS、回滚和验证应用安全规则。

#### Web 全栈与端侧

- [Web Structure](skills/web-structure) - 判断 Web、Vue、uni-app、H5 和小程序前端业务逻辑应放在 Feature、State、Feature API、Result、Surface 或 Adapter。
- [UniApp Development](skills/uniapp-development) - 处理 uni-app、uni-app x、DCloud、H5、App 和小程序项目。
- [WeChat Mini Program DevTools](skills/wechat-miniprogram-devtools) - 使用官方微信开发者工具 CLI、项目本地 automator API、原生小程序结构、WXML/WXSS、生成的 mp-weixin 输出和预览/上传安全流程。

#### RuoYi 项目族

- [RuoYi Framework](skills/ruoyi-framework) - 处理经典若依单体项目，覆盖 Spring Boot、Shiro、Thymeleaf、MyBatis XML、Druid、Quartz 和内置代码生成器。
- [RuoYi Vue](skills/ruoyi-vue) - 处理若依前后端分离 Vue2 项目族，覆盖 Spring Security/JWT 后端和 Vue2/Element UI 前端。
- [RuoYi Vue3](skills/ruoyi-vue3) - 处理若依 Vue3 独立前端项目，覆盖 Vite、Element Plus、Pinia、动态路由和权限指令。
- [RuoYi Cloud](skills/ruoyi-cloud) - 处理若依微服务项目族，覆盖 Gateway、Auth、Nacos、Feign、Redis、Sentinel、Seata 和多模块服务。
- [RuoYi App](skills/ruoyi-app) - 处理若依移动端 App 模板，覆盖 uni-app Vue2、token 登录、请求封装、导航拦截和后端对接。

#### Spring 后端能力

- [Spring Boot](skills/spring-boot) - 处理 Spring Boot 应用、配置、starter、自动配置、Actuator、测试、打包和生产就绪工作。
- [Spring Cloud](skills/spring-cloud) - 处理 Spring Cloud 微服务、Gateway、Config、OpenFeign、LoadBalancer、熔断、消息流、契约和分布式集成。
- [Spring Data](skills/spring-data) - 处理 Spring Data 仓库和持久化，覆盖 JPA、JDBC、R2DBC、Redis、MongoDB、Elasticsearch、Neo4j、分页、审计和投影。
- [Spring Security](skills/spring-security) - 处理 Spring Security 认证、授权、CSRF、会话、OAuth2、JWT 资源服务、方法安全、密码和测试。

#### Unity 专项

- [Unity DOTween](skills/unity-dotween) - 安全地实现、审查和调试生命周期清晰的 Unity DOTween 动画，并提供常用模式和检查清单。
- [Unity FishNet](skills/unity-fishnet) - 基于本地包和源码检查实现、审查和调试 FishNet 网络功能，覆盖权限、SyncType 和生命周期模式。
- [Unity Odin](skills/unity-odin) - 使用 Odin Inspector 和 Sirenix Serializer，并保持运行时/编辑器边界、常用模式和审查检查。
- [Unity Steamworks.NET](skills/unity-steamworks-net) - 在 Unity 中集成和调试 Steamworks.NET 生命周期、回调、原生库和服务边界。
- [Unity TapTap SDK](skills/unity-taptap-sdk) - 在 Unity 中集成和调试 TapTap SDK 模块、平台配置、PC 校验、合规、IAP、迁移和发布检查清单。

## 直接依赖关系

| 技能 | 直接依赖 | 依赖用途 |
| --- | --- | --- |
| [Web Fullstack Dev](skills/web-fullstack-dev) | [Web Structure](skills/web-structure), [WeChat Mini Program DevTools](skills/wechat-miniprogram-devtools), [UniApp Development](skills/uniapp-development), [`ui-ux-pro-max`](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | 编排 PRD/issues/TDD 驱动的全栈模块开发、前端职责边界、端侧工具和 UI/UX 设计判断。 |
| [Web Structure](skills/web-structure) | [WeChat Mini Program DevTools](skills/wechat-miniprogram-devtools), [UniApp Development](skills/uniapp-development) | 定义端侧业务逻辑职责边界，但不替代小程序或 uni-app 的端侧工具。 |

## 核心协作链路

- Web 全栈：`to-prd`、`to-issues` 和 `tdd` 提供工程工作流主线；`web-fullstack-dev` 编排全栈模块交付；`web-structure` 负责前端业务职责归位。
- RuoYi / Spring：先按若依项目族识别项目，再按 Spring 专项技能处理后端能力问题。
- Unity：按动画、联网、Inspector、平台 SDK 等具体需求选择对应 Unity 专项技能。
- 运维：远程服务器、生产环境或高风险变更先走 `server-operation-guardrails`。

## 安装

安装所有技能到本地 Codex 技能目录：

```powershell
.\scripts\install.ps1
```

安装一个技能：

```powershell
.\scripts\install.ps1 -Skill unity-dotween
```

## 校验

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1
```

校验会强制检查技能名、frontmatter、非空 description、`SKILL.md` 行数、引用文件、README 链接和生成文件排除。
