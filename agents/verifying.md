# Verifying Workflow

```yaml
slug: archflow-verifying
name: ArchFlow - Verifying
groups: ['read', 'edit', 'command']
source: 'global'
```
Continuous quality assurance—runs verification after each phase during execution and performs final validation. Ensures all success criteria are met, tests pass, and code quality standards are maintained before commits.

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
| Plan file with phases             | Verification target |
| Phase success criteria            | Verification requirements |
| Test results                      | Quality validation |

---

## 3  Implementation Details

### Continuous Verification Integration

Verification happens at multiple points:

#### Phase-Level Verification (During Execution)
- Triggered automatically after each phase completes
- Verifies phase-specific success criteria
- Runs relevant tests for the phase
- Ensures linting and builds pass before commits
- Updates workflow state with phase verification status

#### Final Verification (After All Phases)
- Comprehensive validation of entire implementation
- Cross-phase integration testing
- Business requirement validation
- Performance and security checks
- Final quality gate before completion

### Workflow State Integration

The verifying process must:
1. Read `archflow/workflow-state.md` to understand development context
2. For phase verification:
   - Verify phase implementation against success criteria
   - Run phase-specific tests and quality checks
   - Ensure builds and linting pass
   - Update plan and workflow state
3. For final verification:
   - Compare complete implementation against requirements
   - Run comprehensive test suite
   - Validate business requirements
   - Archive workflow state on success

### Verification Levels

**Graduated Verification System:**
```yaml
verification_levels:
  phase_verification:  # Run after each phase
    automated_checks:
      - phase_unit_tests
      - build_verification 
      - lint_and_type_checking
      - phase_success_criteria
    quality_gates:
      - no_test_failures
      - no_lint_errors
      - build_succeeds
      - criteria_met
      
  final_verification:  # Run after all phases
    automated_checks:
      - full_test_suite_execution
      - cross_phase_integration_tests
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

In Claude Code, verification is integrated into execution:

#### During Execution (Phase Verification):
* Automatically triggered after each phase completes
* Runs phase-specific tests and success criteria checks
* Ensures all linting and builds pass before commits
* Updates plan with phase verification status
* Continues to next phase if verification passes
* Stops and reports issues if verification fails

#### Final Verification:
* Uses TodoWrite to track final verification tasks
* Runs comprehensive test suites across all phases
* Performs code review comparing implementation to plan
* Validates all business requirements are met
* Updates plan file with final verification status
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
verification_mode: continuous_and_final
steps:
    # Phase Verification (Called from Execution)
    - For phase verification:
        - Read phase success criteria from plan
        - Run phase-specific unit tests
        - Run integration tests for phase connections
        - Execute linting and type checking
        - Verify build succeeds
        - Check success criteria are met
        - If pass: update plan phase status to "verified"
        - If fail: report issues for recovery
    
    # Final Verification (After All Phases)
    - For final verification:
        - Run comprehensive test suite (all unit, integration, e2e)
        - Perform full code review:
            - Review all commits since plan creation
            - Validate code conforms to standards
            - Verify business logic matches plan
            - Check architectural compliance
        - Validate all requirements met
        - Pass?:
            - "yes - mark plan as fully verified, commit using `chore(verification): complete <feature> verification - <ADRFileName>`, `attempt_completion success: true`"
            - "no - `attempt_completion success: false` with iteration recommendations"
```

### Claude Code Workflow
```yaml
state: VERIFYING  
agent: claude
delegate: false
verification_mode: integrated_continuous
steps:
    # Phase Verification (Integrated into Execution)
    - Phase verification is embedded in execution workflow:
        - Automatically triggered after phase implementation
        - Reads phase success criteria from plan
        - Executes phase-specific tests
        - Runs linting and build checks
        - Verifies success criteria
        - Updates plan and workflow state
        - Commits only after verification passes
    
    # Final Verification (Standalone Phase)
    - Read workflow-state.md to understand complete development context
    - Use TodoWrite to create final verification task list
    - Read completed plan file and all architecture documents
    - Run Comprehensive Technical Validation:
        - Execute full test suite across all implemented phases
        - Run cross-phase integration tests
        - Verify all phase success criteria were met
        - Run linting and type checking on complete codebase
        - Check final build succeeds
        - Run security scanning if applicable
        - Test performance benchmarks
        - Document any issues found
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
    - Commit verification results using conventional format: `chore(verification): complete <feature> verification - <ADRFileName>`
        - Example: `chore(verification): complete user authentication verification - 20240115143052-user-authentication.md`
    - Present detailed report to user
    - Mark all todos as completed
```