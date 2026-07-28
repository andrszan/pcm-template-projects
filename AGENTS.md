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
