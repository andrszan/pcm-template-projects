# PCM 基础架构模板项目

本仓库是 PCM 在人工市场验证阶段使用的基础架构模板上层管理仓库。

它负责管理语言仓库位置、正式模板索引、模板准入规则和架构选型标准；不存放客户项目，也不直接存放具体的前端或后端模板代码。

## 工作区结构

```text
template-projects/
├── catalog.json
├── docs/
├── scripts/
└── repositories/
    ├── pcm-frontend-templates/
    └── pcm-python-templates/
```

`repositories/` 下的两个语言仓库都是独立 Git 仓库，并由上层仓库通过 `.gitignore` 忽略。

## 管理文件

- `catalog.json`：语言仓库地址、默认分支与正式模板目录，也是 PCM 选型模型的输入。
- `docs/template-contract.md`：模板必须满足的最低要求。
- `docs/selection-guide.md`：根据项目需求选择项目起点的标准。

## 仓库地址

- 上层管理仓库：https://github.com/andrszan/pcm-template-projects
- 前端模板仓库：https://github.com/andrszan/pcm-frontend-templates
- Python 模板仓库：https://github.com/andrszan/pcm-python-templates

`catalog.json` 记录两个语言仓库及其正式模板；上层管理仓库自身不作为语言仓库重复登记。本地仓库统一放在 `repositories/<仓库键>`，仓库键就是仓库目录名。

## 常用命令

查看所有本地仓库状态：

```bash
./scripts/status-all.sh
```

克隆本地缺失的语言仓库：

```bash
./scripts/bootstrap.sh
```

`bootstrap.sh` 不会拉取、修改或覆盖已经存在的仓库。

## 当前范围

正式模板以 `catalog.json` 为准，当前已登记前端与 Python API 项目起点。模板的安装、开发和验证方式以模板 README 与依赖声明中的实际命令为准。

PCM 不维护预设技术组合。AI 根据项目要求独立选择需要的模板，并在派生项目中完成裁剪、集成和验证。
