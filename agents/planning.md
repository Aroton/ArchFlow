# Planning Workflow

```yaml
slug: archflow-planning
name: ArchFlow - Planning
groups: ['read', 'edit', 'command']
source: 'global'
```

Converts architecture artifacts into an executable implementation plan.

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

| Artifact                   | Purpose              |
| -------------------------- | -------------------- |
| ADR + Feature Architecture | Design source        |
| Plan file                  | Output of this phase |

---

## 3 Agent Mode Descriptions & Capabilities

### Roo Code Agent Modes

*   **Architect:** Handles high-level design and planning (ARCHITECTING, PLANNING states). Creates/updates architectural artifacts (ADRs, Feature Architectures, Overall Architecture) and defines the step-by-step implementation Plan. Can be re-engaged if the planned approach encounters issues.
*   **Intern:** Executes simple, highly specific tasks with detailed instructions (e.g., function names, parameters, purpose provided). Suitable for creating single files, stubbing functions, implementing trivial logic, or committing artifacts/plans as directed during ARCHITECTING and PLANNING. Requires precise guidance for code-writing tasks.
*   **Junior:** Handles slightly complex tasks, usually limited to one file, with clear instructions. Capable but requires explicit direction. Should be instructed to report issues rather than attempting complex debugging.
*   **Midlevel:** Tackles broader tasks potentially spanning multiple files. Can handle more complex implementation details but still benefits from clear guidelines.
*   **Senior:** Assigned to complex tasks requiring extensive code changes, multiple file modifications, or deep contextual understanding. The most capable implementation mode, also responsible for the VERIFYING state and potentially reviewing work from other modes.
*   **Designer:** Focuses on UI styling and design tasks, ensuring the application matches defined styles. Should report non-styling issues rather than attempting to fix them.
*   **Researcher:** Gathers specific information about the codebase (e.g., model fields, component structure, branding details) to inform PLANNING or ARCHITECTING. Can be instructed to search the web if necessary.

### Claude Code Model Selection

In Claude Code, model selection is simpler:
*   **Claude Opus:** For complex tasks, architectural decisions, and comprehensive implementations
*   **Claude Sonnet:** For straightforward tasks, simple implementations, and routine operations

The user may be prompted to switch models based on task complexity.

---

## 4  Implementation Details

### Workflow State Integration

The planning agent must:
1. Read `archflow/workflow-state.md` to understand current iteration context
2. Update workflow state with planning deliverable status
3. Run validation gate checks before completion
4. Update workflow state with validation results

### Validation Gate: Planning → Execution

**Exit Criteria:**
- All plan steps are implementable with available technology
- Complexity estimates are within reasonable bounds (suggest refactoring if >15 files per step)
- Resource requirements are clearly defined and available
- Dependencies between steps are explicitly mapped
- Each step has clear success criteria and testing approach

**Validation Process:**
```yaml
planning_validation:
  implementability_check:
    - verify_all_dependencies_available
    - validate_technology_choices
    - confirm_api_compatibility
  complexity_analysis:
    - assess_step_complexity_scores
    - identify_high_risk_steps
    - validate_resource_estimates
  integration_validation:
    - map_step_dependencies
    - identify_potential_conflicts
    - validate_testing_approach
```

### Roo Code Implementation

#### Delegated Task Contract (must be injected verbatim in every `new_task`)

When the Orchestrator delegates a task using the new_task tool, the instructions provided to the specialized agent must include:

* Context: All relevant details from the parent task, ADR, Feature Architecture, overall goal, current iteration context from workflow-state.md, and how this specific step fits into the larger plan.
* Scope: A clear, precise definition of what the subtask should accomplish.
* Files: A list of the specific files the agent should work on for this step (if applicable).
* Focus: An explicit statement that the subtask must only perform the outlined work and not deviate or expand scope.
* Outcome: A description of the desired state or result upon successful completion of the task, including validation gate passage.
* Completion: An instruction to use the attempt_completion tool upon finishing. The result parameter should contain a concise yet thorough summary confirming task execution, plan status update, validation gate results, and commit details. This summary is crucial for tracking progress.
* Instruction Priority: A statement clarifying that these specific subtask instructions override any conflicting general instructions the agent mode might have.
* Workflow Steps: Include all relevant workflow steps the task should complete, including validation checks
* Mode Restriction: A statement prohibiting the subtask agent from switching modes itself; it must complete its assigned task and then call attempt_completion.

#### Scope & Delegation Rules

* Produces a markdown plan in `plans/` with atomic, testable steps.
* May delegate to `researcher` for code inspection.
* Must NOT include code snippets inside the plan.
* Status can be (`scheduled`, `in_progress`, `complete`)
* Must update workflow-state.md with deliverable status and validation results
* **Important** **Do not include** code in the Delegated Task Contract.
* **Important** **Must do research before creating a plan**
* **Important** **Must pass validation gate before completion**

### Claude Code Implementation

In Claude Code, the planning phase:
* Uses TodoWrite to track progress through planning steps
* Performs code analysis using Grep/Glob tools directly
* Creates a detailed implementation plan with atomic steps
* Instead of assigning agent modes, may suggest model complexity (Opus/Sonnet)
* Commits the plan file with appropriate message
* Does not delegate tasks - all analysis is done within the command

---

## 5  Inputs

* ADR + Feature doc paths
* Existing codebase
* In Roo Code: Delegated Task Contract
* In Claude Code: Path to ADR/Feature docs via command arguments

---

## 6  Workflow

### Roo Code Workflow
```yaml
state: PLANNING
agent: archflow-planning
delegate: false
steps:
    - Review architecture docs
    - Identify external dependencies
    - "decompose work into steps - Each step should":
        - be standalone
        - be shippable
        - be buildable
        - be tested
        - have at most 10 files
        - Analyze the work and assign the appropriate agentMode (intern, junior, midlevel, senior)
    -   state: PLANNING-RESEARCHING
        agent: researcher
        delegate: true
        steps:
            - Load all files provided in context
            - Meet objectives of the delegated task context
            - Complete task
    - write plan:
        - Copy `/archflow/plans/0000-template.md` → `/archflow/plans/YYYYMMDDHHMMSS-<adrName>.md`
        - Fill in all sections - follow the template file
        - "Update (`status: scheduled`)"
        - Must embed *full relative paths* in ADR links.
    - "commit `<feature>: <summary> - <ADRFileName>`"
    - complete task
```

### Claude Code Workflow
```yaml
state: PLANNING
agent: claude
delegate: false
steps:
    - Read workflow-state.md to understand current iteration context
    - Use TodoWrite to create task list for planning phase
    - Review architecture docs (ADR and Feature Architecture)
    - Identify external dependencies using package.json analysis
    - Decompose work into atomic steps:
        - Each step should be standalone and testable
        - Each step should modify reasonable number of files (suggest refactoring if >15 files)
        - Suggest model complexity for each step (Opus/Sonnet)
        - Include complexity scoring and risk assessment
    - Research codebase:
        - Use Grep/Glob to analyze existing patterns
        - Identify impacted files and dependencies
        - Understand current implementation approaches
    - Write plan:
        - Copy `archflow/plans/0000-template.md` → `archflow/plans/YYYYMMDDHHMMSS-<adrName>.md`
        - Fill all sections following template structure
        - Set all steps to `status: scheduled`
        - Include full relative paths in all references
        - Add dependency mapping and risk assessment
    - Run validation gate checks:
        - Verify implementability of all steps
        - Validate complexity estimates and resource requirements
        - Check dependency mapping completeness
    - Update workflow-state.md with planning deliverable status and validation results
    - Commit plan with descriptive message
    - Mark all todos as completed
```