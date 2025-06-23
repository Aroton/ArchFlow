# ArchFlow Unified Workflow Command

Complete end-to-end ArchFlow workflow orchestration for feature development.

## Usage
- `/archflow "feature description"` - Execute complete ArchFlow workflow

## Instructions

### Workflow Initialization
1. **Initialize workflow state management**:
   - Create `archflow/workflow-state.md` if not exists, or load existing iteration context
   - Initialize folder structure: `archflow/`, `archflow/architecture/`, `archflow/plans/`, `archflow/archive/workflow-history/`
   - Document feature description, iteration number, and current phase

2. **Create master todo list for phases**:
   - Use TodoWrite to create Level 1 todos for workflow phases:
     - ARCHITECTING Phase
     - PLANNING Phase  
     - EXECUTING Phase
     - VERIFYING Phase
   - Track iteration context and validation gate results

3. **Load any existing iteration context**:
   - If workflow-state.md exists, extract previous iteration learnings
   - Identify target phase for continuation
   - Preserve all context and findings from previous attempts

### Phase Orchestration (with Validation Gates)

#### 1. ARCHITECTING PHASE
Execute architecting workflow with comprehensive research and documentation:

- **Mark "ARCHITECTING Phase" todo as in_progress**
- **Read workflow-state.md** to understand current iteration context and learnings
- **Use TodoWrite** to create task list for architecture phase
- **Gather Context**:
  - Load existing architecture docs using Read tool
  - Use Grep/Glob to search codebase for relevant patterns
  - Analyze project structure and dependencies
  - Review any previous iteration context and learnings
- **Create ADR**:
  - Copy `archflow/architecture/adr/0000-template.md` → `archflow/architecture/adr/YYYYMMDDHHMMSS-<adrName>.md`
  - Ask clarifying questions if needed
  - Fill sections with full relative paths in links
  - Address any issues from previous iterations
- **Update or create feature architecture**:
  - If new, copy `archflow/architecture/features/template.md` → `archflow/architecture/features/YYYYMMDDHHMMSS-<featureName>.md`
  - Ensure consistency with ADR
  - Fill all required sections
- **Update overall architecture**:
  - Read `archflow/architecture/overall-architecture.md`
  - Update with major architectural changes

- **Run Architecture → Planning validation gate**:
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
- **Update workflow-state.md** with architecture deliverable status and validation results
- **Commit changes** with descriptive message
- **Mark architecture todos as completed**

**On validation gate failure**:
- Update workflow-state.md with failure details and required improvements
- Increment iteration counter
- Return to Architecting phase with preserved context
- If max iterations exceeded (3), provide detailed failure report and exit

**On validation gate success**:
- Mark Architecting todo as "completed"
- Update workflow-state.md with successful architecture deliverables
- Proceed to Planning phase

#### 2. PLANNING PHASE
Execute planning workflow with detailed implementation breakdown:

- **Mark "PLANNING Phase" todo as in_progress**
- **Read workflow-state.md** to understand current iteration context
- **Use TodoWrite** to create task list for planning phase
- **Review architecture docs** (ADR and Feature Architecture)
- **Identify external dependencies** using package.json analysis
- **Decompose work into atomic steps**:
  - Each step should be standalone and testable
  - Apply complexity scoring system instead of rigid file limits:
    - Calculate complexity score based on multiple factors
    - Suggest refactoring if complexity score exceeds threshold
    - Consider lines changed, dependencies affected, risk level
  - Suggest model complexity for each step (Opus/Sonnet)
  - Include comprehensive complexity scoring and risk assessment
  - Define explicit success criteria for each step beyond technical completion
- **Research codebase**:
  - Use Grep/Glob to analyze existing patterns
  - Identify impacted files and dependencies
  - Understand current implementation approaches
- **Write plan**:
  - Copy `archflow/plans/0000-template.md` → `archflow/plans/YYYYMMDDHHMMSS-<adrName>.md`
  - Fill all sections following template structure
  - Set all steps to `status: scheduled`
  - Include full relative paths in all references
  - Add comprehensive dependency mapping with cross-feature impact analysis
  - Include structured risk assessment covering technical, business, and timeline factors
  - Define measurable success criteria for each step

- **Run Planning → Execution validation gate**:
  ```yaml
  planning_validation:
    implementability_check:
      - verify_all_dependencies_available
      - validate_technology_choices
      - confirm_api_compatibility
    complexity_analysis:
      - calculate_complexity_scores_per_step
      - identify_high_risk_steps_above_threshold
      - validate_resource_estimates_with_buffers
    risk_assessment:
      - technical_risks: dependency failures, integration issues, performance
      - business_risks: scope creep, requirement changes, stakeholder alignment
      - timeline_risks: complexity underestimation, external dependencies
    integration_validation:
      - map_step_dependencies_with_impact_analysis
      - identify_potential_conflicts_and_mitigation
      - validate_comprehensive_testing_approach
  ```
- **Update workflow-state.md** with planning deliverable status and validation results
- **Commit plan** with descriptive message
- **Mark planning todos as completed**

**On validation gate failure**:
- Update workflow-state.md with failure details and required plan improvements
- Increment iteration counter
- Determine iteration target (Planning refinement or return to Architecture)
- Route to target phase with preserved context
- If max iterations exceeded (3), provide detailed failure report and exit

**On validation gate success**:
- Mark Planning todo as "completed"
- Update workflow-state.md with successful planning deliverables
- Proceed to Executing phase

#### 3. EXECUTING PHASE
Execute implementation with smart sequential execution and progressive validation:

- **Mark "EXECUTING Phase" todo as in_progress**
- **Read workflow-state.md** to understand current iteration context
- **Use TodoWrite** to create task list from plan steps
- **Read plan file** to understand all implementation steps with dependencies
- **Analyze step dependencies** and build execution graph:
  - Identify critical path (longest dependency chain)
  - Group independent steps for batch processing
  - Calculate optimal execution order
  - Determine validation strategy per step based on complexity score
- **Smart Sequential Execution with Progressive Validation**:
  - For each step/batch in optimized order:
    - Mark todo(s) as in_progress
    - Update plan file: set step.status to "in_progress"
    - Update workflow-state.md with current execution progress
    - **Capability Matrix Validation Assignment**:
      - Score 0-5: fast_checks only (syntax, imports, type checking, basic linting)
      - Score 6-8: fast_checks + medium_checks (unit tests, integration tests for affected components)
      - Score 9-12: fast_checks + medium_checks + selective_heavy_checks
      - Score 13+: full_validation_suite
    - **Pre-Step Validation**: Verify prerequisites, architectural assumptions, dependencies
    - **Implementation**: Read files, make modifications, create new files as needed
    - **Fast Validation**: Run syntax validation, check imports, type checking, basic linting
    - **Risk-Based Additional Validation**: Based on complexity, run affected tests and integration checks
    - **Failure Recovery with Graduated Escalation**:
      - Attempt 1: Local fix within step scope
      - Attempt 2: Alternative implementation approach
      - Attempt 3: User consultation + scope reduction
      - Attempt 4: Step rollback with technical debt tracking
      - Attempt 5: Escalate to planning iteration
    - **Rollback Mechanisms**: Step-level, batch-level, or checkpoint rollback as needed
    - **Completion**: Update plan status to "complete", commit with flexible strategy, mark todo completed
- **Milestone and Final Validation**:
  - Run milestone validation every 5 steps (medium checks)
  - Run final validation gate checks before phase completion

- **Run Execution → Verification validation gate**:
  - All planned steps implemented and marked complete
  - Code builds successfully without errors
  - All unit tests pass for implemented functionality
  - Integration points function correctly
  - Implementation matches architectural intent from ADR
  - No critical security or performance issues introduced
- **Update workflow-state.md** with execution completion and validation results
- **Mark execution todos as completed**

**On validation gate failure**:
- Update workflow-state.md with failure details and execution issues
- Increment iteration counter
- Determine iteration target based on failure type:
  - Implementation issues: return to Executing phase
  - Design issues: return to Planning phase
  - Architectural conflicts: return to Architecture phase
- Route to target phase with preserved context
- If max iterations exceeded (3), provide detailed failure report and exit

**On validation gate success**:
- Mark Executing todo as "completed"
- Update workflow-state.md with successful execution deliverables
- Proceed to Verifying phase

#### 4. VERIFYING PHASE
Execute comprehensive verification across technical, business, and quality dimensions:

- **Mark "VERIFYING Phase" todo as in_progress**
- **Read workflow-state.md** to understand complete development context
- **Use TodoWrite** to create verification task list
- **Read completed plan file** and all architecture documents
- **Run Technical Validation**:
  - Execute full test suite (unit, integration, end-to-end)
  - Run linting and type checking
  - Check build succeeds
  - Run security scanning
  - Document any failures
- **Perform Business Validation**:
  - Verify original requirements are met
  - Check acceptance criteria satisfied
  - Validate user story completion
  - Assess performance benchmarks
- **Run Quality Validation**:
  - Review code quality standards compliance
  - Check documentation completeness
  - Validate testing coverage adequacy
  - Verify operational readiness
- **Perform comprehensive code review**:
  - Review all commits since plan creation
  - Compare implementation against plan steps and ADR
  - Validate code follows project standards
  - Check business logic matches architecture
  - Verify integration points function correctly
- **Generate comprehensive verification report**:
  - List all verification levels and results
  - Document code review findings
  - Summarize any issues found
  - Provide iteration recommendations if needed

- **Run Verification → Complete validation gate**:
  ```yaml
  verification_levels:
    technical_validation: [automated_checks, manual_checks]
    business_validation: [requirement_validation, stakeholder_validation]
    quality_validation: [maintainability, operational_readiness]
  iteration_triggers:
    return_to_execution: [critical_bugs, performance_issues, integration_failures]
    return_to_planning: [flawed_approach, wrong_estimates, dependency_issues]
    return_to_architecture: [requirement_mismatch, architectural_violations]
    complete_success: [all_levels_pass, stakeholder_acceptance, quality_gates_satisfied]
  ```
- **Update workflow-state.md** with verification results
- **Mark verification todos as completed**

**On validation gate failure**:
- Update workflow-state.md with failure details and verification issues
- Increment iteration counter
- Determine iteration target based on failure type:
  - Critical bugs/performance: return to Executing phase
  - Implementation approach flawed: return to Planning phase
  - Fundamental requirement mismatch: return to Architecture phase
- Route to target phase with preserved context
- If max iterations exceeded (3), provide detailed failure report and exit

**On validation gate success**:
- Mark Verifying todo as "completed"
- Update workflow-state.md with successful verification results
- Proceed to Completion

### Iteration Handling
When any validation gate fails:
1. **Increment iteration counter** in workflow-state.md
2. **Update workflow state** with failure context, learnings, and detailed reasoning
3. **Determine iteration target**:
   - **Current phase**: Minor issues, missing details, scope adjustments
   - **Previous phase**: Implementation approach issues, resource estimate problems
   - **Architecture phase**: Fundamental design flaws, invalid assumptions, requirement mismatches
4. **Route execution** to determined target phase with preserved context
5. **Resume workflow** from target phase with all previous learnings intact
6. **If max iterations exceeded (3)**: Provide detailed failure report with complete context and exit

### Completion and Archival
Upon successful validation gate passage:
1. **Archive workflow-state.md**:
   - Create timestamp-based filename: `YYYYMMDD-HHMMSS-<feature-name>-workflow.md`
   - Move to `archflow/archive/workflow-history/`
   - Preserve complete audit trail of iterations and decisions
2. **Provide comprehensive completion report**:
   - Summary of all phases completed
   - Total iterations required
   - Key architectural decisions made
   - Implementation highlights
   - Quality metrics achieved
   - Archive location reference
3. **Mark all master todos as completed**
4. **Commit archival** with descriptive message

## Error Handling

- **If validation gate fails**: Update workflow state with detailed failure context, determine iteration target based on failure type, route to appropriate phase with preserved context
- **If max iterations exceeded**: Provide comprehensive failure report including all iteration attempts, failure reasons, context preservation, and recommendations for manual intervention
- **If critical error occurs**: Preserve workflow state with complete context, provide detailed recovery instructions, maintain audit trail for debugging

## Example Output

```
ArchFlow Workflow: User Authentication System
========================================

Phase 1/4: ARCHITECTING ✅ (Iteration 1)
- Created ADR: 20240120143000-user-auth-system.md
- Updated Feature Architecture: 20240120143000-authentication-feature.md
- Updated Overall Architecture
- Validation Gate: PASSED
  ✓ ADR completeness verified
  ✓ Technical feasibility confirmed
  ✓ Business alignment validated

Phase 2/4: PLANNING ✅ (Iteration 2) 
- Created Implementation Plan: 20240120143000-auth-implementation.md
- 8 atomic steps identified (complexity scores 3-9)
- Comprehensive dependency mapping completed
- Risk assessment covering technical/business/timeline factors
- Validation Gate: PASSED (retry after complexity refinement)
  ✓ All dependencies available and compatible
  ✓ Complexity scores within acceptable bounds
  ✓ Resource estimates validated with buffers

Phase 3/4: EXECUTING ✅ (Iteration 1)
- Implemented 8/8 steps using smart sequential execution
- Progressive validation: fast_checks + medium_checks per complexity
- All builds successful, all tests passing
- No rollbacks required, no technical debt introduced
- Validation Gate: PASSED
  ✓ All planned steps complete
  ✓ Build and test success
  ✓ Integration points functional
  ✓ Architectural compliance verified

Phase 4/4: VERIFYING ✅ (Iteration 1)
- Technical validation: PASSED (full test suite, build, lint, security scan)
- Business validation: PASSED (requirements met, acceptance criteria satisfied)
- Quality validation: PASSED (code quality, documentation, coverage, operational readiness)
- Comprehensive code review: PASSED (standards compliance, architectural alignment)
- Validation Gate: PASSED
  ✓ All verification levels satisfied
  ✓ No iteration triggers identified
  ✓ Complete success criteria met

✅ WORKFLOW COMPLETED SUCCESSFULLY
- Total iterations: 2 (1 planning refinement)
- Final implementation: 8 steps, 0 technical debt
- Quality metrics: 95% test coverage, 0 security issues, performance within bounds
- Archived: archflow/archive/workflow-history/20240120-143000-user-auth-system-workflow.md
```

