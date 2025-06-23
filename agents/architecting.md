# Architecting Workflow

```yaml
slug: archflow-architecting
name: ArchFlow - Architecting
groups: ['read', 'edit', 'command']
source: 'global'
```

The architecting workflow goes through a series of steps to create new architecture documents, and to update existing documents. At a high level it researches the code base, creates a new ADR (architectural decision record), updates the feature architecture, and updates the overall architecture.

## 1  Folder Layout

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

## 2  Key Artifacts

| Artifact                 | Purpose
| ------------------------ | -------------------------------------
| **Overall Architecture** | High‑level system view
| **Feature Architecture** | Detailed design per feature
| **ADR**                  | One architectural decision

---

## 3  Implementation Details

### Workflow State Integration

The architecting agent must:
1. Read `archflow/workflow-state.md` to understand current iteration context and any previous iteration learnings
2. Update workflow state with architecture deliverable status as work progresses
3. Run validation gate checks before completion
4. Update workflow state with validation results

### Validation Gate: Architecture → Planning

**Exit Criteria:**
- ADR addresses all stated requirements with clear problem statement and solution rationale
- Technical approach is feasible with current technology stack and available dependencies
- Performance, security, and scalability requirements are addressable with chosen approach
- No conflicting business requirements or architectural constraints
- Dependencies are available and version-compatible
- Solution aligns with existing system architecture and patterns

**Validation Process:**
```yaml
architecture_validation:
  adr_completeness:
    - problem_statement_clear: true
    - solution_approaches_evaluated: true
    - decision_rationale_documented: true
    - consequences_identified: true
    - alternatives_considered: true
  technical_feasibility:
    - dependencies_available_and_compatible: true
    - technology_stack_alignment: true
    - performance_requirements_addressable: true
    - security_requirements_addressable: true
  business_alignment:
    - requirements_fully_addressed: true
    - constraints_respected: true
    - success_criteria_defined: true
    - stakeholder_concerns_addressed: true
```

### Roo Code Implementation

#### Delegated Task Contract (must be injected verbatim in every `new_task`)

When the Orchestrator delegates a task using the new_task tool, the instructions provided to the specialized agent must include:

* Context: All relevant details from the parent task, current iteration context from workflow-state.md, previous iteration learnings, and overall goal.
* Scope: A clear, precise definition of what the subtask should accomplish.
* Files: A list of the specific files the agent should work on for this step (if applicable).
* Focus: An explicit statement that the subtask must only perform the outlined work and not deviate or expand scope.
* Outcome: A description of the desired state or result upon successful completion of the task, including validation gate passage.
* Completion: An instruction to use the attempt_completion tool upon finishing. The result parameter should contain a concise yet thorough summary confirming task execution, validation gate results, and commit details. This summary is crucial for tracking progress.
* Instruction Priority: A statement clarifying that these specific subtask instructions override any conflicting general instructions the agent mode might have.
* Workflow Steps: Include all relevant workflow steps the task should complete, including validation checks
* Mode Restriction: A statement prohibiting the subtask agent from switching modes itself; it must complete its assigned task and then call attempt_completion.

#### Scope & Delegation Rules

* Creates/updates ADRs, Feature docs, Overall Architecture, and commits changes.
* May delegate ONLY to `Researcher`.
* Must update workflow-state.md with deliverable status and validation results.
* On failure, report back; do not escalate internally.
* **Important** **Do not include** code in the Delegated Task Contract.
* **Important** **Must do research before creating an architecture**
* **Important** **Must pass validation gate before completion**

### Claude Code Implementation

In Claude Code, the architecting phase:
* Uses the TodoWrite tool to track progress through the workflow steps
* Performs extensive code search using Grep/Glob tools instead of delegating to a researcher
* Creates and updates architecture documents following the same structure
* Makes commits with appropriate messages
* Does not delegate tasks - all work is done within the single command execution

---

## 4  Inputs
* High‑level feature description (from user or previous phase)
* Existing architecture docs (paths)
* In Roo Code: Delegated Task Contract
* In Claude Code: User's feature request via command arguments

## 5  Workflow

### Roo Code Workflow
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

### Claude Code Workflow
```yaml
state: ARCHITECTING
agent: claude
delegate: false
steps:
    - Read workflow-state.md to understand current iteration context and learnings
    - Use TodoWrite to create task list for architecture phase
    - Gather Context:
        - Load existing architecture docs
        - Use Grep/Glob to search codebase for relevant patterns
        - Analyze project structure and dependencies
        - Review any previous iteration context and learnings
    - Create ADR:
        - Copy `archflow/architecture/adr/0000-template.md` → `archflow/architecture/adr/YYYYMMDDHHMMSS-<adrName>.md`
        - Ask clarifying questions if needed
        - Fill sections with full relative paths in links
        - Address any issues from previous iterations
    - Update or create feature architecture:
        - If new, copy `archflow/architecture/features/template.md` → `archflow/architecture/features/YYYYMMDDHHMMSS-<featureName>.md`
        - Ensure consistency with ADR
        - Fill all required sections
    - Update overall architecture:
        - Read `archflow/architecture/overall-architecture.md`
        - Update with major architectural changes
    - Run validation gate checks:
        - Verify ADR completeness and clarity
        - Validate technical feasibility with current stack
        - Check business alignment and requirement coverage
        - Ensure no conflicting constraints
    - Update workflow-state.md with architecture deliverable status and validation results
    - Commit changes with descriptive message
    - Mark all todos as completed
```