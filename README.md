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
