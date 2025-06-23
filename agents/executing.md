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

### Workflow State Integration

The executing agent must:
1. Read `archflow/workflow-state.md` to understand current iteration context
2. Update workflow state with execution progress for each step
3. Run continuous validation during implementation
4. Update workflow state with validation results before completion

### Validation Gate: Execution → Verification

**Exit Criteria:**
- All planned steps are implemented and marked complete
- Code builds successfully without errors
- All unit tests pass for implemented functionality  
- Integration points function correctly
- Implementation matches architectural intent from ADR
- No critical security or performance issues introduced

**Continuous Validation Process:**
```yaml
execution_validation:
  per_step_validation:
    pre_step:
      - validate_step_prerequisites_met
      - check_architectural_assumptions_still_valid
      - verify_dependencies_available
    post_step:
      - run_incremental_build_check
      - execute_related_unit_tests
      - validate_implementation_matches_design
      - check_integration_points_functional
  overall_validation:
    - run_full_build_suite
    - execute_comprehensive_test_suite
    - validate_architectural_compliance
    - check_performance_within_bounds
```

### Failure Escalation Strategy

```yaml
failure_handling:
  implementation_issue:
    - attempt_local_fix
    - if_design_issue: escalate_to_planning_iteration
  architectural_conflict:
    - stop_execution_immediately
    - return_to_architecture_with_detailed_context
  dependency_failure:
    - evaluate_alternative_approaches
    - if_fundamental: return_to_planning_iteration
```

### Roo Code Implementation

#### Delegated Task Contract (must be injected verbatim in every `new_task`)

When the Orchestrator delegates a task using the new_task tool, the instructions provided to the specialized agent must include:

* Context: All relevant details from the parent task, ADR, Feature Architecture, overall goal, current iteration context from workflow-state.md, and how this specific step fits into the larger plan.
* Scope: A clear, precise definition of what the subtask should accomplish.
* Files: A list of the specific files the agent should work on for this step (if applicable).
* Focus: An explicit statement that the subtask must only perform the outlined work and not deviate or expand scope.
* Outcome: A description of the desired state or result upon successful completion of the task, including validation checks.
* Completion: An instruction to use the attempt_completion tool upon finishing. The result parameter should contain a concise yet thorough summary confirming task execution, validation results, plan status update, and commit details. This summary is crucial for tracking progress.
* Instruction Priority: A statement clarifying that these specific subtask instructions override any conflicting general instructions the agent mode might have.
* Workflow Steps: Include all relevant workflow steps the task should complete, including continuous validation
* Mode Restriction: A statement prohibiting the subtask agent from switching modes itself; it must complete its assigned task and then call attempt_completion.

#### Scope & Delegation Rules

* Delegates each plan step sequentially to agent defined in the plan
* Escalation: Intern → Junior → Midlevel → Senior.
* Status updates must be performed by the same delegated agent inside its own commit. The parent task must not touch the plan file, or commit files.
* Must update workflow-state.md with execution progress and validation results.
* **Important** **Do not include** code in the Delegated Task Contract.
* All steps MUST be completed by the agent defined in the task definition.
* **Important** **Must run continuous validation during execution**

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
    - Read workflow-state.md to understand current iteration context
    - Use TodoWrite to create task list from plan steps
    - Read plan file to understand all implementation steps
    - For each step in plan:
        - Mark todo as in_progress
        - Update plan file: set step.status to "in_progress"
        - Update workflow-state.md with current step progress
        - Run pre-step validation:
            - Verify step prerequisites are met
            - Check architectural assumptions still valid
            - Confirm dependencies available
        - Implement code changes for the step:
            - Read all files specified in step
            - Make necessary modifications
            - Create new files if needed
        - Run post-step validation:
            - Run incremental build check
            - Execute related unit tests
            - Validate implementation matches design
            - Check integration points functional
        - Handle validation failures:
            - If implementation issue: attempt local fix
            - If design issue: escalate to planning iteration
            - If architectural conflict: return to architecture
        - Update plan file: set step.status to "complete"
        - Commit changes with message: "<feature>: <summary> - step <id>"
        - Mark todo as completed
    - Run final validation gate checks:
        - Verify all steps complete
        - Run full build suite
        - Execute comprehensive test suite
        - Validate architectural compliance
    - Update workflow-state.md with execution completion and validation results
    - Final validation of entire implementation
```