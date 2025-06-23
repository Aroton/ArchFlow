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

### Progressive Validation System

```yaml
progressive_validation:
  fast_checks: # Run immediately per step
    - syntax_validation: "Check code compiles/parses correctly"
    - import_dependency_check: "Verify imports and dependencies resolve"
    - type_checking: "Run type checker if applicable (TypeScript, mypy, etc.)"
    - lint_check: "Basic linting for style and simple errors"
  
  medium_checks: # Run for steps affecting specific components
    - unit_tests_affected_components: "Run tests for directly modified components"
    - integration_tests_affected_endpoints: "Test endpoints/APIs modified by step"
    - dependency_impact_analysis: "Check if changes break dependent code"
  
  heavy_checks: # Run only at milestone boundaries or high-risk steps
    - full_test_suite: "Complete test suite execution"
    - performance_testing: "Performance benchmarks for critical path changes"
    - security_scanning: "Security analysis for authentication/authorization changes"
    - end_to_end_testing: "Full user workflow validation"

validation_triggers:
  risk_based_validation:
    low_risk_steps: ["fast_checks"]
    medium_risk_steps: ["fast_checks", "medium_checks"]
    high_risk_steps: ["fast_checks", "medium_checks", "heavy_checks"]
  milestone_boundaries:
    - after_every_5_steps: ["medium_checks"]
    - before_phase_completion: ["heavy_checks"]
```

### Smart Sequential Execution

```yaml
smart_execution:
  dependency_analysis:
    - build_dependency_graph_from_plan
    - identify_critical_path: "Longest dependency chain determining minimum timeline"
    - group_independent_steps: "Steps that can be batched together"
    - calculate_optimal_ordering: "Minimize context switching and dependencies"
  
  batch_processing:
    - group_related_steps: "Steps modifying same component/area"
    - batch_validation: "Run validation once per batch instead of per step"
    - batch_commits: "Option to commit batches vs individual steps"
  
  execution_strategy:
    - execute_critical_path_first: "Ensure longest dependency chain completes early"
    - fill_parallel_opportunities: "Execute independent steps in logical groups"
    - context_preservation: "Maintain context across related steps"
```

### Failure Recovery Workflows

```yaml
failure_recovery:
  step_level_recovery:
    attempt_1: 
      - local_fix_attempt: "Try to fix issue within current step scope"
      - alternative_implementation: "Try different approach for same step"
      - scope_reduction: "Implement minimal viable version of step"
    
    attempt_2:
      - user_consultation: "Present issue and get user guidance"
      - dependency_relaxation: "Check if step dependencies can be modified"
      - step_deferral: "Mark step as deferred with technical debt tracking"
    
    attempt_3:
      - step_rollback: "Git reset to state before failing step"
      - skip_with_documentation: "Skip step and document as technical debt"
      - escalate_to_planning: "Return to planning with detailed failure context"
  
  graduated_escalation:
    iteration_1: "Local recovery attempts within execution phase"
    iteration_2: "User consultation + alternative approaches"
    iteration_3: "Scope reduction + essential-only implementation"
    iteration_4: "Manual intervention required - detailed failure report"
  
  rollback_mechanisms:
    step_rollback: "Undo changes from failing step only (git reset --soft)"
    batch_rollback: "Undo entire batch if critical step fails"
    checkpoint_rollback: "Return to last milestone validation point"
    phase_rollback: "Return to planning phase with preserved context"
```

### Capability Matrix System

```yaml
capability_matrix:
  complexity_to_validation_mapping:
    score_0_5: # Simple changes
      validation: ["fast_checks"]
      recovery_attempts: 2
      rollback_granularity: "step_level"
      examples: ["documentation updates", "simple config changes", "basic styling"]
    
    score_6_8: # Moderate changes  
      validation: ["fast_checks", "medium_checks"]
      recovery_attempts: 3
      rollback_granularity: "step_level_with_dependency_check"
      examples: ["single component implementation", "API endpoint addition", "database schema update"]
    
    score_9_12: # Complex changes
      validation: ["fast_checks", "medium_checks", "selective_heavy_checks"]
      recovery_attempts: 4
      rollback_granularity: "batch_level"
      examples: ["multi-component features", "integration implementations", "performance optimizations"]
    
    score_13+: # High complexity
      validation: ["full_validation_suite"]
      recovery_attempts: 5
      rollback_granularity: "checkpoint_level"
      user_consultation: "required_at_attempt_2"
      examples: ["architectural changes", "major refactoring", "security implementations"]
  
  model_recommendations:
    score_0_5: "Sonnet - straightforward implementation"
    score_6_8: "Sonnet - moderate complexity"
    score_9_12: "Opus - complex logic and integration"
    score_13+: "Opus - architectural complexity"
  
  risk_based_approaches:
    low_risk: 
      validation_depth: "minimal"
      recovery_strategy: "local_fix_primary"
      user_intervention: "only_on_repeated_failure"
    
    medium_risk:
      validation_depth: "moderate"
      recovery_strategy: "graduated_approaches"
      user_intervention: "at_iteration_2"
    
    high_risk:
      validation_depth: "comprehensive"
      recovery_strategy: "conservative_with_rollback"
      user_intervention: "proactive_consultation"
```

### Simplified Delegation Model

```yaml
simplified_delegation:
  core_requirements: # Reduced from 9 to 4 essential elements
    - step_context: "What this step accomplishes and why"
    - technical_scope: "Specific files and changes required"
    - success_criteria: "How to know the step is complete"
    - failure_handling: "What to do if step fails"
  
  automatic_capability_assignment:
    based_on_complexity_score: "Use capability matrix for automatic assignment"
    escalation_triggers: "Automatic escalation based on failure patterns"
    context_preservation: "Maintain execution context across attempts"
```

### Roo Code Implementation

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
* Uses TodoWrite to track each implementation step from the plan with dependency analysis
* Executes steps using smart sequential execution with batch processing opportunities
* Implements progressive validation system with risk-based validation depth
* Updates plan status with granular tracking (`scheduled` → `in_progress` → `complete` → `validated`)
* Uses capability matrix to determine validation requirements and recovery strategies
* Implements step-level rollback and graduated failure recovery
* Commits using flexible strategy (per-step, per-batch, or per-milestone)
* Automatically suggests model switching based on complexity scoring
* Provides user consultation at iteration boundaries for complex failures
* Maintains execution context and technical debt tracking across recovery attempts

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
execution_strategy: smart_sequential_with_progressive_validation
steps:
    # Execution Planning & Analysis
    - Read workflow-state.md to understand current iteration context
    - Use TodoWrite to create task list from plan steps
    - Read plan file to understand all implementation steps with dependencies
    - Analyze step dependencies and build execution graph:
        - Identify critical path (longest dependency chain)
        - Group independent steps for batch processing
        - Calculate optimal execution order
        - Determine validation strategy per step based on complexity score
    
    # Smart Sequential Execution with Progressive Validation
    - For each step/batch in optimized order:
        - Mark todo(s) as in_progress
        - Update plan file: set step.status to "in_progress"
        - Update workflow-state.md with current execution progress
        
        # Capability Matrix Validation Assignment
        - Determine validation level based on complexity score:
            - Score 0-5: fast_checks only
            - Score 6-8: fast_checks + medium_checks
            - Score 9-12: fast_checks + medium_checks + selective_heavy_checks
            - Score 13+: full_validation_suite
        
        # Pre-Step Validation (Fast Checks)
        - Verify step prerequisites met (dependency analysis)
        - Check architectural assumptions still valid
        - Confirm dependencies available
        
        # Implementation with Progressive Validation
        - Implement code changes for the step:
            - Read all files specified in step
            - Make necessary modifications
            - Create new files if needed
            
        # Fast Validation (Immediate)
        - Run syntax validation
        - Check imports and dependencies
        - Run type checking if applicable
        - Basic linting checks
        
        # Risk-Based Additional Validation
        - If medium/high complexity: run affected unit tests
        - If high complexity: run integration tests for modified endpoints
        - If architectural impact: validate compliance
        
        # Failure Recovery with Graduated Escalation
        - Handle validation failures using capability matrix:
            - Attempt 1: Local fix within step scope
            - Attempt 2: Alternative implementation approach
            - Attempt 3: User consultation + scope reduction
            - Attempt 4: Step rollback with technical debt tracking
            - Attempt 5: Escalate to planning iteration
        
        # Rollback Mechanisms
        - Step-level rollback: Git reset to previous step state
        - Batch-level rollback: Undo entire related batch
        - Checkpoint rollback: Return to milestone validation point
        
        # Completion and Tracking
        - Update plan file: set step.status to "complete"
        - Flexible commit strategy:
            - Per-step commits for independent changes
            - Batch commits for related changes
            - Milestone commits for major functionality
        - Mark todo as completed
        - Update technical debt tracking if applicable
    
    # Milestone and Final Validation
    - Run milestone validation every 5 steps (medium checks)
    - Run final validation gate checks:
        - Verify all steps complete with proper validation
        - Run comprehensive test suite (heavy checks)
        - Validate architectural compliance
        - Check performance benchmarks if applicable
    
    # Context Preservation and Completion
    - Update workflow-state.md with execution completion and validation results
    - Document any technical debt or deferred steps
    - Provide detailed execution report with metrics:
        - Steps completed vs deferred
        - Validation failures and recovery actions
        - Technical debt introduced
        - Performance impact
```