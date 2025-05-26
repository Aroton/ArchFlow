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
    │   │   └── YYYYMMDDHHMMSS-feature-name.md # Example feature doc
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

## 3  Delegated Task Contract (must be injected verbatim in every `new_task`)

When the Orchestrator delegates a task using the new_task tool, the instructions provided to the specialized agent must include:

* Context: All relevant details from the parent task, ADR, Feature Architecture, overall goal, and how this specific step fits into the larger plan.
* Scope: A clear, precise definition of what the subtask should accomplish.
* Files: A list of the specific files the agent should work on for this step (if applicable).
* Focus: An explicit statement that the subtask must only perform the outlined work and not deviate or expand scope.
* Outcome: A description of the desired state or result upon successful completion of the task.
* Completion: An instruction to use the attempt_completion tool upon finishing. The result parameter should contain a concise yet thorough summary confirming task execution, plan status update (if applicable), and commit details (if applicable). This summary is crucial for tracking progress.
* Instruction Priority: A statement clarifying that these specific subtask instructions override any conflicting general instructions the agent mode might have.
* Workflow Steps: Include all relevant workflow steps the task should complete
* Mode Restriction: A statement prohibiting the subtask agent from switching modes itself; it must complete its assigned task and then call attempt_completion.

---

## 4  Scope & Delegation Rules

* Creates/updates ADRs, Feature docs, Overall Architecture, and commits changes.
* May delegate ONLY to `Researcher`.
* On failure, report back; do not escalate internally.
* **Important** **Do not include** code in the Delegated Task Contract.
* **Important** **Must do research before creating an architecture**

## 5  Inputs
* High‑level feature description (from Orchestrator)
* Existing architecture docs (paths)
* Delegated Task Contract

## 6  Workflow

### Root Task

```yaml
state: ARCHITECTING
agent: archflow-architecting
delegate: false
steps:
    - Gather Context:
        - Load architecture docs
        -   state: ARCHITECTING-RESEARCHING
            agent: researcher
            delegate: true
            steps:
                - Load all files provided in context
                - Meet objectives of the delegated task context
                - Complete task
    - Create ADR:
        - Copy `/archflow/architectrue/0000-template.md` → `/archflow/architecture/YYYYMMDDHHMMSS-<adrName>.md`
        - Ask any clarifying questions
        - "Fill or update sections in `/archflow/architecture/YYYYMMDDHHMMSS-<adrName>.md` - Must embed *full relative paths* in ADR links."
    - Update or create feature architecture:
        - If new, copy `/archflow/features/template.md` → `/archflow/features/YYYYMMDDHHMMSS-<genericFeatureName>.md`
        - Analyze feature architecture and detect any differences with the ADR
        - Fill or update sections in `/archflow/features/YYYYMMDDHHMMSS-<genericFeatureName>.md`
    - Update overall architecture:
        - Analyze `/archflow/architecture/overall-architecture.md`
        - Analzye `/archflow/architecture/YYYYMMDDHHMMSS-<adrName>.md`
        - Update overall-architecure.md with any major changes
    - "commit `<feature>: <summary> - <ADRFileName>`"
```