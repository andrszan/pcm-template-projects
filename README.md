# PCM 基础架构模板项目

本仓库是 PCM 在人工市场验证阶段使用的基础架构模板上层管理仓库。

它负责管理语言仓库位置、正式模板索引、预设技术组合、模板准入规则和架构选型标准；不存放客户项目，也不直接存放具体的前端或后端模板代码。

## 工作区结构

```text
template-projects/
├── repositories.yaml
├── templates.yaml
├── profiles.yaml
├── docs/
├── scripts/
└── repositories/
    ├── pcm-frontend-templates/
    └── pcm-python-templates/
```

`repositories/` 下的两个语言仓库都是独立 Git 仓库，并由上层仓库通过 `.gitignore` 忽略。

## 管理文件

- `repositories.yaml`：语言仓库及其本地路径。
- `templates.yaml`：正式模板索引。
- `profiles.yaml`：预设前后端技术组合。
- `docs/template-contract.md`：模板必须满足的最低要求。
- `docs/selection-guide.md`：根据项目需求选择架构组合的标准。

## 常用命令

查看所有本地仓库状态：

```bash
./scripts/status-all.sh
```

在配置真实远程地址后，克隆本地缺失的语言仓库：

```bash
./scripts/bootstrap.sh
```

`bootstrap.sh` 不会拉取、修改或覆盖已经存在的仓库。

## 当前范围

正式模板以 `templates.yaml` 为准，预设技术组合以 `profiles.yaml` 为准。当前已登记前端与 Python API 模板，以及 3 个面向常规 SPA、PostgreSQL Web 应用和异步 I/O 场景的预设组合。

Profile 表示经过确认、可复用的多模板组合，不是全部模板的排列组合。未登记的模板组合仍可在满足项目硬性要求时作为新建议提出，但不得描述成已有预设。
