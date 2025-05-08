# Architecting Workflow

```yaml
slug: archflow-architecting
name: ArchFlow - Architecting
groups: ['read', 'edit', 'command']
source: 'global'
```

The architecting workflow goes through a series of steps to create new architecture documents, and to update existing documents. At a high level it researches the code base, creates a new ADR (architectural decision record), updates the feature architecture, and updates the overall architecture.

## 1  Folder Layout

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

## 2  Key Artifacts

| Artifact                 | Purpose
| ------------------------ | -------------------------------------
| **Overall Architecture** | High‑level system view
| **Feature Architecture** | Detailed design per feature
| **ADR**                  | One architectural decision

---

## 3  Delegated Task Contract

Every `new_task` **must** supply:

* **Context** — What led to this task.
* **Scope** — Precise definition of work.
* **Files** — Paths that may be modified.
* **Outcome** — Success criteria.
* **Completion Call** — `attempt_completion` with concise result summary.
* **Mode Lock** — The agent may not change its own mode.

---

## 4  Scope & Delegation Rules

* Creates/updates ADRs, Feature docs, Overall Architecture, and commits changes.
* May delegate ONLY to `Researcher`.
* On failure, report back; do not escalate internally.

## 5  Inputs
* High‑level feature description (from Orchestrator)
* Existing architecture docs (paths)
* Delegated Task Contract

## 6  Workflow

### Root Task

```yaml
id: arch-0001
state: ARCHITECTING
agent: archflow-architecting
delgate: false
```

1. **Gather context**
    * Load architecture docs
    * Delegate research task (`arch-0002`) if needed
2. **Create ADR**
    * Copy `/archflow/architectrue/0000-template.md` → `/archflow/architecture/NNNN-<adrName>.md`
    * Fill sections (Context, Decision, Consequences, …)
    * Must embed *full relative paths* in ADR links.
3. **Update / Create Feature Architecture** per ADR.
    * If new, copy `/archflow/features/template.md` → `/archflow/features/NNNN-<genericFeatureName>.md`
    * Fill/Update sections
4. **Update overall-architecture.md** with major impacts.
5. **Commit** Execute commit task (`arch-0003`)
6. **Complete task**


### Researching Task

```yaml
id: arch-0002
state: ARCHITECTING-RESEARCHING
agent: researcher
delegate: true
```

1. **Load all files provided in context**
2. **Meet objectives of the delgated task context**
3. **Complete task**


### Code Commit Task

```yaml
id: arch-0003
state: ARCHITECTING-COMMIT
agent: archflow-architecting
delegate: false
```

1. **Add all created/updated files to git**
2. **Commit with the format of** `<feature>: <summary> - <ADRFileName>`
---
