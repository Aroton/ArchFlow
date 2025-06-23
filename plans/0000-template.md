# Implementation Plan: {ADRName} (ADR-0000-example-adr)

Plan description

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

```yaml
adr: architecture/adr/0000-example-adr.md # example ADR reference (UPDATE THIS with full path)
feature: architecture/features/0000-example-feature.md # Example feature reference (UPDATE THIS with full path)
steps: # An ordered list of tasks, each with the following fields
  - id: step_1
    description: Describe the first step here
    files: # List files this step modifies or creates
      - path/to/file1.ext
      - path/to/file2.ext
    agentMode: "intern | junior | midlevel | senior" # Choose appropriate agent
    complexity_score:
      lines_of_code_impact: 2 # 1-5 scale
      files_affected_count: 2 # actual count
      dependency_chain_depth: 1 # 1-3 scale  
      technical_risk_level: 2 # 1-5 scale
      integration_complexity: 1 # 1-3 scale
      total_score: 8 # calculated total
    success_criteria:
      technical: "Files compile without errors, unit tests pass"
      functional: "Feature works as specified in acceptance criteria"
      quality: "Code follows project standards, documentation complete"
      integration: "Integration points function correctly"
    dependencies: [] # List of step IDs this step depends on
    execution_strategy:
      validation_level: "fast_checks" # Based on complexity score: fast_checks, medium_checks, heavy_checks, full_suite
      recovery_attempts: 2 # Based on complexity score
      rollback_granularity: "step_level" # step_level, batch_level, checkpoint_level
      batch_group: "ui_components" # Optional: group related steps for batch processing
      critical_path: false # True if this step is on the critical dependency path
    status: "scheduled" # Initial status
  - id: step_2
    description: Describe the second step here
    files:
      - path/to/another/file.ext
    agentMode: intern # Example
    complexity_score:
      lines_of_code_impact: 1
      files_affected_count: 1
      dependency_chain_depth: 1
      technical_risk_level: 1
      integration_complexity: 1
      total_score: 5
    success_criteria:
      technical: "Implementation compiles and builds successfully"
      functional: "Feature behavior matches specification"
      quality: "Code review passes, documentation updated"
      integration: "No breaking changes to existing functionality"
    dependencies: ["step_1"] # This step depends on step_1
    execution_strategy:
      validation_level: "fast_checks" # Based on complexity score
      recovery_attempts: 2 # Based on complexity score
      rollback_granularity: "step_level"
      batch_group: "ui_components" # Same batch group as step_1
      critical_path: false
    status: scheduled
# Add more steps as needed
```