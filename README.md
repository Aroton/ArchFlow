# Archflow Workflow 🌐

This repository implements an **AI-orchestrated development loop** nick-named **Archflow**
The loop automates design → plan → code → verify, while staying restart-safe and fully auditable.

---

## 1 Folder Layout

```
.
├── architecture/
│   ├── overall-architecture.md # High-level system view
│   ├── features/             # Detailed feature architectures
│   │   └── NNNN-feature-name.md # Example feature doc
│   ├── adr/                  # Architecture Decision Records (ADR)
│   │   ├── 0000-template.md  # Copy & rename for each new decision
│   │   ├── 0001-...md        # First accepted ADR
│   │   └── 0002-...md
│   └── diagrams/             # Images referenced by ADRs or feature docs
├── plans/                    # Implementation plans (*.md)
├── src/                      # Application code
├── scripts/
```

---

## 2 Key Artifacts

| Artifact | Purpose | When it’s written |
|----------|---------|-------------------|
| **Overall Architecture (`architecture/overall-architecture.md`)** | High-level view of the entire system. | Initially, then updated as needed during **ARCHITECTING**. |
| **Feature Architecture (`architecture/features/*.md`)** | Detailed design for a specific feature. | Created or updated during **ARCHITECTING**, triggered by an ADR. |
| **ADR (`architecture/adr/*.md`)** | Records a specific decision impacting feature or overall architecture. Links to relevant Feature Architecture. | During **ARCHITECTING** |
| **Plan (`plans/*.md`)** | Step-by-step implementation checklist tied to an ADR, written in Markdown. Contains status fields (`scheduled`, `in_progress`, `completed`) for each step, enabling workflow resumption. | During **PLANNING**, updated during **EXECUTING** |
| **Code commits** | Actual changes produced by AI agents. | During **EXECUTING**, **ARCHITECTING**, **PLANNING** |

---

## 3 States & Agents

| State | Responsible Agent | Outputs |
|-------|-------------------|---------|
| **ARCHITECTING** | *Architect* | new/updated ADR, new/updated Feature Architecture, updated Overall Architecture (if needed), initial plan |
| **PLANNING** | *Architect* | refined `plans/*.md` |
| **EXECUTING** | *Intern → Junior → Mid → Senior* | code changes, updated plan status |
+ Note: Only agents defined in the `agentMode` enum (`intern`, `junior`, `midlevel`, `senior`) should be assigned during execution.
| **VERIFYING** | *Senior* or test harness | test report; success flag |

If a state fails, the Micro-Manager awaits human input.

---

## ARCHITECTING Workflow

The typical flow for architectural changes is:

1. **Create/Update ADR:**
   - Copy `architecture/adr/0000-template.md` → `000N-title.md`.
   - Fill in the ADR details (Context, Decision, etc.).
   - Crucially, specify if this ADR `New` or `Modifies` a Feature Architecture and provide the link (e.g., `[./architecture/features/000N-feature-name.md]`).
2. **Create/Update Feature Architecture:**
   - Based on the ADR, create a new Feature Architecture document in `architecture/features/` (using `architecture/feature-template.md`) or update the existing one linked in the ADR.
   - Detail the specific components, interactions, data flows, etc., for the feature.
3. **Update Overall Architecture (If Necessary):**
   - Review `architecture/overall-architecture.md`.
   - If the changes introduced by the ADR and Feature Architecture significantly impact the high-level view (e.g., adding a major new service, changing core patterns), update the diagram and descriptions accordingly.
71 | 4. **Identify & Verify Dependencies:**
72 |    - Based on the Feature Architecture, identify potential new external software dependencies (libraries, packages, etc.).
73 |    - Check the project's relevant package manager file (e.g., `package.json`, `requirements.txt`) to verify if these dependencies are already installed or part of the existing project setup.
74 |    - List any required *new* dependencies that need to be installed in the initial implementation plan.
4.
4. **Proceed to Planning:** Do not create the planning file. The planning phase will create it.
5. **Commit Architecture documetns** Change mode to intern and commit all architecture documents - be sure to include ADR number and feature name in the commit messages.

---

## 5 PLANNING Workflow

The typical flow for planning is:
1. **Review the architecture**
   - Review the feature architecture and ADR.
2. **Evaluate neccessary changes**
   - Evaluate all required changes to achieve the ADR. Evaluate existing code if needed. If you need to research code, delegate a new research task to the **researcher* mode.
3. **Create a plan**
   - Create a plan where each step can be completed in logical order. This means each change could be shippable without breaking the existing code base.
4. **Write the plan to file**
   - Write the implementation plan in (`plans/*.md`). Be sure to include the adr and feature references. *Plans* are Markdown files containing yaml, we do this to get around the fact Architect can only write to .md files. Make sure you write the actual document as YAML. The file is structured as follows:

```yaml
adr: 0003-switch-to-grpc # example ADR reference
feature: 0003-switch-to-grpc # Example feature reference
steps: # An ordered list of tasks, each with the following fields
  - id: step_1
    description: Create proto definitions for User service
    files:
      - package.json
      - package-lock.json
    agentMode: "intern | junior | midlevel | senior" # Defines the agent mode for this step
    status: "scheduled | in_progress | completed" # Tracks the state of the step
  - id: step_2
    description: Generate TypeScript stubs via buf
    files:
      - src/user/generated/*
    agentMode: intern
    status: scheduled
```
5. **Commit Plan** Change mode to intern and commit all planning documents - be sure to include ADR number and feature name in the commit messages.

The `status` field for each step is updated as the workflow progresses. This allows the loop to intelligently resume from the last incomplete step.
+ Important: The agent assigned to a step (`agentMode`) is responsible for *both* executing the task *and* updating the `status` field within the same operation. Delegating status updates separately is incorrect behavior.

## EXECUTING Workflow
Execution will occur against every step in the implementation plan in order listed in the file. Each step completes the following workflow.

1. Update plan step status to in_progress
2. Execute plan step
3. Verify no compile errors
4. Complete step
5. Commit step - Be sure to include ADR number and feature name in the commit messages.


+ **Dependency Handling:** If an implementation step discovers the need for a dependency *not* identified during architecture, the agent assigned to that step (`agentMode`) is responsible for adding it to the appropriate manifest file (e.g., `package.json`, `requirements.txt`, `Cargo.toml`) and ensuring it's installed as part of completing the step's task.

---

## 8 Best Practices

* **One decision → one ADR** – keep records atomic.
* **Keep plans small** – split large features into multiple plans so checkpoints stay meaningful.
* **Reference everything** – ADR number in commit messages, plan in pull-request description.
* **Restart fearlessly** – if an agent stalls, fix the issue and run `roocode resume --plan <your-plan.md>`. The workflow will pick up from the last incomplete step based on the status described in the Markdown plan.

---