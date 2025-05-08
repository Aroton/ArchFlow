# Verifying Workflow

```yaml
slug: archflow-verifying
name: ArchFlow - Verifying
groups: ['read', 'edit', 'command']
source: 'global'
```
Final quality gate—runs verification and marks the plan verified.

## 1 Folder Layout

```
.
└── archflow/                 # Root directory created by init script
    ├── architecture/
    │   ├── overall-architecture.md # High-level system view
    │   ├── features/             # Detailed feature architectures
    │   │   └── NNNN-feature-name.md # Example feature doc
    │   ├── adr/                  # Architecture Decision Records (ADR)
    │   │   ├── 0000-template.md  # Copy & rename for each new decision
    │   │   ├── 0001-...md        # First accepted ADR
    │   │   └── 0002-...md
    │   └── diagrams/             # Images referenced by ADRs or feature docs
    ├── plans/                    # Implementation plans (*.md)
    └── scripts/                  # Project-specific scripts (if applicable)
```
---

## 2  Key Artifacts

| Artifact                          | Purpose             |
| --------------------------------- | ------------------- |
| Plan file (all steps `completed`) | Verification target |

---

## 3  Delegated Task Contract (must be injected verbatim in every `new_task`)

* **Context** — why this task exists
* **Scope** — exact work
* **Files** — allowed paths
* **Outcome** — success criteria
* **Completion Call** — `attempt_completion` summary
* **Mode Lock** — agent may not change its own mode

---

## 4  Scope & Delegation Rules

* Runs automated + manual checks; cannot delegate further.
* On failure, return `success: false`; Orchestrator decides next steps.

---

## 5  Inputs

* Path to completed plan file
* Current repository state

---

## 6  Workflow

### Root Task

```yaml
id: verify-0001
state: VERIFYING
agent: archflow-verifying
delegate: false
```

1. **Run verification suite** (unit, integration, linter).
2. Run code review task (`verify-0002`)
2. **Pass?**

   * Yes → add `verified: true` to plan, commit, `attempt_completion success: true`.
   * No  → `attempt_completion success: false` with details.

### Code Review Task

```yaml
id: verify-0002
state: VERIFYING-CODE-REVIEW
agent: archflow-verifying
delegate: false
```

1. **Iterate through every diff**
2. **Validate code is up to code standards**
3. **Validate business logic matches plan**
4. **Complete**