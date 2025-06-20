# ArchFlow Plan Command

Convert architecture artifacts into an executable implementation plan with atomic, testable steps.

## Usage
- `/archflow:plan [adr-path]` - Create implementation plan from specific ADR path
- `/archflow:plan` - Create implementation plan from latest ADR (finds most recent ADR automatically)

## Instructions

1. **Initialize tracking**
   - Use TodoWrite to create task list for planning phase
   - Track progress through all planning steps

2. **Review architecture documents**
   - Read the specified ADR or find the latest ADR in `archflow/architecture/adr/`
   - Read the corresponding Feature Architecture document
   - Understand the architectural decisions and design constraints

3. **Identify external dependencies**
   - Analyze package.json or equivalent dependency files
   - Identify required libraries, frameworks, or services
   - Document any new dependencies that need to be added

4. **Research codebase patterns**
   - Use Grep/Glob tools to analyze existing implementation patterns
   - Identify similar features or components for reference
   - Understand current architecture and coding standards
   - Find existing utilities, services, and patterns to leverage

5. **Decompose work into atomic steps**
   - Break down the feature into standalone, testable steps
   - Each step should:
     - Be buildable and testable independently
     - Modify at most 10 files
     - Be clearly defined with specific outcomes
     - Have clear acceptance criteria
   - Suggest model complexity for each step (Opus for complex, Sonnet for straightforward)
   - Order steps to minimize dependencies and enable incremental progress

6. **Write implementation plan**
   - Copy `archflow/plans/0000-template.md` to `archflow/plans/YYYYMMDDHHMMSS-<feature-name>.md`
   - Fill all sections following the template structure
   - Set all steps to `status: scheduled`
   - Include full relative paths in all references to files and documents
   - Ensure steps are atomic and actionable

7. **Commit plan**
   - Commit plan file with descriptive message: `<feature>: <summary> - <ADRFileName>`
   - Mark all todos as completed

## Error Handling

- If ADR path not provided and no ADRs found: Request user to specify ADR path or run architect phase first
- If template file missing: Check archflow directory structure and ensure init has been run
- If dependencies are unclear: Research similar features and document assumptions in plan
- If steps are too complex: Break down further into smaller, more manageable tasks
- If unable to find implementation patterns: Document this as a research task in the plan

## Example Output

```
✅ Planning phase completed successfully

Created plan: archflow/plans/20241220143022-user-authentication.md

Plan summary:
- 8 implementation steps identified
- 3 steps suggested for Opus (complex auth logic)
- 5 steps suggested for Sonnet (straightforward implementation)
- External dependencies: jsonwebtoken, passport, bcryptjs

Key implementation areas:
- Database schema updates (2 steps)
- Authentication middleware (2 steps)  
- API endpoints (2 steps)
- Frontend integration (2 steps)

Committed: user-auth: Add implementation plan - 20241220143022-user-authentication.md
```