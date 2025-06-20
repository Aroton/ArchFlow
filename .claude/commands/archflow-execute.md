# ArchFlow Execute Command

Implement all steps from the implementation plan, ensuring each step builds, lints, and tests cleanly.

## Usage
- `/archflow:execute [plan-path]` - Execute implementation from specific plan path
- `/archflow:execute` - Execute implementation from latest plan (finds most recent plan automatically)

## Instructions

1. **Initialize execution tracking**
   - Use TodoWrite to create task list from all plan steps
   - Read plan file to understand all implementation steps and their requirements

2. **Prepare for execution**
   - Verify all prerequisites and dependencies are available
   - Identify build, lint, and test commands for the project
   - Ensure development environment is properly set up

3. **Execute each implementation step**
   For each step in the plan (in order):
   
   a. **Start step execution**
      - Mark todo as in_progress
      - Update plan file: set step.status to "in_progress"
      - Consider model complexity suggestion (may prompt user to switch between Opus/Sonnet)
   
   b. **Implement changes**
      - Read all files specified in the step
      - Make necessary code modifications following project patterns
      - Create new files if required by the step
      - Ensure implementation matches step requirements and acceptance criteria
   
   c. **Validate implementation**
      - Run build command (infer from project: npm run build, make, etc.)
      - Fix any build errors that occur
      - Run lint command (infer from project: npm run lint, eslint, etc.)
      - Fix any linting errors that occur
      - Run test command (infer from project: npm test, pytest, etc.)
      - Fix any test failures that occur
      - Ensure all validation passes before proceeding
   
   d. **Complete step**
      - Update plan file: set step.status to "complete"
      - Commit changes with message: `<feature>: <step-summary> - step <step-number>`
      - Mark todo as completed

4. **Final validation**
   - Verify all steps in plan are marked as complete
   - Run full test suite one final time
   - Confirm entire implementation is working correctly

5. **Complete execution**
   - Mark all todos as completed
   - Provide summary of implementation progress

## Error Handling

- If plan path not provided and no plans found: Request user to specify plan path or run planning phase first
- If step implementation fails: Document the issue, attempt to fix, and update plan status accordingly
- If build/lint/test commands cannot be inferred: Ask user for the correct commands to run
- If validation fails repeatedly: Mark step as failed in plan and report issue to user
- If dependencies are missing: Install required dependencies or report to user
- If step complexity exceeds current model capability: Suggest switching to appropriate model (Opus for complex tasks)

## Example Output

```
✅ Execution phase completed successfully

Implemented plan: archflow/plans/20241220143022-user-authentication.md

Execution summary:
- 8/8 steps completed successfully
- 12 files modified, 4 new files created
- All tests passing (47 tests, 0 failures)
- Build successful, no lint errors

Step-by-step progress:
✅ Step 1: Database schema setup - step1 (commit abc123)
✅ Step 2: User model creation - step2 (commit def456)  
✅ Step 3: Authentication middleware - step3 (commit ghi789)
✅ Step 4: Login/logout endpoints - step4 (commit jkl012)
✅ Step 5: Registration endpoint - step5 (commit mno345)
✅ Step 6: JWT token handling - step6 (commit pqr678)
✅ Step 7: Frontend auth forms - step7 (commit stu901)
✅ Step 8: Integration tests - step8 (commit vwx234)

Ready for verification phase.
```