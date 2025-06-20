# Verifying Workflow

```yaml
slug: archflow-verifying
name: ArchFlow - Verifying
groups: ['read', 'edit', 'command']
source: 'global'
```
Final quality gate—runs verification and marks the plan verified.

## 1 Folder Layout

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

| Artifact                          | Purpose             |
| --------------------------------- | ------------------- |
| Plan file (all steps `completed`) | Verification target |

---

## 3  Implementation Details

### Roo Code Implementation

#### Delegated Task Contract (must be injected verbatim in every `new_task`)

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

**Important** Do not include code snippets in the task contract.

#### Scope & Delegation Rules

* Runs automated + manual checks; cannot delegate further.
* **Important** **Do not include** code in the Delegated Task Contract.
* On failure, return `success: false`; Orchestrator decides next steps.

### Claude Code Implementation

In Claude Code, the verifying phase:
* Uses TodoWrite to track verification tasks
* Runs comprehensive test suites and validation
* Performs code review comparing implementation to plan
* Updates plan file with verification status
* Reports issues clearly to the user
* Does not delegate - all verification is done within the command
* Provides detailed report of verification results

---

## 4  Inputs

* Path to completed plan file
* Current repository state
* In Roo Code: Delegated Task Contract
* In Claude Code: Path to plan file via command arguments

---

## 5  Workflow

### Roo Code Workflow
```yaml
state: VERIFYING
agent: archflow-verifying
delegate: false
steps:
    - Run verification suite (unit, integration, linter)
    - Run code review:
        - Iterate through all diffs
        - Validate code conforms to code standards
        - validate business logic matches plan
    - Pass?:
        - "yes - add `verified: true` to plan, commit, `attempt_completion success: true`"
        - "no - `attempt_completion success: false` with details."
```

### Claude Code Workflow
```yaml
state: VERIFYING
agent: claude
delegate: false
steps:
    - Use TodoWrite to create verification task list
    - Read completed plan file
    - Run automated verification:
        - Execute full test suite (unit, integration)
        - Run linting and type checking
        - Check build succeeds
        - Document any failures
    - Perform code review:
        - Review all commits since plan creation
        - Compare implementation against plan steps
        - Validate code follows project standards
        - Check business logic matches architecture
    - Generate verification report:
        - List all tests run and results
        - Document code review findings
        - Summarize any issues found
    - Update plan file:
        - If all checks pass: add "verified: true"
        - If issues found: add "verified: false" with details
    - Commit verification results
    - Present detailed report to user
    - Mark all todos as completed
```