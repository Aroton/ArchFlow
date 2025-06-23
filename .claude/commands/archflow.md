# ArchFlow Unified Workflow Command

Complete end-to-end ArchFlow workflow orchestration for feature development with automatic phase execution, validation gates, and iteration support.

## Usage
- `/archflow "feature description"` - Execute complete ArchFlow workflow with automatic orchestration

## Instructions

### Workflow Initialization

1. **Initialize Workflow State Management**
   - Create `archflow/workflow-state.md` if it doesn't exist
   - Load any existing iteration context and learnings
   - Set workflow status to "initializing"
   - Record feature description and timestamp

2. **Create Master Todo List**
   - Use TodoWrite to create Level 1 todos for master workflow phases:
     - ARCHITECTING: Requirements gathering and architecture design
     - PLANNING: Create detailed implementation plan
     - EXECUTING: Implement all plan phases with verification
     - VERIFYING: Final comprehensive validation
   - Track current iteration number (max 3 iterations)

3. **Set Up Iteration Tracking**
   - Initialize iteration counter (current_iteration: 1)
   - Set max_iterations: 3
   - Prepare context preservation for potential iterations

### Phase Orchestration (with Validation Gates)

#### 1. **ARCHITECTING PHASE**

**Workflow State Update**: Mark phase as "architecting" in workflow-state.md

**Requirements Gathering**:
- Engage user in interactive dialogue about feature requirements
- Ask specific questions about:
  - User stories and acceptance criteria
  - Performance and scalability needs
  - Security and compliance requirements
  - Integration with existing systems
  - Timeline and priority constraints
- Document all requirements in Feature Architecture section 1.2
- Get explicit user confirmation before proceeding

**Context Research**:
- Load existing architecture docs from `archflow/architecture/`
- Use Grep to search codebase for relevant patterns and existing implementations
- Use Glob to find related files and components
- Analyze project structure and dependencies
- Review any previous iteration context from workflow-state.md

**Create ADR (Architecture Decision Record)**:
- Copy template: `~/.archflow/templates/architecture/adr/0000-template.md` → `archflow/architecture/adr/YYYYMMDDHHMMSS-<adrName>.md`
  - **IMPORTANT**: Replace YYYYMMDDHHMMSS with actual timestamp using `date +%Y%m%d%H%M%S` format
  - Example: 20240115143052-user-authentication.md
- Fill all sections with:
  - Clear problem statement
  - Solution approaches evaluated
  - Decision rationale documented
  - Consequences identified
  - Alternatives considered
- Include full relative paths in all links

**Create/Update Feature Architecture**:
- If new: Copy `~/.archflow/templates/architecture/features/template.md` → `archflow/architecture/features/YYYYMMDDHHMMSS-<featureName>.md`
  - **IMPORTANT**: Use same timestamp as ADR for consistency
  - Example: 20240115143052-user-authentication-feature.md
- Document:
  - Complete requirements (functional and non-functional)
  - Technical design details
  - Integration points
  - Success criteria
- Ensure consistency with ADR

**Update Overall Architecture**:
- Read `archflow/architecture/overall-architecture.md`
- Update with major architectural changes
- Ensure new feature integrates cleanly

**Architecture → Planning Validation Gate**:
- Verify ADR completeness:
  - Problem statement clear
  - Solution approaches evaluated
  - Decision rationale documented
  - Consequences identified
- Check technical feasibility:
  - Dependencies available and compatible
  - Technology stack alignment
  - Performance requirements addressable
  - Security requirements addressable
- Validate business alignment:
  - Requirements fully addressed
  - Constraints respected
  - Success criteria defined
- Update workflow-state.md with validation results
- If validation fails:
  - Update workflow state with failure reason
  - Request user guidance
  - Retry architecture phase with adjustments
- If validation passes:
  - Commit: `feat(architecture): add <feature> architecture - <ADRFileName>`
    - Example: `feat(architecture): add user authentication architecture - 20240115143052-user-authentication.md`
  - **STOP and notify user**: "Architecture phase completed. Review the ADR and feature architecture before proceeding."

#### 2. **PLANNING PHASE**

**Workflow State Update**: Mark phase as "planning" in workflow-state.md

**Review Architecture**:
- Load ADR and Feature Architecture documents
- Identify all external dependencies
- Analyze implementation requirements

**Research Codebase**:
- Use Grep/Glob to analyze existing patterns
- Identify files that will be impacted
- Understand current implementation approaches
- Check package.json for available dependencies

**Decompose Work into Atomic Steps**:
- Each step should be:
  - Standalone and testable
  - Buildable independently
  - Have clear success criteria
- Apply complexity scoring (1-15+ scale):
  - Lines of code impact (1-5)
  - Files affected count (weighted)
  - Dependency chain depth (1-3)
  - Technical risk level (1-5)
  - Integration complexity (1-3)
- Include for each step:
  - Explicit success criteria
  - Risk assessment
  - Dependency mapping
  - Suggested model (Opus for complex, Sonnet for simple)

**Organize Steps into Logical Phases**:
- Group 2-8 related steps per phase
- Each phase represents coherent feature/component
- Define for each phase:
  - Phase name and description
  - List of step IDs
  - Phase-level success criteria
  - Verification approach
  - Dependencies on other phases
  - Commit message (conventional format)

**Create Implementation Plan**:
- Copy template: `~/.archflow/templates/plans/0000-template.md` → `archflow/plans/YYYYMMDDHHMMSS-<planName>.md`
  - **IMPORTANT**: Use same timestamp as ADR for traceability
  - Example: 20240115143052-user-authentication-plan.md
- Fill all sections:
  - Overview and objectives
  - Detailed steps with complexity scores
  - Phase organization
  - Success criteria per phase
  - Verification approach
  - Risk assessment
- Set all steps and phases to `status: scheduled`
- Design plan to support real-time status updates during execution

**Planning → Execution Validation Gate**:
- Verify implementability:
  - All dependencies available
  - Technology choices valid
  - API compatibility confirmed
- Check complexity analysis:
  - Complexity scores calculated
  - High-risk steps identified
  - Resource estimates reasonable
- Validate integration:
  - Step dependencies mapped
  - Potential conflicts identified
  - Testing approach comprehensive
- Update workflow-state.md with validation results
- If validation fails:
  - Update workflow state with failure reason
  - Determine if issue requires architecture revision
  - Route to appropriate phase (planning retry or architecture)
- If validation passes:
  - Commit: `feat(planning): create <feature> implementation plan - <PlanFileName>`
    - Example: `feat(planning): create user authentication implementation plan - 20240115143052-user-authentication-plan.md`
  - **STOP and notify user**: "Planning phase completed. Review the implementation plan before proceeding."

#### 3. **EXECUTING PHASE**

**Workflow State Update**: Mark phase as "executing" in workflow-state.md

**Execution Strategy**: Phase-based implementation with continuous verification

**For Each Phase in the Plan**:

1. **Phase Initialization**:
   - Mark phase as "in_progress" in workflow-state.md
   - Create Level 2 todos for all steps in the phase
   - Update plan file: set phase status to "in_progress"

2. **Execute All Steps in Phase**:
   For each step:
   - Update workflow-state.md: mark step as "executing"
   - Update plan file: set step.status to "in_progress"
   
   **Implementation**:
   - Read all files specified in the step
   - Make necessary code modifications
   - Create new files if needed
   - Follow existing code patterns and conventions
   
   **Step-Level Quick Validation** (based on complexity):
   - Low complexity (score 0-5): syntax validation, import checks
   - Medium complexity (score 6-8): + unit tests for affected components
   - High complexity (score 9+): + integration tests, dependency analysis
   
   **Step Completion**:
   - Update plan file: set step.status to "complete"
   - Update workflow-state.md with step completion

3. **Phase Verification** (after all steps complete):
   - Update workflow-state.md: mark phase as "verifying"
   - Run comprehensive phase verification:
     - Execute all unit tests for phase functionality
     - Run integration tests for phase connections
     - Full linting and build verification
     - Verify phase success criteria from plan
     - Test user-facing functionality if applicable
   
   **Handle Verification Results**:
   - If verification passes:
     - Update plan: mark phase as "verified"
     - Update workflow-state.md: phase complete
     - Commit using phase's predefined message from plan
      - Examples:
        - `feat(auth): implement core authentication models`
        - `feat(auth): add authentication endpoints and middleware`
        - `feat(ui): add authentication components and routes`
     - Continue to next phase WITHOUT STOPPING
   
   - If verification fails:
     - Update workflow-state.md with failure details
     - Attempt recovery (based on complexity):
       - Low complexity: fix and retry
       - Medium complexity: consult user if needed
       - High complexity: may require planning revision
     - If recovery fails: stop and request user intervention

4. **User Verification Points**:
   - Only stop for user if:
     - UI/UX changes need visual verification
     - Critical integration points need testing
     - Verification failures require guidance

**Execution → Verification Validation Gate**:
- Check all phases completed successfully
- Verify all steps marked as "complete" or "verified"
- Ensure no critical issues remain unresolved
- Validate builds and tests passing
- If validation fails:
  - Determine appropriate iteration target
  - Update workflow state with context
  - Route to target phase
- If validation passes:
  - Continue to final verification phase

#### 4. **VERIFYING PHASE**

**Workflow State Update**: Mark phase as "final_verification" in workflow-state.md

**Comprehensive Technical Validation**:
- Execute full test suite across all implemented phases
- Run cross-phase integration tests
- Verify all phase success criteria were met
- Run linting and type checking on complete codebase
- Check final build succeeds
- Run security scanning if applicable
- Test performance benchmarks
- Document any issues found

**Business Validation**:
- Verify original requirements are met
- Check acceptance criteria satisfied
- Validate user story completion
- Assess performance against benchmarks
- Confirm integration requirements

**Quality Validation**:
- Review code quality standards compliance
- Check documentation completeness
- Validate testing coverage adequacy
- Verify operational readiness
- Assess maintainability

**Code Review**:
- Review all commits since plan creation
- Compare implementation against plan steps and ADR
- Validate code follows project standards
- Check business logic matches architecture
- Verify integration points function correctly

**Verification → Complete Validation Gate**:
- All technical checks pass
- Business requirements satisfied
- Quality standards met
- No critical issues outstanding
- If validation fails:
  - Generate detailed failure report
  - Determine iteration target (execution, planning, or architecture)
  - Update workflow state with recommendations
  - Initiate iteration with preserved context
- If validation passes:
  - Commit: `chore(verification): complete <feature> verification - <ADRFileName>`
    - Example: `chore(verification): complete user authentication verification - 20240115143052-user-authentication.md`
  - Proceed to completion

### Iteration Handling

**Iteration Triggers and Routing**:

1. **Return to Current Phase**:
   - Minor issues that can be fixed within phase
   - Simple validation failures
   - Retry with adjustments

2. **Return to Previous Phase**:
   - Planning issues discovered during execution
   - Missing steps identified
   - Complexity underestimated

3. **Return to Architecture**:
   - Fundamental requirement mismatch
   - Technology feasibility issues
   - Major design flaws

**Iteration Process**:
- Increment iteration counter
- Update workflow-state.md with:
  - Failure reason and context
  - Lessons learned
  - Required adjustments
- Route to determined target phase
- Resume execution with preserved context
- Maximum 3 iterations before failure

### Completion

1. **Archive Workflow State**:
   - Move `archflow/workflow-state.md` to `archflow/archive/workflow-history/YYYYMMDDHHMMSS-<feature>-workflow.md`
     - **IMPORTANT**: Use `date +%Y%m%d%H%M%S` format for full timestamp
     - Example: `20240115143052-user-authentication-workflow.md`
   - Include final status and metrics

2. **Generate Completion Report**:
   ```
   ✅ WORKFLOW COMPLETED SUCCESSFULLY
   
   Feature: <feature name>
   Total Duration: <time>
   Iterations Required: <count>
   
   Phases Completed:
   - Architecting: <status> (Iteration <n>)
   - Planning: <status> (Iteration <n>)
   - Executing: <status> (Iteration <n>)
   - Verifying: <status> (Iteration <n>)
   
   Deliverables:
   - ADR: <filename>
   - Feature Architecture: <filename>
   - Implementation Plan: <filename>
   - Commits: <count>
   
   Next Steps:
   - <any follow-up recommendations>
   ```

3. **Mark Master Todos Complete**:
   - Update all Level 1 todos as completed
   - Clear any remaining sub-tasks

## Error Handling

### Validation Gate Failures
- Update workflow state with detailed failure context
- Determine appropriate iteration target based on failure type
- Preserve all context and learnings for retry
- Route to target phase with full context

### Maximum Iterations Exceeded
- Generate comprehensive failure report:
  - All iteration attempts and outcomes
  - Blocking issues identified
  - Recommended manual interventions
  - Preserved context for manual completion

### Critical Errors
- Immediately preserve workflow state
- Document error context and stack trace
- Provide recovery instructions
- Suggest rollback options if needed

### Recovery Strategies
- **Local Recovery**: Fix within current phase
- **Phase Rollback**: Return to previous phase
- **Architecture Revision**: Major design changes needed
- **Manual Intervention**: User guidance required

## Example Output

```
ArchFlow Workflow: User Authentication System
============================================

🚀 INITIALIZING WORKFLOW
- Created workflow-state.md
- Set up master todo tracking
- Iteration 1/3

📐 Phase 1/4: ARCHITECTING
- Gathering requirements...
  ✓ Functional requirements documented
  ✓ Non-functional requirements captured
  ✓ User confirmation received
- Researching codebase...
  ✓ Found 3 auth-related patterns
  ✓ Identified integration points
- Creating architecture...
  ✓ ADR: 20240120143000-user-auth-system.md
  ✓ Feature Architecture updated
  ✓ Overall Architecture updated
- Validation Gate: PASSED ✅
- Committed: feat(architecture): add user authentication architecture

[USER CONFIRMATION REQUIRED - Architecture review]

📋 Phase 2/4: PLANNING
- Analyzing implementation requirements...
- Decomposing into 12 atomic steps across 3 phases:
  ✓ Phase 1: Core Auth Models (4 steps, complexity: 6-8)
  ✓ Phase 2: Authentication Flow (5 steps, complexity: 8-10)
  ✓ Phase 3: Integration & UI (3 steps, complexity: 5-7)
- Created Plan: 20240120143500-auth-implementation.md
- Validation Gate: PASSED ✅
- Committed: feat(planning): create auth implementation plan

[USER CONFIRMATION REQUIRED - Plan review]

🔨 Phase 3/4: EXECUTING
Phase 1: Core Auth Models
- Step 1.1: Create User model... ✓
- Step 1.2: Create Session model... ✓
- Step 1.3: Add password hashing... ✓
- Step 1.4: Create auth service... ✓
- Phase verification... PASSED ✅
- Committed: feat(auth): implement core authentication models

Phase 2: Authentication Flow
- Step 2.1: Create login endpoint... ✓
- Step 2.2: Create logout endpoint... ✓
- Step 2.3: Add session middleware... ✓
- Step 2.4: Implement JWT tokens... ✓
- Step 2.5: Add refresh tokens... ✓
- Phase verification... PASSED ✅
- Committed: feat(auth): implement authentication flow

Phase 3: Integration & UI
- Step 3.1: Create login form... ✓
- Step 3.2: Add auth context... ✓
- Step 3.3: Protect routes... ✓
- Phase verification... PASSED ✅
- Committed: feat(auth): add authentication UI and integration

✔️ Phase 4/4: VERIFYING
- Running comprehensive test suite... PASSED
- Cross-phase integration tests... PASSED
- Security scanning... PASSED
- Performance benchmarks... PASSED
- Business requirements... SATISFIED
- Code quality review... APPROVED
- Validation Gate: PASSED ✅
- Committed: chore(verification): complete auth verification

✅ WORKFLOW COMPLETED SUCCESSFULLY
- Total iterations: 1
- Duration: 45 minutes
- Archived: archflow/archive/workflow-history/20240120143052-user-auth-workflow.md

Next Steps:
- Deploy to staging environment
- Conduct user acceptance testing
- Monitor authentication metrics
```

## Notes

- The workflow automatically continues between phases unless user confirmation is explicitly required
- Validation gates ensure quality at each phase boundary
- Iteration support allows recovery from failures without losing progress
- All work is tracked in workflow-state.md for transparency
- TodoWrite is used extensively for multi-level progress tracking
- Each phase follows the detailed workflows from the agent documentation

