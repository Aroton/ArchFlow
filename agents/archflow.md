# Archflow Orchestrator

```yaml
slug: archflow
name: ArchFlow
groups: ['read']
source: 'global'
```

The Orchestrator coordinates the four phase‑specific agents (**Architecting → Planning → Executing → Verifying**) and passes only minimal context and artifacts to each phase.

## Core Functionality

The orchestrator manages the overall workflow, delegating to specialized agents in sequence. It monitors success/failure, coordinates handoff between phases, and manages iteration state when validation gates fail. The orchestrator maintains a workflow state document that tracks iterations, deliverable validation, and provides complete audit trail.

## Workflow State Management

The orchestrator maintains `archflow/workflow-state.md` to track:
- Current phase and iteration number
- Phase history with success/failure reasons
- Deliverable completion status
- Validation gate results
- Context preservation across iterations

### Folder Structure
```
archflow/
├── workflow-state.md              # Active workflow state (tracked)
├── archive/
│   └── workflow-history/          # Completed workflows (tracked)
└── temp/                          # Transient files (not tracked)
```

### Iteration Logic

**Validation Gates:**
- **Architecture → Planning**: Technical feasibility, dependency availability, requirement clarity
- **Planning → Execution**: Step implementability, complexity bounds, resource availability  
- **Execution → Verification**: Implementation completeness, build/test success
- **Verification → Complete**: Requirements satisfaction, quality standards met

**Iteration Triggers:**
- **Minor Iteration**: Return to previous phase (missing details, scope adjustments)
- **Major Iteration**: Return to architecture (fundamental design flaws, invalid assumptions)
- **Abort Workflow**: Terminate on impossible requirements or resource constraints

## Implementation Details

### Roo Code Implementation

#### 1. Delegated Task Contract (must be injected verbatim in every `new_task`)

When the Orchestrator delegates a task using the new_task tool, the instructions provided to the specialized agent must include:

* Context: All relevant details from the parent task, ADR, Feature Architecture, original prompt, and current iteration context from workflow-state.md.
* Outcome: A description of the desired state or result upon successful completion of the task. This should be the completion of an agent workflow (`archflow-architecting`, `archflow-planning`, `archflow-executing`, `archflow-verifying`)
* Completion: An instruction to use the attempt_completion tool upon finishing. The result parameter should contain a concise yet thorough summary confirming task execution and validation gate status.

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
3. **Execute Phase Sequence** with validation gates:
   - **Architecting Phase** → Validation Gate → **Planning Phase** 
   - **Planning Phase** → Validation Gate → **Executing Phase**
   - **Executing Phase** → Validation Gate → **Verifying Phase**
   - **Verifying Phase** → Validation Gate → **Complete**
4. **Handle Iterations** - On validation failure, route to appropriate phase with context
5. **Archive Workflow** - Move workflow-state.md to archive on successful completion

#### Phase Integration
Each phase uses its documented Claude Code workflow but is executed within the unified command:
- **Architecting**: Creates ADR, Feature Architecture, Overall Architecture updates
- **Planning**: Creates detailed implementation plan with complexity scoring
- **Executing**: Implements all steps with continuous validation  
- **Verifying**: Runs comprehensive verification (technical, business, quality)

#### Todo Management Strategy
- **Level 1 Todos**: Master workflow phases (Architecting, Planning, Executing, Verifying)
- **Level 2 Todos**: Phase-specific tasks (created dynamically within each phase)
- **Level 3 Todos**: Step-specific tasks (for execution phase, created per plan step)

---

## 3  Inputs

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
    
    # Phase Orchestration Loop (with iteration support)
    - "PHASE: ARCHITECTING"
    - "Execute architecting workflow (from architecting.md Claude Code workflow)"
    - "Run Architecture → Planning validation gate"
    - "On validation pass: proceed to PLANNING"
    - "On validation fail: update workflow state, determine iteration target"
    
    - "PHASE: PLANNING" 
    - "Execute planning workflow (from planning.md Claude Code workflow)"
    - "Run Planning → Execution validation gate"
    - "On validation pass: proceed to EXECUTING"
    - "On validation fail: update workflow state, determine iteration target"
    
    - "PHASE: EXECUTING"
    - "Execute execution workflow (from executing.md Claude Code workflow)"
    - "Run Execution → Verification validation gate"
    - "On validation pass: proceed to VERIFYING"
    - "On validation fail: update workflow state, determine iteration target"
    
    - "PHASE: VERIFYING"
    - "Execute verification workflow (from verifying.md Claude Code workflow)"
    - "Run Verification → Complete validation gate"
    - "On validation pass: archive workflow state and complete successfully"
    - "On validation fail: update workflow state, determine iteration target"
    
    # Iteration Handling
    - "If any validation gate fails:"
    - "  - Increment iteration counter"
    - "  - Update workflow-state.md with failure context"
    - "  - Route to determined target phase (current, previous, or architecture)"
    - "  - Resume execution from target phase with preserved context"
    - "If max iterations exceeded: provide detailed failure report and exit"
    
    # Completion
    - "Archive workflow-state.md to archflow/archive/workflow-history/"
    - "Mark all Level 1 todos as completed"
    - "Provide comprehensive completion report"
```