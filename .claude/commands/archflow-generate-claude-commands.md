# Generate Claude Code Commands for ArchFlow

Generate Claude Code command files for all ArchFlow workflow phases.

## Usage
- `/archflow:generate-claude-commands` - Generate all ArchFlow Claude Code commands in .claude/commands/

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

4. **Generate command files**:
   Create the following commands in `.claude/commands/`:

   ### archflow-architect.md
   - Command: `/archflow:architect [feature-description]`
   - Purpose: Create ADR, Feature Architecture, and update Overall Architecture
   - Key steps:
     - Use TodoWrite to track progress
     - Research codebase with Grep/Glob
     - Create ADR from template
     - Create/update Feature Architecture
     - Update Overall Architecture
     - Commit changes

   ### archflow-plan.md
   - Command: `/archflow:plan [adr-path]` or `/archflow:plan` (finds latest ADR)
   - Purpose: Create implementation plan from architecture documents
   - Key steps:
     - Use TodoWrite to track progress
     - Read ADR and Feature Architecture
     - Research codebase for implementation patterns
     - Create atomic, testable steps
     - Suggest model complexity (Opus/Sonnet) for each step
     - Write plan file from template
     - Commit plan

   ### archflow-execute.md
   - Command: `/archflow:execute [plan-path]` or `/archflow:execute` (finds latest plan)
   - Purpose: Implement all steps from the plan
   - Key steps:
     - Use TodoWrite to create tasks from plan steps
     - For each step:
       - Update status to in_progress
       - Implement changes
       - Run build/lint/test
       - Fix any issues
       - Update status to complete
       - Commit with step number
     - Suggest model switches if needed

   ### archflow-verify.md
   - Command: `/archflow:verify [plan-path]` or `/archflow:verify` (finds latest completed plan)
   - Purpose: Verify implementation matches plan and passes all checks
   - Key steps:
     - Use TodoWrite for verification tasks
     - Run full test suite
     - Perform code review
     - Compare implementation to plan
     - Update plan with verified status
     - Generate detailed report

5. **Command structure for each file**:
   Each file must be a **markdown file** with this structure:
   ```markdown
   # ArchFlow [Phase] Command

   [Description of what this phase does]

   ## Usage
   - `/archflow:[command] [args]` - [Brief description]

   ## Instructions

   1. Step one
      - Sub-step details
      - More details
   2. Step two
      - Sub-step details
   3. [Continue with numbered steps...]

   ## Error Handling

   - If [error condition]: [How to handle]
   - If [another error]: [How to handle]

   ## Example Output

   ```
   Example of what successful output looks like
   ```
   ```

   **IMPORTANT**: Create MARKDOWN files, not JSON files!

6. **Key differences from Roo Code**:
   - No delegation to other agents
   - Use TodoWrite instead of new_task/attempt_completion
   - Direct use of Grep/Glob instead of researcher delegation
   - Single command execution for entire phase
   - May suggest model switches but doesn't enforce agent modes

7. **Validation**:
   - Ensure all workflow steps from Claude Code sections are included
   - Commands should be self-contained and executable
   - Include proper error handling
   - Provide clear success/failure feedback

## Output
Generate 4 **markdown** command files (NOT JSON):
- `.claude/commands/archflow-architect.md`
- `.claude/commands/archflow-plan.md`
- `.claude/commands/archflow-execute.md`
- `.claude/commands/archflow-verify.md`

Each file should:
- Be a markdown file (.md extension)
- Follow the Claude Code command format
- Be complete and ready to use
- NOT be in JSON format