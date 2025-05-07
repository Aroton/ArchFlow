# Archflow Workflow 🌐

This repository implements an **AI-orchestrated development loop** nick-named **Archflow**.
The loop automates design → plan → code → verify, while staying restart-safe and fully auditable.
It is managed by an **Orchestrator** agent that coordinates complex workflows by delegating tasks to specialized agents (modes), tracking progress via status updates in Plan Markdown files, and ensuring the overall process adheres to the defined states (ARCHITECTING -> PLANNING -> EXECUTING -> VERIFYING). The Orchestrator breaks down user requests, manages subtask delegation and results, asks clarifying questions when needed, and synthesizes the final outcome.

---

## 1 Folder Layout

```
.
└── archflow/                 # Root directory created by init script
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
    └── scripts/                  # Project-specific scripts (if applicable)
```
Note: The `init_adr_workspace.sh` script (located in the ArchFlow repository root) initializes this structure within the `archflow/` subdirectory of your target project directory.

---

## 2 Key Artifacts

| Artifact | Purpose | When it’s written |
|----------|---------|-------------------|
| **Overall Architecture (`archflow/architecture/overall-architecture.md`)** | High-level view of the entire system. | Initially, then updated as needed during **ARCHITECTING**. |
| **Feature Architecture (`archflow/architecture/features/*.md`)** | Detailed design for a specific feature. | Created or updated during **ARCHITECTING**, triggered by an ADR. |
| **ADR (`archflow/architecture/adr/*.md`)** | Records a specific decision impacting feature or overall architecture. Links to relevant Feature Architecture. | During **ARCHITECTING** |
| **Plan (`archflow/plans/*.md`)** | Step-by-step implementation checklist tied to an ADR, written in Markdown. Contains status fields (`scheduled`, `in_progress`, `completed`) for each step, enabling workflow resumption. | During **PLANNING**, updated during **EXECUTING** |
| **Code commits** | Actual changes produced by AI agents. | During **EXECUTING**, **ARCHITECTING**, **PLANNING** |

---

## 3 Workflow States & Agent Roles

The Archflow process moves through distinct states, with tasks primarily delegated by the Orchestrator to specialized agents (modes):

| State          | Primary Agent(s)                     | Key Outputs                                                                 |
|----------------|--------------------------------------|-----------------------------------------------------------------------------|
| **ARCHITECTING** | *Architect*  (may use *Researcher*  | New/updated ADR, Feature Architecture, Overall Architecture (if needed)     |
| **PLANNING**     | *Architect* (may use *Researcher*) | Detailed `plans/*.md` file with steps, agent assignments, and status fields |
| **EXECUTING**    | *Intern, Junior, Midlevel, Senior*   | Code changes, updated plan step status, commits                             |
| **VERIFYING**    | *Senior* or test harness             | Test report, success flag, updated plan verification status                 |

### Agent Mode Descriptions & Capabilities

The Orchestrator delegates tasks to the following modes based on complexity and requirements:

*   **Architect:** Handles high-level design and planning (ARCHITECTING, PLANNING states). Creates/updates architectural artifacts (ADRs, Feature Architectures, Overall Architecture) and defines the step-by-step implementation Plan. Can be re-engaged if the planned approach encounters issues.
*   **Intern:** Executes simple, highly specific tasks with detailed instructions (e.g., function names, parameters, purpose provided). Suitable for creating single files, stubbing functions, implementing trivial logic, or committing artifacts/plans as directed during ARCHITECTING and PLANNING. Requires precise guidance for code-writing tasks.
*   **Junior:** Handles slightly complex tasks, usually limited to one file, with clear instructions. Capable but requires explicit direction. Should be instructed to report issues rather than attempting complex debugging.
*   **Midlevel:** Tackles broader tasks potentially spanning multiple files. Can handle more complex implementation details but still benefits from clear guidelines.
*   **Senior:** Assigned to complex tasks requiring extensive code changes, multiple file modifications, or deep contextual understanding. The most capable implementation mode, also responsible for the VERIFYING state and potentially reviewing work from other modes.
*   **Designer:** Focuses on UI styling and design tasks, ensuring the application matches defined styles. Should report non-styling issues rather than attempting to fix them.
*   **Researcher:** Gathers specific information about the codebase (e.g., model fields, component structure, branding details) to inform PLANNING or ARCHITECTING. Can be instructed to search the web if necessary.

### Failure Handling & Escalation

*   **EXECUTING State:** If an agent fails a task, the Orchestrator should retry with the next higher mode in the sequence: Intern → Junior → Midlevel → Senior.
*   **Other States (ARCHITECTING, PLANNING, VERIFYING):** If a failure occurs in these states, the Orchestrator reports the failure and awaits human input.

### Delegated Task Requirements

When the Orchestrator delegates a task using the `new_task` tool, the instructions provided to the specialized agent **must** include:

*   **Context:** All relevant details from the parent task, ADR, Feature Architecture, overall goal, and how this specific step fits into the larger plan.
*   **Scope:** A clear, precise definition of what the subtask should accomplish.
*   **Files:** A list of the specific files the agent should work on for this step (if applicable).
*   **Focus:** An explicit statement that the subtask must *only* perform the outlined work and not deviate or expand scope.
*   **Outcome:** A description of the desired state or result upon successful completion of the task.
*   **Plan Update (EXECUTING state only):** A mandatory instruction that the agent must update the `status` field in the relevant Plan Markdown file to `"in_progress"` upon starting the task and to `"completed"` upon successful completion. This status update **must** occur within the same operation/commit as the primary task execution. The valid status values are `scheduled | in_progress | completed`.
*   **Completion:** An instruction to use the `attempt_completion` tool upon finishing. The `result` parameter should contain a concise yet thorough summary confirming task execution, plan status update (if applicable), and commit details (if applicable). This summary is crucial for tracking progress.
*   **Instruction Priority:** A statement clarifying that these specific subtask instructions override any conflicting general instructions the agent mode might have.
*   **Mode Restriction:** A statement prohibiting the subtask agent from switching modes itself; it must complete its assigned task and then call `attempt_completion`.

---

## ARCHITECTING Workflow

The typical flow for architectural changes is:

1. **Create/Update ADR:**
   - Copy `archflow/architecture/adr/0000-template.md` → `000N-title.md`.
   - Fill in the ADR details (Context, Decision, etc.).
   - Crucially, specify if this ADR `New` or `Modifies` a Feature Architecture and provide the full relative path (e.g., `archflow/architecture/features/000N-feature-name.md`).
2. **Create/Update Feature Architecture:**
   - Based on the ADR, create a new Feature Architecture document in `archflow/architecture/features/` (using `archflow/architecture/feature-template.md`) or update the existing one linked in the ADR.
   - Detail the specific components, interactions, data flows, etc., for the feature.
3. **Update Overall Architecture:**
   - Review `archflow/architecture/overall-architecture.md`.
   - If the changes introduced by the ADR and Feature Architecture significantly impact the high-level view (e.g., adding a major new service, changing core patterns), update the diagram and descriptions accordingly.
4. **Identify & Verify Dependencies:**
   - Based on the Feature Architecture, identify potential new external software dependencies (libraries, packages, etc.).
   - Check the project's relevant package manager file (e.g., `package.json`, `requirements.txt`) to verify if these dependencies are already installed or part of the existing project setup.
   - List any required *new* dependencies that need to be installed in the initial implementation plan.
5. **Proceed to Planning:** The Orchestrator will initiate the PLANNING state next. The plan file itself is created during PLANNING.
6. **Commit Architecture Documents:** The Orchestrator delegates a final task to the *Intern* mode to commit the created/updated architectural documents (ADR, Feature Arch, Overall Arch if changed), referencing the ADR number and feature name in the commit message.

*Note: All delegated tasks follow the guidelines outlined in the "Delegated Task Requirements" section.*

---

## 5 PLANNING Workflow

The typical flow for planning is:
1. **Review the architecture**
   - Review the feature architecture and ADR.
2. **Evaluate neccessary changes**
   - Evaluate all required changes to achieve the ADR. Evaluate existing code if needed. If you need to research code, delegate a new research task to the **researcher* mode.
   - Be sure to include all reference files.
3. **Create a plan**
   - Decompose the work into **atomic, independently verifiable steps** that can be completed in logical order. Each step should represent a small, incremental change that ideally leaves the system in a stable, shippable state.
   - **Crucially, ensure each step results in a testable state.** For UI changes, this means the modification should be visible and verifiable in the UI after the step is completed.
   - **Note:** The plan defines the *what* (intent, logic, files to modify) for each step, not the *how*. Avoid including detailed code snippets; the executing agent is responsible for implementation based on the plan's guidance.
4. **Create and Write the Plan File**
   - Copy the template `plans/0000-template.md` to a new file named `plans/NNNN-plan-name.md` (where `NNNN` matches the corresponding ADR number).
   - Edit the new plan file (`plans/NNNN-plan-name.md`):
     - Update the placeholder title and description at the top.
     - **Crucially**, update the `adr:` and `feature:` fields within the YAML block to contain the **full relative paths** to the specific ADR and Feature Architecture documents being implemented (e.g., `adr: archflow/architecture/adr/0003-switch-to-grpc.md`, `feature: archflow/architecture/features/0003-switch-to-grpc.md`).
     - Define the implementation `steps`, specifying the `id`, `description`, `files` involved, `agentMode`, and initial `status` ("scheduled") for each.
   - Ensure the plan file adheres to the YAML structure defined in the template.
5. **Commit Plan:** The Orchestrator delegates a final task to the *Intern* mode to commit the created/updated plan file, referencing the ADR number and feature name in the commit message.

The `status` field for each step is updated by the assigned agent during the EXECUTING state. This allows the workflow loop to intelligently resume from the last incomplete step.
+ Important: The agent assigned to a step (`agentMode`) is responsible for *both* executing the task *and* updating the `status` field within the same operation (typically the commit). Delegating status updates separately is incorrect behavior.

*Note: All delegated tasks follow the guidelines outlined in the "Delegated Task Requirements" section.*

## 6 EXECUTING Workflow
Execution proceeds step-by-step through the plan. The plan guides the *intent* of each step; the assigned agent (`agentMode`) is responsible for determining the specific code implementation. **Plans should not contain detailed code examples.** Each step follows this workflow:

1. Update plan step status to in_progress
2. Load files needed for context
3. Execute plan step
4. Verify no compile errors - If there are compile errors, fix them.
5. Verify no linter errors - If there are linter errors, fix them.
6. Complete step
7. Commit step - Be sure to include ADR number and feature name in the commit messages.

+ **Dependency Handling:** If an implementation step discovers the need for a dependency *not* identified during architecture, the agent assigned to that step (`agentMode`) is responsible for adding it to the appropriate manifest file (e.g., `package.json`, `requirements.txt`, `Cargo.toml`) and ensuring it's installed as part of completing the step's task.

## 7 VERIFYING Workflow

Once all plan steps are marked `completed`, the Orchestrator initiates the VERIFYING state:

1.  **Delegate Verification:** The Orchestrator delegates the verification task to the *Senior* agent (or triggers an automated test harness if configured). Instructions should specify the scope of verification (e.g., run unit tests, integration tests, linters, perform specific manual checks based on the feature).
2.  **Analyze Results:** The Orchestrator receives the verification report (e.g., test results, linting output, Senior agent's assessment).
3.  **Handle Outcome:**
    *   **Success:** If verification passes, mark the plan as verified (e.g., add `verified: true` to the Plan Markdown's YAML block or update a status field) and commit this change. The overall workflow for this plan is now complete.
    *   **Failure:** If verification fails, the Orchestrator reports the failure details and **awaits human input** for remediation steps (e.g., creating a new plan for fixes, reverting changes).

*Note: All delegated tasks follow the guidelines outlined in the "Delegated Task Requirements" section.*

---

## 8 Best Practices

* **One decision → one ADR** – keep records atomic.
* **Keep plans small** – split large features into multiple plans so checkpoints stay meaningful.
* **Reference everything** – ADR number in commit messages, plan in pull-request description.
* **Restart fearlessly** – if an agent stalls, fix the issue and run `roocode resume --plan <your-plan.md>`. The workflow will pick up from the last incomplete step based on the status described in the Markdown plan.

---