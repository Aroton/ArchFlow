# Generate Unified ArchFlow Command for Claude Code

Generate a single unified ArchFlow command that orchestrates all workflow phases automatically.

## Usage
- `/archflow:generate-claude-commands` - Generate unified `/archflow` command in .claude/commands/

## Instructions

1. **Read all agent documentation files**:
   - Read `@agents/archflow.md`
   - Read `@agents/architecting.md`
   - Read `@agents/planning.md`
   - Read `@agents/executing.md`
   - Read `@agents/verifying.md`

2. **Analyze the Claude Code sections**:
   - Focus on the "Claude Code Implementation" and "Claude Code Workflow" sections
   - Extract the workflow steps and implementation details
   - Note that Claude Code doesn't use delegation - all work is done in single command

3. **Read the existing archflow-generate-claude-commands command**:
   - Read `.claude/commands/archflow-generate-claude-commands.md` as a template
   - Note the structure: Usage, Instructions, Error Handling, Example Output

4. **Generate unified command file**:
   Create a single command in `.claude/commands/`:

   ### archflow.md
   - Command: `/archflow "feature description"`
   - Purpose: Complete end-to-end ArchFlow workflow with automatic orchestration
   - Key capabilities:
     - **Workflow State Management**: Creates and maintains archflow/workflow-state.md
     - **Validation Gates**: Implements validation between each phase with iteration support
     - **Todo Management**: Uses TodoWrite at multiple levels (master phases, phase tasks, step tasks)
     - **Iteration Logic**: Handles validation failures by routing to appropriate phase
     - **Archive Management**: Archives completed workflows to archflow/archive/workflow-history/
   
   - Orchestration Flow:
     1. **Initialize**: Create/load workflow state, setup master todos
     2. **Architecting Phase**: Research, create ADR, Feature Architecture, Overall Architecture
     3. **Architecture → Planning Validation Gate**: Check feasibility, dependencies, clarity
     4. **Planning Phase**: Create implementation plan with atomic steps and complexity scoring
     5. **Planning → Execution Validation Gate**: Check implementability, complexity, resources
     6. **Executing Phase**: Implement all plan steps with continuous validation
     7. **Execution → Verification Validation Gate**: Check completeness, build/test success
     8. **Verifying Phase**: Run comprehensive verification (technical, business, quality)
     9. **Verification → Complete Validation Gate**: Check requirements satisfaction
     10. **Archive**: Move workflow-state.md to archive, provide completion report

   - Iteration Handling:
     - On validation gate failure: determine target phase (current, previous, or architecture)
     - Preserve context and learnings in workflow-state.md
     - Route execution to target phase with full context
     - Support up to 3 iterations before reporting failure

5. **Command structure**:
   Create a single **markdown file** with this structure:
   ```markdown
   # ArchFlow Unified Workflow Command

   Complete end-to-end ArchFlow workflow orchestration for feature development.

   ## Usage
   - `/archflow "feature description"` - Execute complete ArchFlow workflow

   ## Instructions

   ### Workflow Initialization
   1. Initialize workflow state management
   2. Create master todo list for phases
   3. Load any existing iteration context

   ### Phase Orchestration (with Validation Gates)
   1. **ARCHITECTING PHASE**
      - Execute architecting workflow from agents/architecting.md Claude Code section
      - Run Architecture → Planning validation gate
      - On failure: handle iteration logic
   
   2. **PLANNING PHASE**  
      - Execute planning workflow from agents/planning.md Claude Code section
      - Run Planning → Execution validation gate
      - On failure: handle iteration logic
   
   3. **EXECUTING PHASE**
      - Execute execution workflow from agents/executing.md Claude Code section  
      - Run Execution → Verification validation gate
      - On failure: handle iteration logic
   
   4. **VERIFYING PHASE**
      - Execute verification workflow from agents/verifying.md Claude Code section
      - Run Verification → Complete validation gate
      - On failure: handle iteration logic

   ### Completion
   1. Archive workflow-state.md to archflow/archive/workflow-history/
   2. Provide comprehensive completion report
   3. Mark all master todos as completed

   ## Error Handling

   - If validation gate fails: Update workflow state, determine iteration target, route accordingly
   - If max iterations exceeded: Provide detailed failure report and context
   - If critical error: Preserve workflow state and provide recovery instructions

   ## Example Output

   ```
   ArchFlow Workflow: User Authentication System
   ========================================

   Phase 1/4: ARCHITECTING ✅ (Iteration 1)
   - Created ADR: 20240120143000-user-auth-system.md
   - Updated Feature Architecture
   - Updated Overall Architecture
   - Validation Gate: PASSED

   Phase 2/4: PLANNING ✅ (Iteration 2) 
   - Created Implementation Plan: 20240120143000-auth-implementation.md
   - 8 atomic steps identified
   - Complexity scoring completed
   - Validation Gate: PASSED (retry after complexity refinement)

   Phase 3/4: EXECUTING ✅ (Iteration 1)
   - Implemented 8/8 steps
   - All builds successful
   - All tests passing
   - Validation Gate: PASSED

   Phase 4/4: VERIFYING ✅ (Iteration 1)
   - Technical validation: PASSED
   - Business validation: PASSED  
   - Quality validation: PASSED
   - Validation Gate: PASSED

   ✅ WORKFLOW COMPLETED SUCCESSFULLY
   - Total iterations: 2
   - Archived: archflow/archive/workflow-history/20240120-user-auth-system-workflow.md
   ```
   ```

   **IMPORTANT**: Create a single MARKDOWN file, not multiple files!

6. **Key implementation requirements**:
   - **Unified Execution**: Single command orchestrates all phases
   - **TodoWrite Integration**: Use TodoWrite extensively for multi-level progress tracking
   - **No Delegation**: Execute all agent workflows directly within the command
   - **Validation Gates**: Implement full validation logic between phases
   - **Iteration Support**: Handle validation failures with intelligent routing
   - **Workflow State**: Create, maintain, and archive workflow-state.md
   - **Context Preservation**: Maintain full context across iterations
   - **Direct Tool Usage**: Use Grep/Glob/Read/Edit/Bash tools directly (no delegation)

7. **Detailed workflow integration**:
   - Copy the exact "Claude Code Workflow" steps from each agent's documentation
   - Integrate validation gate logic from each agent's "Validation Gate" sections
   - Implement iteration handling based on each agent's failure escalation strategies
   - Use the todo management approach documented in each agent
   - Follow the workflow state integration requirements from each agent

8. **Validation**:
   - Ensure all workflow steps from all Claude Code sections are included
   - Command should be completely self-contained and executable
   - Include comprehensive error handling and iteration logic
   - Provide detailed progress reporting and completion summaries
   - Must handle all validation gate scenarios documented in agent files

## Output
Generate 1 **markdown** command file (NOT JSON):
- `.claude/commands/archflow.md`

The file should:
- Be a markdown file (.md extension)
- Follow the Claude Code command format
- Combine all agent workflows into unified orchestration
- Be complete and ready to use as a single `/archflow` command
- Include all validation gates and iteration logic
- NOT be in JSON format