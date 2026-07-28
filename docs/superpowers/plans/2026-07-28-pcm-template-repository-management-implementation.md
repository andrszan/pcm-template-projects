# PCM Template Repository Management Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the minimal PCM multi-repository workspace, governance documents, template indexes, and two safe cross-repository helper scripts without creating any concrete architecture templates.

**Architecture:** The root `template-projects` Git repository tracks governance files and ignores two physically nested but Git-independent language repositories. The frontend and Python repositories contain only repository-level instructions and an empty `templates/` directory. YAML files provide repository, template, and profile indexes; Markdown files provide human and AI guidance; shell scripts only bootstrap missing repositories and report repository status.

**Tech Stack:** Git, Bash 3.2-compatible shell, YAML, Markdown, Ruby standard-library YAML parser for local validation.

## Global Constraints

- The root repository, frontend repository, and Python repository are independent Git repositories with default branch `main`.
- The root repository must ignore the two nested language repository directories explicitly.
- Do not create any React, Vue, Next.js, FastAPI, Django, Flask, or other concrete template.
- Do not add CI, dependency bots, template maturity states, release versions, customer-project tracking, automatic registry synchronization, or periodic validation.
- `templates.yaml` and `profiles.yaml` start with empty lists.
- Language repositories are collections of self-contained templates, not shared-dependency monorepos.
- Future template development uses persistent branches named `template/<template-id>`; do not create template branches before a template exists.
- Scripts may inspect or clone repositories but must not pull, commit, merge, switch branches, overwrite directories, or modify existing repositories.
- Never run `git clean -fdx` from the root workspace.

---

## File Map

### Root management repository

- Create `.gitignore`: explicitly ignore the two nested language repositories.
- Create `README.md`: human-facing project entry and navigation.
- Create `AGENTS.md`: multi-repository and AI behavior boundaries.
- Create `repositories.yaml`: language repository locations.
- Create `templates.yaml`: initially empty official template index.
- Create `profiles.yaml`: initially empty prepared-combination index.
- Create `docs/template-contract.md`: minimum requirements for future templates.
- Create `docs/selection-guide.md`: result-oriented architecture-selection criteria.
- Create `repositories/README.md`: explain nested independent repositories and cleanup risk.
- Create `scripts/status-all.sh`: read-only status display.
- Create `scripts/bootstrap.sh`: safe clone-if-missing helper.

### Frontend language repository

- Create `repositories/pcm-frontend-templates/.gitignore`: common frontend ignores.
- Create `repositories/pcm-frontend-templates/README.md`: repository purpose and branch workflow.
- Create `repositories/pcm-frontend-templates/AGENTS.md`: AI maintenance rules.
- Create `repositories/pcm-frontend-templates/templates/.gitkeep`: retain empty template directory.

### Python language repository

- Create `repositories/pcm-python-templates/.gitignore`: common Python ignores.
- Create `repositories/pcm-python-templates/README.md`: repository purpose and branch workflow.
- Create `repositories/pcm-python-templates/AGENTS.md`: AI maintenance rules.
- Create `repositories/pcm-python-templates/templates/.gitkeep`: retain empty template directory.

---

### Task 1: Create the root management repository baseline

**Files:**
- Create: `.gitignore`
- Create: `README.md`
- Create: `AGENTS.md`
- Create: `repositories.yaml`
- Create: `templates.yaml`
- Create: `profiles.yaml`
- Create: `repositories/README.md`

**Interfaces:**
- Produces: repository IDs `frontend` and `python`, and local paths consumed by both shell scripts.
- Produces: the official empty template/profile indexes consumed by later template-selection discussions.

- [ ] **Step 1: Create the explicit parent ignore rules**

Create `.gitignore`:

```gitignore
.DS_Store

# Independent nested Git repositories
/repositories/pcm-frontend-templates/
/repositories/pcm-python-templates/
```

- [ ] **Step 2: Create the repository indexes**

Create `repositories.yaml`:

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

Create `templates.yaml`:

```yaml
templates: []
```

Create `profiles.yaml`:

```yaml
profiles: []
```

- [ ] **Step 3: Create the root README**

Create `README.md`:

```markdown
# PCM Template Projects

PCM Template Projects is the management repository for business-free architecture templates used during PCM's manual market-validation stage.

This repository manages repository locations, template indexes, prepared technology combinations, template admission rules, and architecture-selection guidance. It does not contain customer projects or concrete frontend/backend templates.

## Workspace

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

The repositories under `repositories/` are independent Git repositories and are ignored by the root repository.

## Management Files

- `repositories.yaml`: language repository locations.
- `templates.yaml`: official template index.
- `profiles.yaml`: prepared frontend/backend combinations.
- `docs/template-contract.md`: minimum requirements for templates.
- `docs/selection-guide.md`: architecture-selection criteria.

## Commands

Show all local repository states:

```bash
./scripts/status-all.sh
```

Clone configured missing repositories without updating existing repositories:

```bash
./scripts/bootstrap.sh
```

## Current Scope

No concrete architecture templates or prepared profiles are included in the first stage. They will be added separately after their architecture choices are discussed and implemented.
```

- [ ] **Step 4: Create the root AI instructions**

Create `AGENTS.md`:

```markdown
# PCM Template Workspace Instructions

## Repository Boundaries

This workspace contains multiple independent Git repositories.

- The root repository manages documentation, indexes, and helper scripts.
- `repositories/pcm-frontend-templates` is an independent Git repository.
- `repositories/pcm-python-templates` is an independent Git repository.
- A clean root `git status` does not mean nested repositories are clean.
- Never run `git clean -fdx` or an equivalent ignored-file cleanup from the workspace root.

Before editing, identify the owning repository with:

```bash
pwd
git rev-parse --show-toplevel
git status --short
```

Do not modify multiple repositories unless the task explicitly requires it.

## Architecture Selection

When asked to recommend an architecture:

1. Read `profiles.yaml` and `docs/selection-guide.md`.
2. Inspect referenced template metadata when concrete templates exist.
3. Prefer an existing prepared combination when it satisfies the requirements.
4. Recommend the simplest architecture that satisfies the hard requirements.
5. State clearly when no existing combination is suitable.
6. Distinguish existing combinations from newly proposed combinations.
7. Treat the user's decision as final.

## Template Maintenance

- Do not develop a template directly on a language repository's `main` branch.
- Use the persistent branch `template/<template-id>` for that template.
- Merge the latest `main` into the template branch before editing.
- Do not add customer business code to a base template.
- Do not merge a template branch into `main` unless explicitly requested.
```

- [ ] **Step 5: Create the nested-repository explanation**

Create `repositories/README.md`:

```markdown
# Local Template Repositories

This directory contains independent Git repositories used by the PCM template workspace.

The root `template-projects` repository does not track the contents of these repositories. Cloning the root repository therefore does not automatically clone them.

Use `../scripts/bootstrap.sh` after real remote URLs are configured in `../repositories.yaml`, or create the repositories locally.

Do not run `git clean -fdx` from the root workspace: ignored nested repository directories could be removed.
```

- [ ] **Step 6: Validate the YAML and Git ignore behavior before committing**

Run:

```bash
ruby -e 'require "yaml"; %w[repositories.yaml templates.yaml profiles.yaml].each { |f| YAML.load_file(f) }; puts "yaml: ok"'
git check-ignore -v repositories/pcm-frontend-templates/example repositories/pcm-python-templates/example
git status --short
```

Expected:

- YAML command prints `yaml: ok`.
- `git check-ignore` reports the two explicit `.gitignore` rules.
- `git status --short` lists only the new root management files and does not list any child-repository content.

- [ ] **Step 7: Commit the root management baseline**

```bash
git add .gitignore README.md AGENTS.md repositories.yaml templates.yaml profiles.yaml repositories/README.md
git commit -m "chore: add PCM workspace management baseline"
```

---

### Task 2: Create the approved governance documents

**Files:**
- Create: `docs/template-contract.md`
- Create: `docs/selection-guide.md`

**Interfaces:**
- Produces: the admission standard future templates must satisfy.
- Produces: the selection criteria used by the user and AI to recommend prepared combinations.

- [ ] **Step 1: Create the template contract**

Create `docs/template-contract.md` with these exact sections and requirements:

```markdown
# PCM Template Contract

## Purpose

A PCM template is a business-free, self-contained, minimally runnable architecture project. It establishes a technology stack and its required engineering configuration without implementing customer or domain behavior.

## Required Properties

Every template must:

1. contain only architecture choices and required infrastructure configuration;
2. install, start, and build independently after its directory is copied elsewhere;
3. avoid runtime dependencies on the language repository root or sibling templates;
4. use one declared package manager and one matching lock file;
5. provide `.env.example` when environment variables are required;
6. contain `template.yaml`, `README.md`, and `AGENTS.md`;
7. contain the minimum infrastructure tests needed to demonstrate that the template works;
8. be locally validated before its changes are merged to `main`;
9. avoid real secrets, personal absolute paths, and generated build output.

## Business-Free Boundary

Templates must not contain:

- user, product, order, permission, or other business models;
- business pages, domain workflows, or industry-specific sample data;
- Todo or similar example business modules;
- customer project code.

Neutral infrastructure such as an application-ready placeholder page or a backend `/health` endpoint is allowed.

## Self-Containment

A template must not use:

- repository-root shared packages or configuration files;
- workspace dependencies on sibling directories;
- references to another template;
- local symbolic links;
- developer-machine private files.

## Minimum Template Files

A concrete template contains, as applicable to its technology stack:

```text
<template-id>/
├── template.yaml
├── README.md
├── AGENTS.md
├── .gitignore
├── .env.example
├── dependency declaration
├── dependency lock file
├── source code
└── infrastructure tests
```

The template ID must equal its directory name. The name describes technology and architecture, not a business domain.

## Local Validation

Each template documents its own install, development, check, test, and build commands. Before merging changes to `main`, run every command declared by that template and confirm the template still works from its own directory.

## Removal

If a template is no longer necessary, remove its directory, its `templates.yaml` entry, every related `profiles.yaml` entry, and its persistent development branch. Git history preserves the removed implementation; no deprecated or archived state is maintained.
```

- [ ] **Step 2: Create the architecture-selection guide**

Create `docs/selection-guide.md`:

```markdown
# PCM Architecture Selection Guide

## Objective

Given a customer requirement, recommend the simplest existing architecture combination that satisfies the hard requirements. AI provides analysis and alternatives; the user makes the final decision.

## Selection Principles

1. Hard requirements override default preferences.
2. Prefer an existing combination in `profiles.yaml` when it fits.
3. Choose the simplest architecture that satisfies the requirement.
4. Do not add complexity for hypothetical future requirements.
5. State clearly when no existing combination is suitable.
6. Distinguish an existing combination from a newly proposed combination.

## Business Boundary

First determine whether the project belongs to the current PCM scope. Web applications, content sites, internal systems, prototypes, and standard Python APIs may fit. Native mobile applications, games, hardware-dependent systems, strong algorithm projects, and production-grade regulated systems may fall outside the current scope.

## Frontend Criteria

### Platform

Determine whether the target is Web/H5, desktop, mobile application, mini program, content site, or a backend-only service.

### Rendering and SEO

- SEO or server rendering required: consider an SSR/SSG-capable template.
- Internal application without SEO: a SPA is usually sufficient.
- Content-first website or documentation: prefer a content-oriented architecture.

### Interface Characteristics

- Data-heavy tables, forms, filters, and trees: prefer a component system optimized for enterprise interfaces.
- Custom visual identity or AI/SaaS product interface: prefer a more composition-oriented UI system.
- Material Design requirement: prefer a Material-based system.

### Deployment and Constraints

Respect explicit framework, deployment, static-hosting, browser-runtime, and team-technology constraints.

## Python Backend Criteria

### Need for a Backend

Frontend-only prototypes and static content sites may not require a Python backend. Projects requiring databases and business APIs normally do.

### Framework Shape

- Standard independent REST API: prefer an API-oriented framework.
- Traditional full framework or built-in administration ecosystem: consider a full-stack web framework.
- Very small API surface: consider a lightweight framework.

### Database and I/O

- Choose an ORM/migration template only when persistent data is required.
- Do not select a complex asynchronous architecture for ordinary CRUD solely because it appears more advanced.
- Consider asynchronous I/O when the requirement actually involves substantial concurrent network or external-service work.

## Combination Decision

1. Identify the engineering shape and hard constraints.
2. Read the current combinations in `profiles.yaml`.
3. Compare the referenced templates when concrete templates exist.
4. Recommend the closest existing combination when it fully satisfies the requirement.
5. If no existing combination fits, explain the mismatch and optionally propose a new combination as a proposal, not as an existing PCM asset.

A recommendation only needs to state the engineering shape, selected or closest combination, reasons, and important limitations. No selection record or customer tracking file is required.
```

- [ ] **Step 3: Verify the documents contain the approved boundaries and no rejected governance features**

Run:

```bash
rg -n "business-free|self-contained|simplest|final decision|no existing combination" docs/template-contract.md docs/selection-guide.md
if rg -ni "^(status|tier|maturity|release version):|^#{1,6}[[:space:]]+(Core|Supported|Experimental|Deprecated|Archived)$|customer tracking is required|automatic dependency update" docs/template-contract.md docs/selection-guide.md; then exit 1; else echo "scope: ok"; fi
```

Expected:

- The first command finds the required principles.
- The second command prints `scope: ok`.

- [ ] **Step 4: Commit the governance documents**

```bash
git add docs/template-contract.md docs/selection-guide.md
git commit -m "docs: add template contract and selection guide"
```

---

### Task 3: Initialize the two independent language repositories

**Files:**
- Create: `repositories/pcm-frontend-templates/.gitignore`
- Create: `repositories/pcm-frontend-templates/README.md`
- Create: `repositories/pcm-frontend-templates/AGENTS.md`
- Create: `repositories/pcm-frontend-templates/templates/.gitkeep`
- Create: `repositories/pcm-python-templates/.gitignore`
- Create: `repositories/pcm-python-templates/README.md`
- Create: `repositories/pcm-python-templates/AGENTS.md`
- Create: `repositories/pcm-python-templates/templates/.gitkeep`

**Interfaces:**
- Produces: local repositories at the exact paths declared in `repositories.yaml`.
- Produces: the persistent branch rule future template tasks must follow.

- [ ] **Step 1: Initialize the frontend repository**

Run:

```bash
mkdir -p repositories/pcm-frontend-templates/templates
git init -b main repositories/pcm-frontend-templates
```

Create `repositories/pcm-frontend-templates/.gitignore`:

```gitignore
.DS_Store
.idea/
.vscode/
node_modules/
dist/
coverage/
.env
.env.local
```

Create `repositories/pcm-frontend-templates/README.md`:

```markdown
# PCM Frontend Templates

This repository contains self-contained, business-free frontend architecture templates.

## Repository Rules

- `main` contains the latest templates approved by the maintainer.
- Do not develop templates directly on `main`.
- Each concrete template uses the persistent branch `template/<template-id>`.
- Merge the latest `main` into the template branch before development.
- Templates must not depend on repository-root files, sibling templates, or shared workspace packages.

## Templates

No frontend templates have been added yet.

Concrete templates will be stored in `templates/<template-id>/` after their architecture is discussed and implemented separately.
```

Create `repositories/pcm-frontend-templates/AGENTS.md`:

```markdown
# Frontend Template Repository Instructions

- Do not edit a template directly on `main`.
- Use `template/<template-id>` as the persistent development branch.
- Merge the latest `main` into that branch before editing.
- Modify only the requested template by default.
- Do not create dependencies between templates.
- Do not add repository-root shared packages or workspace dependencies.
- Keep every template independently installable, runnable, testable, and buildable.
- Do not add customer business pages, models, workflows, or domain sample data.
- Run the target template's documented local validation commands before completion.
- Do not merge into `main` unless explicitly requested.
```

Create the empty-directory marker:

```bash
touch repositories/pcm-frontend-templates/templates/.gitkeep
```

- [ ] **Step 2: Commit the frontend repository skeleton**

Run:

```bash
git -C repositories/pcm-frontend-templates add .gitignore README.md AGENTS.md templates/.gitkeep
git -C repositories/pcm-frontend-templates commit -m "chore: initialize frontend template repository"
```

Expected: a root commit on `main` containing four files.

- [ ] **Step 3: Initialize the Python repository**

Run:

```bash
mkdir -p repositories/pcm-python-templates/templates
git init -b main repositories/pcm-python-templates
```

Create `repositories/pcm-python-templates/.gitignore`:

```gitignore
.DS_Store
.idea/
.vscode/
__pycache__/
.pytest_cache/
.mypy_cache/
.ruff_cache/
.venv/
dist/
build/
coverage.xml
.env
```

Create `repositories/pcm-python-templates/README.md`:

```markdown
# PCM Python Templates

This repository contains self-contained, business-free Python backend architecture templates.

## Repository Rules

- `main` contains the latest templates approved by the maintainer.
- Do not develop templates directly on `main`.
- Each concrete template uses the persistent branch `template/<template-id>`.
- Merge the latest `main` into the template branch before development.
- Templates must not depend on repository-root files, sibling templates, or shared workspace packages.

## Templates

No Python templates have been added yet.

Concrete templates will be stored in `templates/<template-id>/` after their architecture is discussed and implemented separately.
```

Create `repositories/pcm-python-templates/AGENTS.md`:

```markdown
# Python Template Repository Instructions

- Do not edit a template directly on `main`.
- Use `template/<template-id>` as the persistent development branch.
- Merge the latest `main` into that branch before editing.
- Modify only the requested template by default.
- Do not create dependencies between templates.
- Do not add repository-root shared packages or workspace dependencies.
- Keep every template independently installable, runnable, testable, and buildable.
- Do not add customer business models, routes, workflows, or domain sample data.
- Run the target template's documented local validation commands before completion.
- Do not merge into `main` unless explicitly requested.
```

Create the empty-directory marker:

```bash
touch repositories/pcm-python-templates/templates/.gitkeep
```

- [ ] **Step 4: Commit the Python repository skeleton**

Run:

```bash
git -C repositories/pcm-python-templates add .gitignore README.md AGENTS.md templates/.gitkeep
git -C repositories/pcm-python-templates commit -m "chore: initialize Python template repository"
```

Expected: a root commit on `main` containing four files.

- [ ] **Step 5: Verify Git independence and parent ignore behavior**

Run:

```bash
printf 'root=%s\n' "$(git rev-parse --show-toplevel)"
printf 'frontend=%s\n' "$(git -C repositories/pcm-frontend-templates rev-parse --show-toplevel)"
printf 'python=%s\n' "$(git -C repositories/pcm-python-templates rev-parse --show-toplevel)"
git status --short
git -C repositories/pcm-frontend-templates status --short
git -C repositories/pcm-python-templates status --short
```

Expected:

- The three printed top-level paths are different.
- All three status outputs are empty.
- The parent status does not list child repository content.

---

### Task 4: Implement the read-only multi-repository status script

**Files:**
- Create: `scripts/status-all.sh`

**Interfaces:**
- Consumes: `repositories.yaml` entries with `id` and `path`.
- Produces: one human-readable block per root or language repository with `path`, `branch`, and `status`.

- [ ] **Step 1: Verify the command does not exist yet**

Run:

```bash
./scripts/status-all.sh
```

Expected: command fails because `scripts/status-all.sh` does not exist.

- [ ] **Step 2: Create the minimal implementation**

Create `scripts/status-all.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$ROOT_DIR/repositories.yaml"

print_repository_status() {
  local id="$1"
  local repository_path="$2"

  printf '[%s]\n' "$id"
  printf 'path: %s\n' "$repository_path"

  if [[ ! -d "$repository_path/.git" ]]; then
    printf 'branch: -\n'
    printf 'status: missing\n\n'
    return
  fi

  local branch
  local changes
  branch="$(git -C "$repository_path" branch --show-current)"
  changes="$(git -C "$repository_path" status --porcelain)"

  if [[ -z "$branch" ]]; then
    branch='(detached)'
  fi

  printf 'branch: %s\n' "$branch"
  if [[ -z "$changes" ]]; then
    printf 'status: clean\n\n'
  else
    printf 'status: dirty\n'
    printf '%s\n\n' "$changes"
  fi
}

print_repository_status root "$ROOT_DIR"

while IFS='|' read -r id relative_path; do
  [[ -n "$id" && -n "$relative_path" ]] || continue
  print_repository_status "$id" "$ROOT_DIR/$relative_path"
done < <(
  awk '
    /^[[:space:]]*-[[:space:]]+id:/ {
      id = $0
      sub(/^[[:space:]]*-[[:space:]]+id:[[:space:]]*/, "", id)
    }
    /^[[:space:]]+path:/ {
      path = $0
      sub(/^[[:space:]]+path:[[:space:]]*/, "", path)
      if (id != "") print id "|" path
    }
  ' "$CONFIG_FILE"
)
```

Make it executable:

```bash
chmod +x scripts/status-all.sh
```

- [ ] **Step 3: Run the script against the real workspace**

Run:

```bash
./scripts/status-all.sh
```

Expected output contains:

```text
[root]
branch: main
status: clean

[frontend]
branch: main
status: clean

[python]
branch: main
status: clean
```

Paths appear between each header and branch line.

- [ ] **Step 4: Verify dirty and missing reporting without changing tracked content**

Run:

```bash
touch repositories/pcm-frontend-templates/local-status-check.tmp
./scripts/status-all.sh | grep -A5 '^\[frontend\]'
rm repositories/pcm-frontend-templates/local-status-check.tmp
mv repositories/pcm-python-templates repositories/pcm-python-templates.status-test
./scripts/status-all.sh | grep -A4 '^\[python\]'
mv repositories/pcm-python-templates.status-test repositories/pcm-python-templates
```

Expected:

- Frontend block reports `status: dirty` and lists `?? local-status-check.tmp`.
- Python block reports `status: missing`.
- The final move restores the repository to its original location.

- [ ] **Step 5: Commit the status script**

```bash
git add scripts/status-all.sh
git commit -m "feat: add multi-repository status command"
```

---

### Task 5: Implement the safe repository bootstrap script

**Files:**
- Create: `scripts/bootstrap.sh`

**Interfaces:**
- Consumes: `repositories.yaml` entries with `id`, `path`, and optional `remote`.
- Produces: missing local clones only when a real remote is configured.
- Exit behavior: `0` when every entry already exists or is cloned; `1` when an entry is unsafe, missing without a remote, or clone fails.

- [ ] **Step 1: Verify the command does not exist yet**

Run:

```bash
./scripts/bootstrap.sh
```

Expected: command fails because `scripts/bootstrap.sh` does not exist.

- [ ] **Step 2: Create the safe implementation**

Create `scripts/bootstrap.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$ROOT_DIR/repositories.yaml"
EXIT_CODE=0

while IFS='|' read -r id relative_path remote; do
  [[ -n "$id" && -n "$relative_path" ]] || continue

  target="$ROOT_DIR/$relative_path"

  if [[ -d "$target/.git" ]]; then
    printf '[%s] present: %s\n' "$id" "$target"
    continue
  fi

  if [[ -e "$target" ]]; then
    printf '[%s] error: path exists but is not a Git repository: %s\n' "$id" "$target" >&2
    EXIT_CODE=1
    continue
  fi

  if [[ -z "$remote" ]]; then
    printf '[%s] missing and no remote is configured: %s\n' "$id" "$target" >&2
    EXIT_CODE=1
    continue
  fi

  mkdir -p "$(dirname "$target")"
  printf '[%s] cloning %s into %s\n' "$id" "$remote" "$target"
  if ! git clone "$remote" "$target"; then
    printf '[%s] clone failed\n' "$id" >&2
    EXIT_CODE=1
  fi
done < <(
  awk '
    function emit() {
      if (id != "") print id "|" path "|" remote
    }
    /^[[:space:]]*-[[:space:]]+id:/ {
      emit()
      id = $0
      sub(/^[[:space:]]*-[[:space:]]+id:[[:space:]]*/, "", id)
      path = ""
      remote = ""
      next
    }
    /^[[:space:]]+path:/ {
      path = $0
      sub(/^[[:space:]]+path:[[:space:]]*/, "", path)
      next
    }
    /^[[:space:]]+remote:/ {
      remote = $0
      sub(/^[[:space:]]+remote:[[:space:]]*/, "", remote)
      next
    }
    END { emit() }
  ' "$CONFIG_FILE"
)

exit "$EXIT_CODE"
```

Make it executable:

```bash
chmod +x scripts/bootstrap.sh
```

- [ ] **Step 3: Verify existing repositories are left unchanged**

Run:

```bash
before_frontend="$(git -C repositories/pcm-frontend-templates rev-parse HEAD)"
before_python="$(git -C repositories/pcm-python-templates rev-parse HEAD)"
./scripts/bootstrap.sh
test "$before_frontend" = "$(git -C repositories/pcm-frontend-templates rev-parse HEAD)"
test "$before_python" = "$(git -C repositories/pcm-python-templates rev-parse HEAD)"
```

Expected:

- Script reports both repositories as `present`.
- Both `test` commands exit successfully.
- No pull, commit, or branch switch occurs.

- [ ] **Step 4: Verify local clone and no-remote behavior in an isolated temporary workspace**

Run:

```bash
tmp="$(mktemp -d)"
mkdir -p "$tmp/scripts" "$tmp/source"
cp scripts/bootstrap.sh "$tmp/scripts/bootstrap.sh"
git init -b main "$tmp/source"
git -C "$tmp/source" config user.name "PCM Test"
git -C "$tmp/source" config user.email "pcm-test@example.invalid"
touch "$tmp/source/README.md"
git -C "$tmp/source" add README.md
git -C "$tmp/source" commit -m "test fixture"
git clone --bare "$tmp/source" "$tmp/remote.git"
cat > "$tmp/repositories.yaml" <<YAML
repositories:
  - id: cloneable
    name: Cloneable
    path: repositories/cloneable
    remote: $tmp/remote.git
    default_branch: main
YAML
"$tmp/scripts/bootstrap.sh"
test -d "$tmp/repositories/cloneable/.git"
cat > "$tmp/repositories.yaml" <<'YAML'
repositories:
  - id: missing
    name: Missing
    path: repositories/missing
    default_branch: main
YAML
if "$tmp/scripts/bootstrap.sh"; then
  echo "expected missing-without-remote to fail" >&2
  rm -rf "$tmp"
  exit 1
fi
rm -rf "$tmp"
```

Expected:

- The first temporary run clones the local bare repository.
- The second temporary run prints `missing and no remote is configured` and exits nonzero.
- Temporary files are removed.

- [ ] **Step 5: Commit the bootstrap script**

```bash
git add scripts/bootstrap.sh
git commit -m "feat: add safe repository bootstrap command"
```

---

### Task 6: Run final integration verification

**Files:**
- Verify only; no planned file changes.

**Interfaces:**
- Consumes every deliverable from Tasks 1–5.
- Produces verification evidence that the first-stage acceptance criteria are met.

- [ ] **Step 1: Verify root files and YAML structure**

Run:

```bash
test -f README.md
test -f AGENTS.md
test -f docs/template-contract.md
test -f docs/selection-guide.md
test -x scripts/bootstrap.sh
test -x scripts/status-all.sh
ruby -e '
  require "yaml"
  repositories = YAML.load_file("repositories.yaml").fetch("repositories")
  templates = YAML.load_file("templates.yaml").fetch("templates")
  profiles = YAML.load_file("profiles.yaml").fetch("profiles")
  raise "repository count" unless repositories.map { |r| r.fetch("id") } == %w[frontend python]
  raise "templates not empty" unless templates == []
  raise "profiles not empty" unless profiles == []
  puts "configuration: ok"
'
```

Expected: prints `configuration: ok`.

- [ ] **Step 2: Verify the three Git repositories and branches**

Run:

```bash
test "$(git branch --show-current)" = main
test "$(git -C repositories/pcm-frontend-templates branch --show-current)" = main
test "$(git -C repositories/pcm-python-templates branch --show-current)" = main
test "$(git rev-parse --show-toplevel)" != "$(git -C repositories/pcm-frontend-templates rev-parse --show-toplevel)"
test "$(git rev-parse --show-toplevel)" != "$(git -C repositories/pcm-python-templates rev-parse --show-toplevel)"
test "$(git -C repositories/pcm-frontend-templates rev-parse --show-toplevel)" != "$(git -C repositories/pcm-python-templates rev-parse --show-toplevel)"
echo "git boundaries: ok"
```

Expected: prints `git boundaries: ok`.

- [ ] **Step 3: Verify parent ignore rules and repository cleanliness**

Run:

```bash
git check-ignore -q repositories/pcm-frontend-templates/README.md
git check-ignore -q repositories/pcm-python-templates/README.md
test -z "$(git status --porcelain)"
test -z "$(git -C repositories/pcm-frontend-templates status --porcelain)"
test -z "$(git -C repositories/pcm-python-templates status --porcelain)"
echo "working trees: clean"
```

Expected: prints `working trees: clean`.

- [ ] **Step 4: Verify script behavior together**

Run:

```bash
./scripts/bootstrap.sh
./scripts/status-all.sh
```

Expected:

- Bootstrap reports `frontend` and `python` as present.
- Status reports root, frontend, and Python on `main` with `status: clean`.

- [ ] **Step 5: Verify prohibited first-stage features are absent**

Run:

```bash
test -z "$(find repositories/pcm-frontend-templates/templates -mindepth 1 ! -name .gitkeep -print)"
test -z "$(find repositories/pcm-python-templates/templates -mindepth 1 ! -name .gitkeep -print)"
test ! -d .github/workflows
test ! -d registry
test ! -d contracts
test ! -d selection
test ! -d standards
echo "scope boundaries: ok"
```

Expected: prints `scope boundaries: ok`.

- [ ] **Step 6: Review repository history and final status**

Run:

```bash
git log --oneline --decorate -8
git -C repositories/pcm-frontend-templates log --oneline --decorate -3
git -C repositories/pcm-python-templates log --oneline --decorate -3
git status --short
git -C repositories/pcm-frontend-templates status --short
git -C repositories/pcm-python-templates status --short
```

Expected:

- Root history contains the approved design, implementation plan, baseline, governance documents, and two script commits.
- Each language repository contains one initialization commit.
- All three final status outputs are empty.
