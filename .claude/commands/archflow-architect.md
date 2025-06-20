# ArchFlow Architect Command

Create architectural decision record (ADR), feature architecture, and update overall architecture for a new feature.

## Usage
- `/archflow:architect [feature-description]` - Create architecture documents for a new feature

## Instructions

1. **Initialize tracking**
   - Use TodoWrite to create task list for architecture phase
   - Track progress through all architectural steps

2. **Gather context and research**
   - Load existing architecture documents from `archflow/architecture/`
   - Use Grep/Glob tools to search codebase for relevant patterns and dependencies
   - Analyze project structure, existing components, and architectural patterns
   - Research similar features already implemented in the codebase

3. **Create Architecture Decision Record (ADR)**
   - Copy `archflow/architecture/adr/0000-template.md` to `archflow/architecture/adr/YYYYMMDDHHMMSS-<feature-name>.md`
   - Ask clarifying questions about the feature if needed
   - Fill all sections of the ADR with detailed architectural decisions
   - Ensure all file references use full relative paths
   - Document technology choices, patterns, and trade-offs

4. **Create or update Feature Architecture**
   - If new feature: copy `archflow/architecture/features/template.md` to `archflow/architecture/features/YYYYMMDDHHMMSS-<feature-name>.md`
   - If existing feature: update the existing feature architecture file
   - Analyze consistency between ADR and feature architecture
   - Fill all required sections with implementation details
   - Include component diagrams and data flow if applicable

5. **Update Overall Architecture**
   - Read `archflow/architecture/overall-architecture.md`
   - Analyze impact of new ADR on overall system architecture
   - Update overall architecture with any major changes or new patterns
   - Ensure architectural consistency across the system

6. **Commit changes**
   - Commit all architecture documents with descriptive message: `<feature>: <summary> - <ADRFileName>`
   - Mark all todos as completed

## Error Handling

- If template files don't exist: Check archflow directory structure and ensure init has been run
- If unclear about feature requirements: Ask clarifying questions before proceeding
- If conflicts with existing architecture: Document trade-offs and alternatives in ADR
- If codebase research reveals issues: Include findings in architecture decisions

## Example Output

```
✅ Architecture phase completed successfully

Created documents:
- archflow/architecture/adr/20241220143022-user-authentication.md
- archflow/architecture/features/20241220143022-user-authentication.md
- Updated archflow/architecture/overall-architecture.md

Key architectural decisions:
- JWT-based authentication with refresh tokens
- Integration with existing user management system
- OAuth2 provider support for social login

Committed: user-auth: Add authentication architecture - 20241220143022-user-authentication.md
```