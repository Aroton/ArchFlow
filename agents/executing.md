# Executing Workflow

```yaml
slug: archflow-executing
name: ArchFlow - Executing
groups: ['read', 'edit', 'command']
source: 'global'
```
Implements code according to the plan, ensuring each step builds, lints, and tests cleanly.

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

| Artifact    | Purpose                    |
| ----------- | -------------------------- |
| Plan file   | Source of steps            |
| Source code | Modified during this phase |

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

#### Scope & Delegation Rules

* Delegates each plan step sequentially to agent defined in the plan
* Escalation: Intern → Junior → Midlevel → Senior.
* Status updates must be performed by the same delegated agent inside its own commit. The parent task must not touch the plan file, or commit files.
* **Important** **Do not include** code in the Delegated Task Contract.
* All steps MUST be completed by the agent defined in the task definition.

### Claude Code Implementation

In Claude Code, the executing phase:
* Uses TodoWrite to track each implementation step from the plan
* Executes all steps within a single command execution (no delegation)
* Updates plan status directly (`scheduled` → `in_progress` → `complete`)
* Runs build, lint, and test commands after each step
* Fixes any issues that arise during validation
* Commits after each completed step with appropriate message
* May suggest switching between Opus/Sonnet models based on step complexity

---

## 4  Inputs

* Path to plan file
* Repository source code
* In Roo Code: Delegated Task Contract
* In Claude Code: Path to plan file via command arguments

---

## 5  Workflow

### Roo Code Workflow
```yaml
state: EXECUTING
agent: archflow-executing
delegate: false
steps:
    - for step in {{plan.steps}}:
        -   state: EXECUTING-STEP
            delegate: true
            agent: "{{step.agent}}"
            steps:
                - "Set `step.status: in_progress`"
                - Modify code
                - run build, fix any issues
                - run lint, fix any issues
                - run unit test, fix any issues
                - "Set `step.status: complete`"
                - "Commit `<feature>: <summary> - <ADRFileName> - step<id>`"
                - Complete task.
    - Complete task
```

### Claude Code Workflow
```yaml
state: EXECUTING
agent: claude
delegate: false
steps:
    - Use TodoWrite to create task list from plan steps
    - Read plan file to understand all implementation steps
    - For each step in plan:
        - Mark todo as in_progress
        - Update plan file: set step.status to "in_progress"
        - Implement code changes for the step:
            - Read all files specified in step
            - Make necessary modifications
            - Create new files if needed
        - Validate implementation:
            - Run build command (infer from project)
            - Fix any build errors
            - Run lint command (infer from project)
            - Fix any lint errors
            - Run test command (infer from project)
            - Fix any test failures
        - Update plan file: set step.status to "complete"
        - Commit changes with message: "<feature>: <summary> - step <id>"
        - Mark todo as completed
    - Verify all steps are complete
    - Final validation of entire implementation
```