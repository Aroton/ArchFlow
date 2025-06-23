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

**Complexity Threshold**: Steps scoring >12 should be considered for refactoring into smaller steps.

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
    status: scheduled
# Add more steps as needed
```