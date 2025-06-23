# Implementation Plan: {ADRName} (ADR-0000-example-adr)

Plan description explaining the overall approach to implementing this feature.

## Risk Assessment

### Technical Risks
- **Dependency Failures**: [List potential dependency issues and mitigation strategies]
- **Integration Complexity**: [Identify integration points and potential conflicts]  
- **Performance Concerns**: [Performance bottlenecks and optimization requirements]
- **Security Considerations**: [Security implications and required safeguards]

### Business Risks
- **Scope Creep**: [Requirements stability and change management approach]
- **Stakeholder Alignment**: [Key stakeholders and approval requirements]
- **Resource Availability**: [Team capacity and skill requirements]
- **Timeline Pressures**: [Critical deadlines and buffer requirements]

### Timeline Risks
- **Complexity Underestimation**: [Areas of uncertainty requiring additional time]
- **External Dependencies**: [Third-party services, approvals, or integrations]
- **Testing Requirements**: [Comprehensive testing scope and timeline impact]

## Dependency Mapping

### Step Dependencies
- **Sequential Dependencies**: [Steps that must be completed in order]
- **Parallel Opportunities**: [Steps that can be executed concurrently]
- **Critical Path**: [Longest sequence determining minimum timeline]

### Cross-Feature Impact
- **Shared Components**: [Components used by multiple features]
- **API Changes**: [API modifications affecting other systems]
- **Database Schema**: [Schema changes impacting existing functionality]
- **Infrastructure**: [Infrastructure changes affecting other services]

## Complexity Scoring Methodology

Each step is scored on multiple dimensions (1-5 scale unless noted):

- **Lines of Code Impact**: Estimated lines added/modified
- **Files Affected**: Count weighted by file type and importance
- **Dependency Chain Depth**: How many layers of dependencies (1-3)
- **Technical Risk Level**: Complexity of technical implementation (1-5)
- **Integration Complexity**: Number and complexity of integration points (1-3)

**Complexity Thresholds**:
- **Score 0-5**: Simple changes (fast validation, 2 recovery attempts)
- **Score 6-8**: Moderate changes (fast + medium validation, 3 recovery attempts)
- **Score 9-12**: Complex changes (progressive validation, 4 recovery attempts)
- **Score 13+**: High complexity (full validation, 5 recovery attempts, user consultation)

## Execution Strategy

### Validation Strategy Mapping
- **Low Risk (Score 0-5)**: Fast checks only (syntax, imports, basic linting)
- **Medium Risk (Score 6-8)**: Fast + medium checks (unit tests, integration tests)
- **High Risk (Score 9-12)**: Progressive validation with selective heavy checks
- **Critical Risk (Score 13+)**: Full validation suite with comprehensive testing

### Recovery Strategy
- **Step-Level Recovery**: Individual step rollback and retry
- **Batch-Level Recovery**: Related step group rollback
- **Checkpoint Recovery**: Return to milestone validation points
- **User Consultation**: Automatic escalation at defined thresholds

## Phase Organization

Implementation is organized into logical phases that group related steps:

### Phase 1: Database Schema and Models
- **Description**: Set up database structure and data models
- **Steps**: [step_1, step_2]
- **Success Criteria**: Database migrations run successfully, models validate correctly
- **Verification Approach**: Run migrations in test environment, execute model unit tests
- **Commit Message**: `feat(database): implement user authentication schema`

### Phase 2: API Implementation
- **Description**: Implement REST API endpoints for authentication
- **Steps**: [step_3, step_4, step_5]
- **Success Criteria**: All endpoints respond correctly, authentication flows work
- **Verification Approach**: API integration tests, manual testing with Postman
- **Commit Message**: `feat(api): add authentication endpoints`

### Phase 3: Frontend Integration
- **Description**: Build UI components and integrate with API
- **Steps**: [step_6, step_7, step_8]
- **Success Criteria**: UI renders correctly, user can login/logout successfully
- **Verification Approach**: Component tests, E2E tests, manual UI verification
- **Commit Message**: `feat(ui): implement authentication UI components`

```yaml
adr: architecture/adr/20240623120000-user-authentication.md
feature: architecture/features/20240623120000-user-authentication.md

# Phase definitions
phases:
  - id: phase_1
    name: "Database Schema and Models"
    description: "Set up database structure and data models for authentication"
    steps: [step_1, step_2]
    success_criteria:
      - "Database migrations execute without errors"
      - "User model includes all required fields"
      - "Indexes are properly configured for performance"
    verification_approach: "Run migrations, execute model unit tests, verify indexes"
    dependencies: []
    commit_message: "feat(database): implement user authentication schema"
    status: scheduled

  - id: phase_2  
    name: "API Implementation"
    description: "Implement REST API endpoints for authentication flows"
    steps: [step_3, step_4, step_5]
    success_criteria:
      - "All authentication endpoints return correct status codes"
      - "JWT tokens are properly generated and validated"
      - "Rate limiting is enforced on login endpoints"
    verification_approach: "Run API integration tests, test with Postman, verify rate limits"
    dependencies: [phase_1]
    commit_message: "feat(api): add authentication endpoints"
    status: scheduled

  - id: phase_3
    name: "Frontend Integration"
    description: "Build UI components and integrate with authentication API"
    steps: [step_6, step_7, step_8]
    success_criteria:
      - "Login/signup forms render correctly"
      - "Form validation provides clear user feedback"
      - "Authentication state persists across page refreshes"
    verification_approach: "Run component tests, execute E2E tests, manual UI testing"
    dependencies: [phase_2]
    commit_message: "feat(ui): implement authentication UI components"
    status: scheduled

# Step definitions
steps:
  - id: step_1
    description: Create database migration for users table
    phase: phase_1
    files:
      - db/migrations/001_create_users_table.sql
      - db/schema.sql
    agentMode: junior
    complexity_score:
      lines_of_code_impact: 2
      files_affected_count: 2
      dependency_chain_depth: 1
      technical_risk_level: 2
      integration_complexity: 1
      total_score: 6
    success_criteria:
      technical: "Migration runs without errors, rollback works"
      functional: "Users table created with correct schema"
      quality: "Indexes and constraints properly defined"
      integration: "Compatible with existing database schema"
    dependencies: []
    execution_strategy:
      validation_level: "fast_checks"
      recovery_attempts: 3
      rollback_granularity: "step_level"
      critical_path: true
    status: scheduled
  - id: step_2
    description: Implement User model with authentication fields
    phase: phase_1
    files:
      - src/models/User.ts
      - src/models/index.ts
    agentMode: midlevel
    complexity_score:
      lines_of_code_impact: 3
      files_affected_count: 2
      dependency_chain_depth: 1
      technical_risk_level: 2
      integration_complexity: 2
      total_score: 8
    success_criteria:
      technical: "Model compiles, TypeScript types are correct"
      functional: "Password hashing works, validation rules enforced"
      quality: "Follows existing model patterns, well documented"
      integration: "Integrates with ORM, database queries work"
    dependencies: [step_1]
    execution_strategy:
      validation_level: "medium_checks"
      recovery_attempts: 3
      rollback_granularity: "step_level"
      critical_path: true
    status: scheduled

  - id: step_3
    description: Create authentication service with JWT support
    phase: phase_2
    files:
      - src/services/AuthService.ts
      - src/services/index.ts
      - src/config/auth.ts
    agentMode: senior
    complexity_score:
      lines_of_code_impact: 4
      files_affected_count: 3
      dependency_chain_depth: 2
      technical_risk_level: 4
      integration_complexity: 3
      total_score: 14
    success_criteria:
      technical: "JWT generation/validation works, secure key management"
      functional: "Login returns valid tokens, refresh flow works"
      quality: "Security best practices followed, comprehensive error handling"
      integration: "Works with User model, integrates with middleware"
    dependencies: [step_2]
    execution_strategy:
      validation_level: "full_suite"
      recovery_attempts: 5
      rollback_granularity: "checkpoint_level"
      critical_path: true
    status: scheduled

  - id: step_4
    description: Implement login and registration endpoints
    phase: phase_2
    files:
      - src/routes/auth.ts
      - src/controllers/AuthController.ts
    agentMode: midlevel
    complexity_score:
      lines_of_code_impact: 3
      files_affected_count: 2
      dependency_chain_depth: 2
      technical_risk_level: 3
      integration_complexity: 2
      total_score: 10
    success_criteria:
      technical: "Endpoints handle all HTTP methods correctly"
      functional: "Users can register and login successfully"
      quality: "Input validation, proper error responses"
      integration: "Uses AuthService, returns correct status codes"
    dependencies: [step_3]
    execution_strategy:
      validation_level: "medium_checks"
      recovery_attempts: 4
      rollback_granularity: "batch_level"
      critical_path: true
    status: scheduled

  - id: step_5
    description: Add authentication middleware and rate limiting
    phase: phase_2
    files:
      - src/middleware/auth.ts
      - src/middleware/rateLimiter.ts
    agentMode: midlevel
    complexity_score:
      lines_of_code_impact: 3
      files_affected_count: 2
      dependency_chain_depth: 2
      technical_risk_level: 3
      integration_complexity: 2
      total_score: 10
    success_criteria:
      technical: "Middleware correctly validates JWT tokens"
      functional: "Protected routes require authentication"
      quality: "Clear error messages, configurable limits"
      integration: "Works with all routes, doesn't break existing endpoints"
    dependencies: [step_4]
    execution_strategy:
      validation_level: "medium_checks"
      recovery_attempts: 4
      rollback_granularity: "step_level"
      critical_path: false
    status: scheduled

  - id: step_6
    description: Create login and signup form components
    phase: phase_3
    files:
      - src/components/LoginForm.tsx
      - src/components/SignupForm.tsx
      - src/components/forms/index.ts
    agentMode: midlevel
    complexity_score:
      lines_of_code_impact: 3
      files_affected_count: 3
      dependency_chain_depth: 1
      technical_risk_level: 2
      integration_complexity: 2
      total_score: 9
    success_criteria:
      technical: "Components render without errors, TypeScript types correct"
      functional: "Forms validate input, show error messages"
      quality: "Accessible, follows design system, responsive"
      integration: "Uses existing form utilities and styles"
    dependencies: [step_5]
    execution_strategy:
      validation_level: "medium_checks"
      recovery_attempts: 4
      rollback_granularity: "batch_level"
      critical_path: false
    status: scheduled

  - id: step_7
    description: Implement authentication state management
    phase: phase_3
    files:
      - src/store/authSlice.ts
      - src/hooks/useAuth.ts
      - src/store/index.ts
    agentMode: senior
    complexity_score:
      lines_of_code_impact: 3
      files_affected_count: 3
      dependency_chain_depth: 2
      technical_risk_level: 3
      integration_complexity: 3
      total_score: 11
    success_criteria:
      technical: "State updates trigger re-renders correctly"
      functional: "Auth state persists, logout clears state"
      quality: "Type-safe, follows Redux best practices"
      integration: "Works with existing store, doesn't break other slices"
    dependencies: [step_6]
    execution_strategy:
      validation_level: "heavy_checks"
      recovery_attempts: 4
      rollback_granularity: "checkpoint_level"
      critical_path: true
    status: scheduled

  - id: step_8
    description: Add protected route component and navigation updates
    phase: phase_3
    files:
      - src/components/ProtectedRoute.tsx
      - src/components/Navigation.tsx
      - src/App.tsx
    agentMode: midlevel
    complexity_score:
      lines_of_code_impact: 2
      files_affected_count: 3
      dependency_chain_depth: 2
      technical_risk_level: 2
      integration_complexity: 2
      total_score: 8
    success_criteria:
      technical: "Routes redirect correctly based on auth state"
      functional: "Unauthorized users redirected to login"
      quality: "Smooth transitions, loading states handled"
      integration: "Works with React Router, preserves deep links"
    dependencies: [step_7]
    execution_strategy:
      validation_level: "medium_checks"
      recovery_attempts: 3
      rollback_granularity: "step_level"
      critical_path: false
    status: scheduled
```