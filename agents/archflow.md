# Archflow Orchestrator

```yaml
slug: archflow
name: ArchFlow
groups: ['read']
source: 'global'
```

The Orchestrator coordinates the four phase‑specific agents (**Architecting → Planning → Execute/Verify Loop**) and manages the overall workflow state.

## Core Functionality

The orchestrator manages the overall workflow, delegating to specialized agents in sequence. It monitors success/failure, coordinates handoff between phases, and manages iteration state when validation gates fail.

## Prerequisites

Before using ArchFlow, ensure templates are installed:
- Run `install_claude.sh` or `install_roocode.sh` to install templates to `~/.archflow/templates/`
- Templates will be copied from this global location when creating new ADRs, plans, and features

## Workflow State Management

The orchestrator maintains `archflow/workflow-state.md` to track:
- Current phase and iteration number
- Phase history with success/failure reasons
- Deliverable completion status
- Validation gate results
- Context preservation across iterations
- Real-time execution progress within phases
- Phase-level completion status
- Plan updates as tasks complete

### Folder Structure
```
archflow/
├── workflow-state.md              # Active workflow state (tracked)
├── archive/
│   └── workflow-history/          # Completed workflows (tracked)
└── temp/                          # Transient files (not tracked)
```

### Commit Strategy

Commits follow [Conventional Commits](https://www.conventionalcommits.org/) format. Each phase handles its own commits:
- **Architecture & Planning**: One commit after validation (see respective docs)
- **Execution**: One commit per phase after verification (see `executing.md`)
- **Final Verification**: One commit for completion (see `verifying.md`)

### Validation Gates & Iteration Logic

Each phase has specific validation gates defined in their respective documentation:
- **Architecture → Planning**: See `architecting.md` for validation criteria
- **Planning → Execution**: See `planning.md` for validation criteria
- **Phase Execution → Next Phase**: See `executing.md` for per-phase verification
- **Final Verification**: See `verifying.md` for comprehensive validation

The orchestrator determines iteration targets based on validation failures and routes execution accordingly.

## Implementation Details

### Roo Code Implementation

#### 1. Delegated Task Contract

The orchestrator delegates complete phase workflows to specialized agents. Each agent's documentation defines its specific contract requirements and validation criteria.

#### 2. Scope & Delegation Rules

* Spawns the phase agents in order; holds no detailed phase logic.
* Allowed targets: `archflow-architecting`, `archflow-planning`, `archflow-executing`, `archflow-verifying`.
* Never edits repository files directly except workflow-state.md.
* Manages iteration state and validation gate decisions.
* On validation gate failure, determines iteration target and preserves context.
* **important** When delegating to `archflow-executing`. Delegate execution of the entire plan, not a specific step.

### Claude Code Implementation

**Unified Orchestration**: Claude Code uses a single `/archflow` command that orchestrates all phases automatically:

#### Core Approach
- **Single Command Execution**: One `/archflow` command handles the complete workflow
- **TodoWrite Integration**: Uses TodoWrite tool extensively for progress tracking at multiple levels
- **No Delegation**: All agent workflows are executed directly within the single command
- **Validation Gates**: Implements full validation gate logic with iteration support
- **Workflow State Management**: Creates, maintains, and archives workflow-state.md

#### Command Structure
```bash
/archflow "Feature description here"
```

#### Internal Orchestration Flow
1. **Initialize Workflow State** - Create or load archflow/workflow-state.md
2. **Create Master Todo List** - High-level phases + iteration tracking
3. **Execute Phase Sequence** with validation gates and stops as defined in each phase documentation
4. **Handle Iterations** - On validation failure, route to appropriate phase with context
5. **Archive Workflow** - Move workflow-state.md to archive on successful completion

#### Phase Integration
Each phase executes its documented workflow within the unified command:
- **Architecting**: See `architecting.md` for requirements gathering and architecture creation
- **Planning**: See `planning.md` for phase grouping and plan creation  
- **Execute/Verify Loop**: See `executing.md` and `verifying.md` for phase-based implementation with continuous verification

#### Todo Management Strategy
- **Level 1 Todos**: Master workflow phases (Architecting, Planning, Executing, Verifying)
- **Level 2 Todos**: Phase-specific tasks (created dynamically within each phase)
- **Level 3 Todos**: Step-specific tasks (for execution phase, created per plan step)

---

## Phase Documentation References

Detailed phase implementations are documented separately:
- **Architecting Phase**: See [`architecting.md`](./architecting.md) - Requirements gathering, ADR creation, validation gates
- **Planning Phase**: See [`planning.md`](./planning.md) - Phase grouping, complexity scoring, validation gates
- **Executing Phase**: See [`executing.md`](./executing.md) - Phase-based execution, continuous verification
- **Verifying Phase**: See [`verifying.md`](./verifying.md) - Phase and final verification criteria

## Inputs

* High‑level feature request (user)

---

## 4  Workflow

### Roo Code Workflow
```yaml
state: ORCHESTRATING
agent: archflow
delegate: false
iteration_management:
  max_iterations: 3
  current_iteration: 1
  workflow_state_file: "archflow/workflow-state.md"
steps:
    - "Initialize or load workflow-state.md"
    - "Spawn ARCHITECTING (`archflow-architecting`)"
    - "Run Architecture → Planning validation gate"
    - "On gate pass: spawn PLANNING (`archflow-planning`)"
    - "Run Planning → Execution validation gate"  
    - "On gate pass: spawn EXECUTING (`archflow-executing`)"
    - "Run Execution → Verification validation gate"
    - "On gate pass: spawn VERIFYING (`archflow-verifying`)"
    - "Run Verification → Complete validation gate"
    - "On gate pass: archive workflow-state.md and `attempt_completion` with `success: true`"
    - "On any gate fail: determine iteration target, update workflow-state.md, retry from target phase"
    - "If max iterations exceeded → `attempt_completion` with `success: false`"
```

### Claude Code Workflow
```yaml
state: ORCHESTRATING
agent: claude
delegate: false
unified_execution: true
iteration_management:
  max_iterations: 3
  current_iteration: 1
  workflow_state_file: "archflow/workflow-state.md"
steps:
    # Workflow Initialization
    - "Initialize workflow state document or load existing iteration context"
    - "Create Level 1 todos for master workflow phases"
    
    # Phase Execution
    - "Execute ARCHITECTING phase (see architecting.md for detailed workflow)"
    - "Run validation gate → STOP for user confirmation"
    - "Execute PLANNING phase (see planning.md for detailed workflow)"
    - "Run validation gate → STOP for user confirmation"
    - "Execute EXECUTE/VERIFY LOOP (see executing.md and verifying.md for detailed workflow)"
    - "Continue phases without stopping unless issues arise"
    - "Run final validation after all phases complete"
    
    # Iteration Handling
    - "If any validation gate or phase fails:"
    - "  - Increment iteration counter"
    - "  - Update workflow-state.md with failure context"
    - "  - Route to determined target phase (current, previous, or architecture)"
    - "  - Resume execution from target phase with preserved context"
    - "If max iterations exceeded: provide detailed failure report and exit"
    
    # Completion
    - "Archive workflow-state.md to archflow/archive/workflow-history/YYYYMMDDHHMMSS-<feature>-workflow.md"
    - "**IMPORTANT**: Use `date +%Y%m%d%H%M%S` format for timestamp"
    - "Mark all Level 1 todos as completed"
    - "Provide comprehensive completion report"
```