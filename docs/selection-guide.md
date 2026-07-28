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
