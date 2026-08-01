# PCM 模板契约

## 目的

PCM 模板是一个业务无关、完全自包含、最小可运行的基础架构项目。它只完成技术选型及必要的工程配置，不实现任何客户业务或领域行为。

## 工作模式

- **模板维护模式**：目录仍属于 PCM 模板仓库时，只能修改业务无关的基础设施；不得加入客户业务或领域实现。
- **派生项目开发模式**：模板复制到独立项目后，可以根据用户已确认的需求实现业务；仍不预建未确认的业务、依赖、基础设施或空架构层。

## 登记与事实来源

PCM 不扫描目录自动发现模板。只有同时满足模板准入要求、存在于所属语言仓库默认分支，并登记在上层 `templates.yaml` 中的目录，才是正式可选模板。

管理文件的职责如下：

- `repositories.yaml`：语言仓库的稳定 ID、本地路径与默认分支。
- `templates.yaml`：正式模板的跨仓库定位。
- 模板目录的 `template.yaml`：模板自身的身份、用途、选型标签和标准命令。
- `profiles.yaml`：已确认可复用的多模板技术组合；单个模板不是 profile。
- 模板的依赖声明文件与锁文件：包管理、依赖版本和脚本实现。
- 模板 `README.md`：面向人的安装、开发、验证和部署说明。
- 模板 `AGENTS.md`：修改边界与 AI 协作规则。

上层索引和 profile 不重复模板的技术栈、依赖版本或命令。README 可以为可读性重复命令，但不得定义不同于 `template.yaml` 和依赖声明文件的命令。

## 元数据格式

### `templates.yaml`

顶层仅包含 `templates` 列表。每个正式模板条目必须且只包含：

```yaml
templates:
  - id: nextjs-shadcn-web-app
    repository: frontend
    path: templates/nextjs-shadcn-web-app
```

字段要求：

- `id`：全局唯一的小写 kebab-case 标识，必须与模板目录名和 `template.yaml` 的 `id` 一致。
- `repository`：必须引用 `repositories.yaml` 中已有的仓库 ID。
- `path`：必须是所属语言仓库内的相对路径，不得使用绝对路径或 `..`；其目录名必须等于 `id`。

不得添加 `name`、`description`、`status`、`version`、`branch`、`revision`、`stack`、`commands` 或 `profile` 等字段。分支是开发流程，技术事实属于模板自身元数据，当前不维护状态或多版本索引。

### 模板 `template.yaml`

每个模板必须包含以下最小字段：

```yaml
id: nextjs-shadcn-web-app
name: Next.js + shadcn/ui 前端模板
description: 面向独立 Web 应用起步的业务无关 Next.js App Router 模板。
tags:
  - web
commands:
  install: pnpm install
  dev: pnpm dev
  check: pnpm type-check && pnpm lint
  test: pnpm test:run
  build: pnpm build
```

字段要求：

- `id`、`name`、`description`、`tags` 和 `commands` 必填。
- `name` 描述技术和架构，不得使用业务领域命名；`description` 只说明用途与工程形态。
- `tags` 为非空的小写 kebab-case 字符串列表，只描述已实际具备的技术或能力；已安装但未接入的依赖不得作为能力标签。
- `commands.install`、`commands.dev`、`commands.check`、`commands.test`、`commands.build` 必填。存在端到端验证时可添加 `commands.e2e`，但不将端到端验证混入 `test`。
- 命令必须对应模板已有的脚本或命令，并与 README 保持一致。
- 不在 `template.yaml` 中记录仓库、登记状态、分支、提交、版本、profile、远程地址或依赖版本快照。

## 必须满足的要求

每个模板都必须：

1. 只包含架构选型和必要的基础设施配置；
2. 在模板目录被单独复制到其他位置后，仍可独立安装、启动和构建；
3. 不依赖语言仓库根目录或其他模板目录中的运行时文件；
4. 只使用一种明确的包管理方式，并保留与之匹配的唯一锁文件；
5. 需要环境变量时提供 `.env.example`；
6. 包含 `template.yaml`、`README.md` 和 `AGENTS.md`；
7. 包含能够证明基础设施正常工作的最低限度测试；
8. 修改合入 `main` 前必须完成本地验证；
9. 不得包含真实密钥、个人绝对路径和生成后的构建产物。

## 业务边界

模板不得包含：

- 用户、商品、订单、权限或其他业务模型；
- 业务页面、领域流程或行业相关示例数据；
- Todo 或类似的示例业务模块；
- 客户项目代码。

允许保留中性的基础设施内容，例如等待开发的空白页面或后端 `/health` 健康检查接口。

## 自包含要求

模板不得使用：

- 语言仓库根目录的共享包或共享配置；
- 指向同级目录的工作区依赖；
- 对其他模板的引用；
- 本地符号链接；
- 开发者机器上的私有文件。

## 模板最低文件结构

具体模板根据技术栈至少包含以下适用内容：

```text
<template-id>/
├── template.yaml
├── README.md
├── AGENTS.md
├── .gitignore
├── .env.example（按需）
├── 依赖声明文件
├── 依赖锁文件
├── 源代码
└── 基础设施测试
```

模板 ID 必须与目录名一致。模板名称应描述技术和架构，不得使用业务领域命名。

## 本地验证

每个模板必须在自己的文档中声明安装、开发、检查、测试和构建命令。修改合入 `main` 前，应当在模板自身目录中执行全部声明命令，确认模板仍然可用。

## 生命周期

### 开发与准入

1. 在所属语言仓库的长期分支 `template/<template-id>` 开发；开始前将该仓库最新 `main` 合入此分支。
2. 补齐 `template.yaml`，确认其 ID、目录名和拟登记 ID 一致；确认命令与 README、依赖声明文件一致。
3. 检查不存在真实密钥、个人路径、构建缓存、测试报告、业务样例或其他不应提交的文件；从独立复制目录验证模板不依赖工作区或同级模板。
4. 在模板目录执行 README 声明的完整本地验证，维护者审查结果后才能发布。

### 正式登记

1. 维护者将通过准入的模板分支合入所属语言仓库默认分支。
2. 确认默认分支中存在完整模板目录及 `template.yaml`。
3. 再将 `id`、`repository` 和 `path` 写入上层 `templates.yaml`。
4. 校验模板 ID 唯一、仓库引用存在、路径安全，并且上层 ID、目录名和 `template.yaml.id` 完全一致。

上层仓库和语言仓库是独立 Git 仓库，应分别审查和提交，不能假定跨仓库原子提交。宁可在模板已进入默认分支后短暂未登记，也不得让正式索引指向仅存在于开发分支或不存在的目录。

### 更新与重命名

普通模板更新仍在长期分支完成、验证并合入默认分支。`id`、`repository` 与 `path` 未变化时，不修改 `templates.yaml`；技术定位或标准命令变化时，同步更新 `template.yaml` 与 README。

首版不维护旧 ID 别名或迁移表。确需重命名时，同步移动模板目录、更新模板 `id`、上层 `templates.yaml` 和所有 `profiles.yaml` 引用，并移除旧 ID。

### 删除模板

如果某个模板已经没有继续保留的必要，应直接删除，不维护 Deprecated、Archived 或其他废弃状态：

1. 从 `profiles.yaml` 移除引用该模板的组合条目；
2. 从 `templates.yaml` 移除该模板条目，使其不再被正式选型；
3. 从所属语言仓库默认分支删除模板目录；
4. 删除对应的长期开发分支；
5. 最终检查不存在残留文档、索引或 profile 引用。

历史实现由 Git 历史保留。
