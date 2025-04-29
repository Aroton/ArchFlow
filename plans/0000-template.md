# Implementation Plan: {ADRName} (ADR-0000-example-adr)

Plan description

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
    status: "scheduled" # Initial status
  - id: step_2
    description: Describe the second step here
    files:
      - path/to/another/file.ext
    agentMode: intern # Example
    status: scheduled
# Add more steps as needed
```