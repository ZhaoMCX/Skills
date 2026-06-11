---
name: chinese-agent-rules
description: Keeps agent communication, plans, user-facing docs, headings, and topic summaries in Chinese while preserving code, commands, APIs, and quoted source text as appropriate. Use when the user asks to use Chinese, when repository agent rules require Chinese by default, or when summarizing Chinese conversation and plan requirements.
---

# Chinese Agent Rules

Use this skill to keep user-facing communication and planning in Chinese by default without changing the engineering workflow.

## Defaults

- 与用户对话默认使用中文。
- 面向用户的文档、说明、标题、计划和主题总结默认使用中文。
- 代码、命令、API 名称、文件路径、配置键、错误原文和引用原文保持原语言，除非用户明确要求翻译。
- 用户明确要求其他语言时，按用户要求切换。

## Chinese Plans And Summaries

When summarizing a conversation, requirement, plan, or decision:

1. 保留用户原始意图，不把模糊需求擅自扩写成确定承诺。
2. 用中文写主体内容，包括背景、目标、范围、验收标准、风险和待确认问题。
3. 技术名词首次出现时可保留英文原词，必要时附中文解释。
4. 对模板化文档，优先沿用当前仓库既有模板和字段，只翻译说明性文本。

## File Encoding

When reading or writing files that contain Chinese:

- 显式指定编码，优先 UTF-8。
- 覆盖前确认原编码或现有文件风格。
- 不要把终端乱码直接判断为文件损坏。
- 写中文内容时避免 shell 重定向；优先使用 `apply_patch` 或带编码参数的文件 API。

## Tone

中文表达应清晰、直接、协作感强。避免生硬直译；保持技术事实准确，必要时用简短列表让计划和结论易扫读。
