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

### Workflow State Integration

The verifying agent must:
1. Read `archflow/workflow-state.md` to understand complete development context
2. Compare implementation against original requirements and architectural decisions
3. Run comprehensive verification including business validation
4. Update workflow state with final verification results
5. Archive workflow state on successful completion

### Verification Levels

**Graduated Verification System:**
```yaml
verification_levels:
  technical_validation:
    automated_checks:
      - full_test_suite_execution
      - build_verification
      - lint_and_type_checking
      - security_scanning
    manual_checks:
      - code_review_against_plan
      - architectural_compliance_review
      - integration_testing_validation
    
  business_validation:
    requirement_validation:
      - original_requirements_met
      - acceptance_criteria_satisfied
      - user_story_completion_verified
    stakeholder_validation:
      - feature_demonstration_successful
      - performance_benchmarks_met
      - usability_requirements_satisfied
      
  quality_validation:
    maintainability:
      - code_quality_standards_met
      - documentation_complete
      - testing_coverage_adequate
    operational_readiness:
      - deployment_readiness_verified
      - monitoring_instrumentation_present
      - error_handling_comprehensive
```

### Iteration Triggers

**When to Trigger Iterations:**
```yaml
iteration_triggers:
  return_to_execution:
    - critical_bugs_discovered
    - performance_thresholds_not_met
    - integration_failures_found
    - missing_functionality_identified
    
  return_to_planning:
    - implementation_approach_fundamentally_flawed
    - resource_estimates_significantly_wrong
    - dependency_issues_require_redesign
    
  return_to_architecture:
    - fundamental_requirement_mismatch
    - architectural_principles_violated
    - scalability_concerns_identified
    - security_model_insufficient
    
  complete_success:
    - all_verification_levels_pass
    - stakeholder_acceptance_confirmed
    - quality_gates_satisfied
```

### Roo Code Implementation

#### Delegated Task Contract (must be injected verbatim in every `new_task`)

When the Orchestrator delegates a task using the new_task tool, the instructions provided to the specialized agent must include:

* Context: All relevant details from the parent task, ADR, Feature Architecture, overall goal, complete iteration history from workflow-state.md, and how this verification fits into the larger plan.
* Scope: A clear, precise definition of what the subtask should accomplish including all verification levels.
* Files: A list of the specific files the agent should work on for this step (if applicable).
* Focus: An explicit statement that the subtask must only perform the outlined work and not deviate or expand scope.
* Outcome: A description of the desired state or result upon successful completion of the task, including comprehensive verification results.
* Completion: An instruction to use the attempt_completion tool upon finishing. The result parameter should contain a concise yet thorough summary confirming task execution, verification results, iteration recommendations, and workflow archival status. This summary is crucial for tracking progress.
* Instruction Priority: A statement clarifying that these specific subtask instructions override any conflicting general instructions the agent mode might have.
* Workflow Steps: Include all relevant workflow steps the task should complete, including all verification levels
* Mode Restriction: A statement prohibiting the subtask agent from switching modes itself; it must complete its assigned task and then call attempt_completion.

**Important** Do not include code snippets in the task contract.

#### Scope & Delegation Rules

* Runs automated + manual checks; cannot delegate further.
* Must update workflow-state.md with comprehensive verification results.
* Must provide clear iteration recommendations with detailed context.
* **Important** **Do not include** code in the Delegated Task Contract.
* On failure, return `success: false` with specific iteration target; Orchestrator decides next steps.
* On success, archive workflow-state.md to workflow-history.

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
    - Read workflow-state.md to understand complete development context
    - Use TodoWrite to create verification task list
    - Read completed plan file and all architecture documents
    - Run Technical Validation:
        - Execute full test suite (unit, integration, end-to-end)
        - Run linting and type checking
        - Check build succeeds
        - Run security scanning
        - Document any failures
    - Perform Business Validation:
        - Verify original requirements are met
        - Check acceptance criteria satisfied
        - Validate user story completion
        - Assess performance benchmarks
    - Run Quality Validation:
        - Review code quality standards compliance
        - Check documentation completeness
        - Validate testing coverage adequacy
        - Verify operational readiness
    - Perform comprehensive code review:
        - Review all commits since plan creation
        - Compare implementation against plan steps and ADR
        - Validate code follows project standards
        - Check business logic matches architecture
        - Verify integration points function correctly
    - Generate comprehensive verification report:
        - List all verification levels and results
        - Document code review findings
        - Summarize any issues found
        - Provide iteration recommendations if needed
    - Update workflow-state.md with verification results:
        - If all checks pass: mark as "verified: true"
        - If issues found: mark as "verified: false" with iteration target
    - Handle completion:
        - If successful: archive workflow-state.md to workflow-history
        - If failed: provide detailed iteration recommendations
    - Commit verification results
    - Present detailed report to user
    - Mark all todos as completed
```