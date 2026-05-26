# Changelog

## Unreleased

### Changed

- Rebuilt the repository as a single `Skills` collection with two-level `skills/<category>/<skill>` organization.
- Removed legacy workflow packages, generated repository publishing scripts, and optional Codex UI metadata files.
- Exposed game, Unity, UniApp, and WeChat skills in the two-level structure.
- Moved all RuoYi-family skills under `skills/ruoyi/` so the framework variants are maintained as one product family.
- Added routine sync scripts for both directions: repository to global skills and global skills back to this repository.

### 新增

- Added `server-operation-guardrails`，用于 SSH、生产/测试服务器、Nginx/TLS、数据库、防火墙、部署等远程操作的安全护栏。
- Added `ruoyi-framework`，用于经典若依单体项目，覆盖 Spring Boot、Shiro、Thymeleaf、MyBatis XML、Druid、Quartz 和 Velocity 代码生成。
- Added `ruoyi-vue`，用于若依前后端分离 Vue2 项目族，覆盖 Spring Security/JWT 后端和 Vue2/Element UI 前端。
- Added `ruoyi-vue3`，用于若依 Vue3 独立前端项目，覆盖 Vite、Element Plus、Pinia、动态路由和权限指令。
- Added `ruoyi-cloud`，用于若依微服务项目族，覆盖 Gateway、Auth、Nacos、Feign、Redis、Sentinel、Seata 和多模块服务。
- Added `ruoyi-app`，用于若依移动端 App 模板，覆盖 uni-app Vue2、token 登录、请求封装、导航拦截和后端对接。
