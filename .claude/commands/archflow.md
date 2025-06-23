# ArchFlow Unified Workflow Command

Complete end-to-end ArchFlow workflow orchestration for feature development.

## Usage
- `/archflow "feature description"` - Execute complete ArchFlow workflow

## Instructions

### Workflow Initialization
1. **Initialize workflow state management**:
   - Create or load `archflow/workflow-state.md` with current iteration context
   - Set up workflow tracking with feature description, start time, and iteration counter
   - Initialize folder structure: `archflow/`, `archflow/archive/`, `archflow/archive/workflow-history/`

2. **Create master todo list for phases**:
   - Use TodoWrite to create Level 1 todos for: Architecting, Planning, Executing, Verifying
   - Set initial status to "pending" for all phases
   - Include iteration tracking and validation gate checkpoints

3. **Load any existing iteration context**:
   - Check for existing workflow-state.md from previous iterations
   - Preserve learnings and context from validation gate failures
   - Determine starting phase based on iteration context

### Phase Orchestration (with Validation Gates)

#### 1. ARCHITECTING PHASE
**Execute architecting workflow from agents/architecting.md Claude Code section**:
- Mark Architecting todo as "in_progress"
- Read workflow-state.md to understand current iteration context and learnings
- Use TodoWrite to create task list for architecture phase
- **Gather Context**:
  - Load existing architecture docs
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
- **Commit changes** with descriptive message

**Run Architecture → Planning validation gate**:
- **ADR Completeness Check**:
  - Verify problem statement is clear and complete
  - Confirm solution approaches were evaluated
  - Validate decision rationale is documented
  - Check consequences are identified
  - Ensure alternatives were considered
- **Technical Feasibility Check**:
  - Verify dependencies are available and compatible
  - Confirm technology stack alignment
  - Validate performance requirements are addressable
  - Check security requirements are addressable
- **Business Alignment Check**:
  - Confirm requirements are fully addressed
  - Verify constraints are respected
  - Validate success criteria are defined
  - Check stakeholder concerns are addressed

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
**Execute planning workflow from agents/planning.md Claude Code section**:
- Mark Planning todo as "in_progress"
- Read workflow-state.md to understand current iteration context
- Use TodoWrite to create task list for planning phase
- **Review architecture docs** (ADR and Feature Architecture)
- **Identify external dependencies** using package.json analysis
- **Decompose work into atomic steps**:
  - Each step should be standalone and testable
  - Each step should modify reasonable number of files (suggest refactoring if >15 files)
  - Suggest model complexity for each step (Opus/Sonnet)
  - Include complexity scoring and risk assessment
- **Research codebase**:
  - Use Grep/Glob to analyze existing patterns
  - Identify impacted files and dependencies
  - Understand current implementation approaches
- **Write plan**:
  - Copy `archflow/plans/0000-template.md` → `archflow/plans/YYYYMMDDHHMMSS-<adrName>.md`
  - Fill all sections following template structure
  - Set all steps to `status: scheduled`
  - Include full relative paths in all references
  - Add dependency mapping and risk assessment
- **Commit plan** with descriptive message

**Run Planning → Execution validation gate**:
- **Implementability Check**:
  - Verify all dependencies are available
  - Validate technology choices are feasible
  - Confirm API compatibility
- **Complexity Analysis**:
  - Assess step complexity scores are reasonable
  - Identify high-risk steps
  - Validate resource estimates
- **Integration Validation**:
  - Map step dependencies clearly
  - Identify potential conflicts
  - Validate testing approach

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
**Execute execution workflow from agents/executing.md Claude Code section**:
- Mark Executing todo as "in_progress"
- Read workflow-state.md to understand current iteration context
- Use TodoWrite to create task list from plan steps
- Read plan file to understand all implementation steps
- **For each step in plan**:
  - Mark step todo as "in_progress"
  - Update plan file: set step.status to "in_progress"
  - Update workflow-state.md with current step progress
  - **Run pre-step validation**:
    - Verify step prerequisites are met
    - Check architectural assumptions still valid
    - Confirm dependencies available
  - **Implement code changes for the step**:
    - Read all files specified in step
    - Make necessary modifications
    - Create new files if needed
  - **Run post-step validation**:
    - Run incremental build check
    - Execute related unit tests
    - Validate implementation matches design
    - Check integration points functional
  - **Handle validation failures**:
    - If implementation issue: attempt local fix
    - If design issue: escalate to planning iteration
    - If architectural conflict: return to architecture
  - Update plan file: set step.status to "complete"
  - Commit changes with message: "`<feature>: <summary> - step <id>`"
  - Mark step todo as "completed"

**Run Execution → Verification validation gate**:
- **Overall Validation**:
  - Verify all steps are complete
  - Run full build suite
  - Execute comprehensive test suite
  - Validate architectural compliance
  - Check performance within bounds
- **Implementation Completeness Check**:
  - Confirm all planned steps are implemented
  - Verify code builds successfully without errors
  - Validate all unit tests pass
  - Check integration points function correctly
  - Ensure implementation matches architectural intent

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
**Execute verification workflow from agents/verifying.md Claude Code section**:
- Mark Verifying todo as "in_progress"
- Read workflow-state.md to understand complete development context
- Use TodoWrite to create verification task list
- Read completed plan file and all architecture documents
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

**Run Verification → Complete validation gate**:
- **Technical Validation Gate**:
  - All automated checks pass
  - Manual code review complete
  - Architectural compliance verified
- **Business Validation Gate**:
  - Original requirements satisfied
  - Acceptance criteria met
  - Performance benchmarks achieved
- **Quality Validation Gate**:
  - Code quality standards met
  - Documentation complete
  - Testing coverage adequate
  - Operational readiness verified

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

### Completion
1. **Archive workflow-state.md to archflow/archive/workflow-history/**:
   - Create timestamped filename: `YYYYMMDD-HHMMSS-<feature-name>-workflow.md`
   - Move workflow-state.md to archive location
   - Preserve complete iteration and validation history

2. **Provide comprehensive completion report**:
   - Summary of all phases completed
   - Total iterations used
   - Key deliverables created
   - Validation gate results
   - Archive location

3. **Mark all master todos as completed**:
   - Update TodoWrite with all phases marked as "completed"
   - Provide final progress summary

## Error Handling

### Validation Gate Failures
- **Update workflow state**: Record failure details, context, and required improvements
- **Determine iteration target**: Analyze failure type to route to appropriate phase:
  - Minor issues → return to previous phase
  - Design flaws → return to planning
  - Architectural conflicts → return to architecture
- **Route accordingly**: Resume execution from target phase with full preserved context
- **Iteration limits**: Support maximum 3 iterations before failure reporting

### Critical Errors
- **Preserve workflow state**: Maintain complete context in workflow-state.md
- **Provide recovery instructions**: Clear guidance on how to resume or restart
- **Detailed error reporting**: Include failure context, attempted solutions, and next steps

### Max Iterations Exceeded
- **Provide detailed failure report**: Document all attempts, failures, and context
- **Preserve context**: Maintain workflow-state.md for future recovery attempts
- **Clear recommendations**: Suggest manual intervention points or scope adjustments

## Example Output

```
ArchFlow Workflow: User Authentication System
========================================

Phase 1/4: ARCHITECTING ✅ (Iteration 1)
- Created ADR: 20240120143000-user-auth-system.md
- Updated Feature Architecture: 20240120143000-user-authentication.md
- Updated Overall Architecture
- Validation Gate: PASSED
  ✓ ADR completeness verified
  ✓ Technical feasibility confirmed
  ✓ Business alignment validated

Phase 2/4: PLANNING ✅ (Iteration 2) 
- Created Implementation Plan: 20240120143000-auth-implementation.md
- 8 atomic steps identified
- Complexity scoring completed
- Dependency mapping finalized
- Validation Gate: PASSED (retry after complexity refinement)
  ✓ All steps implementable
  ✓ Complexity within bounds
  ✓ Dependencies available

Phase 3/4: EXECUTING ✅ (Iteration 1)
- Implemented 8/8 steps
- All builds successful
- All tests passing
- Integration points validated
- Validation Gate: PASSED
  ✓ All steps complete
  ✓ Build suite successful
  ✓ Architectural compliance verified

Phase 4/4: VERIFYING ✅ (Iteration 1)
- Technical validation: PASSED
  ✓ Full test suite: 47/47 tests passing
  ✓ Linting: 0 errors, 0 warnings
  ✓ Security scan: No issues found
- Business validation: PASSED
  ✓ Requirements satisfied
  ✓ Acceptance criteria met
- Quality validation: PASSED
  ✓ Code quality standards met
  ✓ Documentation complete
- Validation Gate: PASSED

✅ WORKFLOW COMPLETED SUCCESSFULLY
- Total iterations: 2
- Phases completed: 4/4
- Deliverables created:
  - ADR: archflow/architecture/adr/20240120143000-user-auth-system.md
  - Feature Architecture: archflow/architecture/features/20240120143000-user-authentication.md
  - Implementation Plan: archflow/plans/20240120143000-auth-implementation.md
- Archived: archflow/archive/workflow-history/20240120-143000-user-auth-system-workflow.md
```

## Key Features

### Unified Execution
- Single command orchestrates all phases automatically
- No delegation - all agent workflows executed directly within command
- Seamless phase transitions with validation gates

### TodoWrite Integration
- Multi-level progress tracking:
  - Level 1: Master workflow phases
  - Level 2: Phase-specific tasks
  - Level 3: Step-specific tasks (execution phase)
- Real-time progress updates and completion tracking

### Validation Gates
- Comprehensive validation between each phase
- Automated and manual validation checks
- Clear pass/fail criteria with detailed reporting

### Iteration Support
- Intelligent routing on validation failures
- Context preservation across iterations
- Maximum 3 iterations with detailed failure reporting

### Workflow State Management
- Complete audit trail in workflow-state.md
- Iteration history and validation results
- Automatic archival on successful completion

### Direct Tool Usage
- Extensive use of Grep/Glob for codebase analysis
- Read/Edit/Write for file operations
- Bash for build, test, and validation commands
- No delegation - all work done within single command execution