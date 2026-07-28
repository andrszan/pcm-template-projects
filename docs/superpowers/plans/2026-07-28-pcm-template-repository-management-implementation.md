# PCM 模板仓库管理实施计划

> 日期：2026-07-28
> 对应设计：`docs/superpowers/specs/2026-07-28-pcm-template-repository-management-design.md`
> 实施状态：已完成

## 1. 实施目标

建立最小可用的 PCM 多仓库模板工作区，包括：

1. 一个上层管理仓库；
2. 一个独立前端模板仓库；
3. 一个独立 Python 模板仓库；
4. 模板索引和预设组合索引；
5. 模板准入契约和架构选型指南；
6. 两个只承担必要职责的跨仓库辅助脚本。

本阶段不创建任何具体架构模板。

## 2. 总体结构

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
│   ├── selection-guide.md
│   └── superpowers/
│       ├── specs/
│       └── plans/
├── scripts/
│   ├── bootstrap.sh
│   └── status-all.sh
└── repositories/
    ├── README.md
    ├── pcm-frontend-templates/
    │   ├── .git/
    │   ├── .gitignore
    │   ├── README.md
    │   ├── AGENTS.md
    │   └── templates/.gitkeep
    └── pcm-python-templates/
        ├── .git/
        ├── .gitignore
        ├── README.md
        ├── AGENTS.md
        └── templates/.gitkeep
```

## 3. 实施约束

实施过程必须遵守以下边界：

- 三个仓库相互独立，默认分支均为 `main`；
- 上层仓库显式忽略两个语言仓库；
- 不使用 Git Submodule；
- 不创建 React、Vue、Next.js、FastAPI、Django、Flask 等具体模板；
- `templates.yaml` 和 `profiles.yaml` 初始保持空列表；
- 不增加 CI、定期检查、依赖机器人和自动升级；
- 不建立模板等级、成熟度、发布版本或兼容旧版本体系；
- 不记录客户项目、选型结果和模板使用情况；
- 辅助脚本不得自动执行拉取、提交、合并或分支切换；
- 禁止在工作区根目录执行 `git clean -fdx`。

## 4. 上层管理仓库

### 4.1 `.gitignore`

必须显式忽略：

```gitignore
/repositories/pcm-frontend-templates/
/repositories/pcm-python-templates/
```

不得使用 `/repositories/*` 之类的宽泛规则，以免忽略上层仓库需要维护的 `repositories/README.md`。

### 4.2 `repositories.yaml`

只记录语言仓库 ID、名称、本地路径和默认分支：

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

真实远程仓库建立后才增加 `remote`，不使用占位地址。

### 4.3 `templates.yaml`

第一阶段没有具体模板：

```yaml
templates: []
```

### 4.4 `profiles.yaml`

第一阶段没有已经实现的预设组合：

```yaml
profiles: []
```

### 4.5 根目录说明文件

根目录需要提供：

- `README.md`：工作区入口、目录结构和常用命令；
- `AGENTS.md`：多仓库边界、中文协作要求、选型规则和模板维护规则；
- `repositories/README.md`：解释嵌套独立仓库及清理风险。

## 5. 管理文档

### 5.1 模板契约

`docs/template-contract.md` 必须明确：

- 模板业务无关；
- 模板最小可运行；
- 模板能够被单独复制；
- 模板不得依赖仓库根目录或其他模板；
- 使用单一包管理方式和锁文件；
- 提供必要的环境变量示例；
- 提供最低限度基础设施测试；
- 禁止真实密钥、个人路径和客户业务代码；
- 不需要的模板直接删除，不建立废弃状态体系。

### 5.2 架构选型指南

`docs/selection-guide.md` 必须支持以下人工流程：

```text
客户需求
→ 用户整理需求并询问 AI
→ AI 参考 profiles.yaml 和选型指南
→ AI 推荐现有组合或说明没有合适组合
→ 用户作出最终决定
→ 用户手动取得模板并继续开发
```

选型原则是：满足硬性要求的前提下，选择最简单的架构，不为假设性需求增加复杂度。

## 6. 语言仓库

### 6.1 前端模板仓库

路径：

```text
repositories/pcm-frontend-templates/
```

初始只包含：

```text
.gitignore
README.md
AGENTS.md
templates/.gitkeep
```

### 6.2 Python 模板仓库

路径：

```text
repositories/pcm-python-templates/
```

初始只包含：

```text
.gitignore
README.md
AGENTS.md
templates/.gitkeep
```

### 6.3 模板分支规则

未来每个实际存在的模板使用长期开发分支：

```text
template/<template-id>
```

维护步骤：

1. 切换到模板长期开发分支；
2. 将最新 `main` 合入该分支；
3. 默认只修改目标模板；
4. 执行模板声明的本地验证；
5. 提交模板分支；
6. 由维护者决定是否合入 `main`。

尚未创建具体模板时，不提前创建空模板分支。

## 7. `status-all.sh`

脚本职责只有一个：只读显示上层仓库和语言仓库的状态。

每个仓库显示：

- 仓库 ID；
- 本地路径；
- 当前分支；
- 工作区是否干净。

仓库不存在时显示 missing，不得自动创建或修改仓库。

需要验证：

- 三个仓库正常存在时均能显示；
- 有未提交文件时显示 dirty；
- 语言仓库目录缺失时显示 missing；
- 脚本不会修改任何仓库。

## 8. `bootstrap.sh`

脚本只处理缺失语言仓库：

- 仓库已存在时，只报告 present；
- 目标路径已存在但不是 Git 仓库时，拒绝覆盖并返回失败；
- 仓库缺失且未配置远程地址时，明确提示并返回失败；
- 仓库缺失且配置了真实远程地址时，执行一次 `git clone`。

脚本不得：

- 更新已有仓库；
- 执行 `git pull`；
- 切换分支；
- 自动提交；
- 自动合并；
- 覆盖已有目录。

## 9. 提交安排

上层管理仓库按以下内容分步提交：

1. 管理设计；
2. 实施计划；
3. 上层管理基础结构；
4. 模板契约和架构选型指南；
5. 多仓库状态脚本；
6. 安全仓库初始化脚本；
7. 后续必要的文档修正。

两个语言仓库分别保留自己的初始化提交。

所有面向维护者的 Git 提交说明默认使用中文。

## 10. 验收项目

### 10.1 配置

- `repositories.yaml` 能被 YAML 解析器读取；
- 仓库 ID 依次为 `frontend` 和 `python`；
- 两个默认分支均为 `main`；
- `templates.yaml` 是空列表；
- `profiles.yaml` 是空列表。

### 10.2 Git 边界

- 三个仓库的顶层目录互不相同；
- 三个仓库当前分支均为 `main`；
- 上层仓库不跟踪两个语言仓库内容；
- 三个仓库状态可以分别检查。

### 10.3 脚本

- 两个脚本通过 Bash 语法检查；
- `status-all.sh` 能正确显示 clean、dirty 和 missing；
- `bootstrap.sh` 不修改已有仓库；
- `bootstrap.sh` 能拒绝已有非 Git 目录；
- `bootstrap.sh` 能拒绝未配置远程地址的缺失仓库；
- `bootstrap.sh` 能从本地测试远程地址克隆仓库。

### 10.4 范围

- 两个 `templates/` 目录中只有 `.gitkeep`；
- 不存在具体前端或 Python 模板；
- 不存在 CI；
- 不存在客户项目管理；
- 不存在模板状态、版本或自动更新体系。

## 11. 实施结果

第一阶段已经完成，最终结果符合批准设计：

- 上层管理仓库已经建立；
- 前端和 Python 独立仓库已经建立；
- 文档、索引和脚本已经落地；
- 所有最终验证均已通过；
- 尚未创建任何具体模板或预设组合。
