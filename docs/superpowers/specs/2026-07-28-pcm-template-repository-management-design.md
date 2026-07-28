# PCM 基础架构模板仓库管理设计

> 日期：2026-07-28  
> 状态：已完成讨论，待文档复核  
> 适用阶段：PCM 商业可行性人工验证阶段

## 1. 背景

PCM（Project Customization & Management）当前处于由人承担管理和接单决策、由 AI 辅助需求分析与开发的早期验证阶段。项目计划逐步沉淀前端和后端基础架构模板，以减少每次客户项目的工程初始化时间。

本设计只讨论基础模板仓库的组织、管理和选型标准，不讨论任何具体 React、Vue、FastAPI、Django 等模板的实现。

模板的定义是：完成技术选型、必要基础配置和工程装配的业务无关项目骨架。模板不包含用户、商品、订单、权限等业务模型，不包含具体业务页面或业务流程。

## 2. 设计目标

第一阶段只实现以下结果：

1. 在一个本地工作区内集中放置上层管理仓库、前端模板仓库和 Python 模板仓库。
2. 保持三个 Git 仓库相互独立。
3. 明确模板准入要求、仓库边界和模板开发分支规则。
4. 建立模板索引和预设技术组合清单。
5. 提供架构选型标准，使用户可以拿客户需求询问 AI，并获得组合建议和理由。
6. 保持体系简单，避免在市场验证前建设自动化平台和复杂维护机制。

## 3. 非目标

第一阶段明确不实现：

- 具体前端或后端模板代码；
- 客户项目创建、记录、同步或统计；
- PCM 后台管理系统；
- 模板选择 CLI 或 Web 页面；
- 模板生成器；
- CI；
- 定期检查；
- 自动依赖升级；
- 模板状态、重要性或成熟度分级；
- 模板版本发布体系；
- 旧版本兼容和多版本并存；
- Deprecated、Archived 等废弃流程；
- 自动兼容性测试；
- 复杂评分系统；
- 自动 Registry 同步或校验程序。

## 4. 总体架构

### 4.1 逻辑职责

- `template-projects`：模板资产索引、技术组合、选型标准、模板准入标准和跨仓库辅助脚本。
- `pcm-frontend-templates`：前端基础架构模板代码。
- `pcm-python-templates`：Python 基础架构模板代码。

上层管理仓库是逻辑控制面，但不通过 Git 跟踪子仓库代码。

### 4.2 物理目录

```text
template-projects/
├── .git/
├── .gitignore
├── README.md
├── AGENTS.md
├── repositories.yaml
├── templates.yaml
├── profiles.yaml
├── docs/
│   ├── template-contract.md
│   └── selection-guide.md
├── scripts/
│   ├── bootstrap.sh
│   └── status-all.sh
└── repositories/
    ├── README.md
    ├── pcm-frontend-templates/
    │   └── .git/
    └── pcm-python-templates/
        └── .git/
```

### 4.3 Git 边界

上层 `.gitignore` 显式忽略：

```gitignore
/repositories/pcm-frontend-templates/
/repositories/pcm-python-templates/
```

不使用 `/repositories/*` 之类的宽泛规则，以免误忽略上层需要管理的文件。

三个仓库均使用 `main` 作为默认分支。上层 `git status` 不代表子仓库状态。禁止在上层工作区执行 `git clean -fdx` 或等价的、会删除 ignored 内容的清理命令。

## 5. 上层管理仓库文件职责

### 5.1 `README.md`

作为人工入口，只说明项目定位、目录结构、快速开始和各管理文件链接，不复制具体模板技术栈、运行命令或完整选型规则。

### 5.2 `AGENTS.md`

只约束 AI 在多仓库工作区中的行为，包括：

- 识别独立 Git 边界；
- 不从上层提交子仓库代码；
- 不执行危险清理命令；
- 选型时参考 `profiles.yaml` 和 `docs/selection-guide.md`；
- 维护模板时进入对应语言仓库和模板开发分支；
- 不把业务代码加入基础模板；
- 未明确要求时不修改多个仓库或合并到 `main`。

### 5.3 `repositories.yaml`

是语言仓库清单的唯一信息来源，只记录仓库 ID、名称、本地路径和默认分支。真实远程地址存在后再增加 `remote`，不写 `TBD` 占位值。

初始内容：

```yaml
repositories:
  - id: frontend
    name: PCM Frontend Templates
    path: repositories/pcm-frontend-templates
    default_branch: main

  - id: python
    name: PCM Python Templates
    path: repositories/pcm-python-templates
    default_branch: main
```

### 5.4 `templates.yaml`

是正式模板清单的唯一信息来源，只建立模板 ID 到语言仓库和目录的映射。第一阶段尚未创建具体模板，因此初始内容为：

```yaml
templates: []
```

### 5.5 `profiles.yaml`

是预设技术组合清单的唯一信息来源。组合引用模板 ID，并可记录适合的工程形态，但不复制模板完整技术栈、命令、依赖版本或维护状态。

第一阶段没有已实现模板，因此初始内容为：

```yaml
profiles: []
```

### 5.6 `docs/template-contract.md`

定义模板进入语言仓库前必须满足的最低要求，不包含 CI、状态分级、版本体系、客户项目或统计机制。

### 5.7 `docs/selection-guide.md`

记录架构组合选择标准，包括平台、SEO、SSR、应用或内容站、UI 类型、数据密度、是否需要独立后端、Python 框架形态、数据库、同步与异步、部署要求和客户指定技术栈。

选择原则：

1. 硬性需求优先。
2. 优先考虑已有组合，但不强制只能使用已有组合。
3. 选择满足需求的最简单架构。
4. 不为假想的未来需求增加复杂度。
5. 没有合适组合时明确说明。
6. AI 提供分析和建议，最终由用户决定。

### 5.8 `scripts/bootstrap.sh`

根据 `repositories.yaml` 检查语言仓库是否存在：

- 目录存在时不覆盖；
- 配置真实 `remote` 且目录不存在时可以克隆；
- 未配置 `remote` 时给出明确提示；
- 不自动 `pull`；
- 不修改、提交或覆盖已有仓库。

### 5.9 `scripts/status-all.sh`

只显示上层、前端和 Python 仓库是否存在、当前分支及工作区是否有未提交修改。不自动切换分支、拉取、提交、合并或修复。

### 5.10 `repositories/README.md`

说明该目录存放独立 Git 仓库、父仓库不会跟踪子仓库、父仓库克隆不会自动获得子仓库，以及父仓库危险清理命令的风险。

## 6. 语言模板仓库设计

前端和 Python 仓库第一阶段只创建骨架：

```text
<language-repository>/
├── .git/
├── .gitignore
├── README.md
├── AGENTS.md
└── templates/
    └── .gitkeep
```

### 6.1 仓库职责

语言仓库只是多个完全独立模板的集合，不是共享依赖 Monorepo。仓库根目录不提供模板运行所依赖的公共包、共享配置或工作区依赖。

### 6.2 模板自包含原则

未来每个模板必须能够单独复制到其他目录后安装、启动、检查和构建。模板不得：

- 引用语言仓库根目录配置；
- 依赖兄弟模板；
- 使用本地软链接；
- 使用仓库级 workspace dependency；
- 依赖开发者机器上的绝对路径或私有文件。

### 6.3 模板目录

模板采用扁平目录：

```text
templates/<template-id>/
```

模板 ID 与目录名称一致。名称只表达框架、构建或运行方式、UI 或关键技术和工程形态，不使用业务名称。

### 6.4 模板最低文件

具体模板创建时，根据技术栈至少包含：

- `template.yaml`；
- `README.md`；
- `AGENTS.md`；
- 自身 `.gitignore`；
- 依赖声明和单一锁文件；
- 需要环境变量时提供 `.env.example`；
- 能证明基础设施可用的必要测试；
- 完整的工程配置和源代码。

## 7. 模板契约

模板必须：

1. 业务无关，只包含架构选型和必要基础配置。
2. 最小可运行，能够安装、启动和构建。
3. 完全自包含。
4. 使用明确且单一的包管理方式和锁文件。
5. 提供必要环境变量示例且不包含真实密钥。
6. 通过 `template.yaml` 描述机器可读技术事实和命令。
7. 通过 `README.md` 说明定位、技术栈、包含与不包含的内容、安装、启动、检查和目录结构。
8. 通过 `AGENTS.md` 约束 AI 修改范围、技术边界和本地验证命令。
9. 提交前完成人工本地验证。

模板禁止包含：

- 用户、商品、订单、权限等业务模型；
- 具体业务页面和业务流程；
- 行业相关演示数据；
- Todo 等示例业务；
- 客户项目代码；
- 真实密钥和个人绝对路径；
- 多套冲突的锁文件；
- 对仓库根目录或其他模板的运行依赖。

不再需要的模板直接从 `main`、`templates.yaml` 和相关 `profiles.yaml` 条目中删除，同时删除对应长期开发分支。历史内容由 Git 历史保留，不维护 Deprecated 或 Archived 状态。

## 8. 分支模型

### 8.1 `main`

每个语言仓库的 `main` 保存所有当前最新且已经由维护者确认的模板内容。禁止直接在 `main` 开发模板。

### 8.2 长期模板开发分支

每个实际创建的模板拥有一个长期开发分支：

```text
template/<template-id>
```

不提前创建尚不存在模板的空分支。

开发流程：

1. 切换到 `template/<template-id>`。
2. 将最新 `main` 合入模板分支。
3. 默认只修改目标模板目录及本次变更确实需要的仓库级说明。
4. 执行模板自身声明的本地验证。
5. 提交模板开发分支。
6. 由维护者决定是否合入 `main`。
7. 合并后保留长期模板分支。

技术注意：Git 分支包含整个仓库快照，而不是只包含单一模板目录，因此长期模板分支需要在每次开发前同步 `main`。如果未来分支同步成本明显增加，可以改为短生命周期分支；第一阶段仍采用已确认的长期模板分支模型。

## 9. 架构选型使用方式

当前阶段由人承担 PCM 管理角色，AI 只作为架构选型顾问。

使用方式：

```text
客户需求
→ 用户整理需求并询问 AI
→ AI 参考 profiles.yaml、selection-guide.md 和必要的模板元数据
→ AI 推荐现有组合或说明没有完全匹配的组合
→ 用户做最终决定
→ 用户手动取出模板并在其他项目中开发
```

上层仓库不记录客户需求、选型结果、模板使用情况或客户项目状态。AI 不需要遵循固定输出格式，只需说明工程形态、推荐组合、推荐原因以及重要的不匹配点或风险。

## 10. 信息唯一来源

| 信息 | 唯一维护位置 |
|---|---|
| 语言仓库清单和路径 | `repositories.yaml` |
| 正式模板清单和位置 | `templates.yaml` |
| 预设技术组合 | `profiles.yaml` |
| 模板准入要求 | `docs/template-contract.md` |
| 架构选择标准 | `docs/selection-guide.md` |
| 语言仓库 Git 和修改规则 | 语言仓库 `AGENTS.md` |
| 模板技术事实与命令 | 模板 `template.yaml` |
| 模板人工使用说明 | 模板 `README.md` |
| 模板 AI 修改约束 | 模板 `AGENTS.md` |
| 真实依赖版本 | 模板依赖声明和锁文件 |

维护原则：能引用就不复制；机器读取的信息放 YAML；人理解的信息放 README 或文档；AI 必须遵守的约束放 `AGENTS.md`。

## 11. 第一阶段实施范围

1. 初始化上层管理仓库，默认分支为 `main`。
2. 创建并提交上层管理文件和文档。
3. 在 `repositories/` 下初始化前端和 Python 独立仓库，默认分支为 `main`。
4. 创建两个语言仓库的最小 README、AGENTS、`.gitignore` 和空 `templates/` 目录。
5. 实现 `bootstrap.sh` 和 `status-all.sh`。
6. 验证父仓库不跟踪子仓库、三个 Git 状态相互独立、YAML 语法正确、脚本行为符合约束。
7. 不创建任何具体技术模板或预设组合。

## 12. 完成标准

第一阶段完成需要同时满足：

- 三个独立 Git 仓库均存在且使用 `main`；
- 上层仓库正确忽略两个语言仓库；
- `repositories.yaml` 正确定位两个语言仓库；
- `templates.yaml` 和 `profiles.yaml` 初始为空；
- 根 README 和 AGENTS 能说明项目入口与多仓库边界；
- 模板契约和选型指南内容完整且无超出范围的管理机制；
- 两个语言仓库明确模板自包含原则和长期模板分支规则；
- `status-all.sh` 正确显示三个仓库状态；
- `bootstrap.sh` 不覆盖已有目录，不进行隐式拉取或修改；
- 不存在具体模板、客户项目逻辑、CI、自动升级、模板状态或版本体系。
