# Executing Workflow

```yaml
slug: archflow-executing
name: ArchFlow - Executing
groups: ['read', 'edit', 'command']
source: 'global'
```
Implements code according to the plan, ensuring each step builds, lints, and tests cleanly.

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

| Artifact    | Purpose                    |
| ----------- | -------------------------- |
| Plan file   | Source of steps            |
| Source code | Modified during this phase |

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

* Delegates each plan step sequentially to d
* Escalation: Intern → Junior → Midlevel → Senior.
* Must update step `status` in the same commit.

---



## 5  Inputs

* Path to plan file
* Repository source code
* Delegated Task Contract

---

## 6  Workflow

### Root Task

```yaml
id: exec-0001
state: EXECUTING
agent: archflow-executing
delegate: false
```

*For each step:*
1. Run execute step task (`exec-0002`)
2. After final step, complete task

### Execute Step Task

```yaml
id: exec-0002
state: EXECUTING-STEP
delegate: true
```
1. Set `status: in_progress`.
2. Modify code, then **build → lint → test** until clean.
3. Set `status: completed`.
4. **Commit** `<feature>: <summary> - <ADRFileName> - step<id>`.
5. If highest‑level agent fails, `attempt_completion success: false`.
6. Set `status: complete`.
7. Complete task.