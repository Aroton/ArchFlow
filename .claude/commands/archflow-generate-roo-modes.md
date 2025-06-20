# Generate Roo Code Modes for ArchFlow

Generate Roo Code custom modes JSON for the ArchFlow workflow agents.

## Usage
- `/archflow:generate-roo-modes` - Generate new_archflow_modes.json with all ArchFlow agent modes

## Instructions

1. **Read all agent documentation files**:
   - Read `@agents/archflow.md`
   - Read `@agents/architecting.md`
   - Read `@agents/planning.md`
   - Read `@agents/executing.md`
   - Read `@agents/verifying.md`

2. **Analyze the Roo Code sections**:
   - Focus on the "Roo Code Implementation" sections in each file
   - Extract the workflow steps, delegation rules, and scope
   - Understand dependencies between agents

3. **Read the existing custom_modes.json structure**:
   - Read `@custom_modes.json` to understand the format
   - Note the structure: slug, name, roleDefinition, customInstructions, groups, source

4. **Generate the modes JSON**:
   For each agent, create a mode entry with:
   - **slug**: Use the slug from the agent file (e.g., "archflow", "archflow-architecting")
   - **name**: Use a descriptive name with emoji (e.g., "🏗️ ArchFlow - Architecting")
   - **roleDefinition**: Concise description of the agent's role
   - **customInstructions**: Include:
     - The full workflow steps from the Roo Code Workflow section
     - Delegated Task Contract (for agents that delegate)
     - Scope & Delegation Rules
     - Any important notes or restrictions
   - **groups**: Based on agent capabilities:
     - archflow: ["read"] (orchestrator only reads)
     - architecting/planning/executing/verifying: ["read", "edit", "command"]
   - **source**: "global"

5. **Write the output**:
   - Create `new_archflow_modes.json` with all ArchFlow agent modes
   - Ensure proper JSON formatting
   - Include all 5 agents: archflow, archflow-architecting, archflow-planning, archflow-executing, archflow-verifying

6. **Validation**:
   - Verify JSON is valid
   - Ensure no critical workflow details are lost
   - Check that delegation relationships are preserved

## Example Output Structure

```json
{
  "customModes": [
    {
      "slug": "archflow",
      "name": "🔄 ArchFlow Orchestrator",
      "roleDefinition": "You are the ArchFlow orchestrator...",
      "customInstructions": "## Workflow\n\n...",
      "groups": ["read"],
      "source": "global"
    },
    // ... other modes
  ]
}
```

## Notes
- Preserve the exact workflow steps from the Roo Code sections
- Include all delegation contracts verbatim
- Ensure customInstructions are comprehensive and actionable
- Format with proper escaping for JSON strings