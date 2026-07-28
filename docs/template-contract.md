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
