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
├── plans/                    # Implementation plans (*.yaml)
├── src/                      # Application code
├── runtime_checkpoints/      # RooCode checkpoint state (auto-managed)
├── scripts/
```

---

## 2 Key Artifacts

| Artifact | Purpose | When it’s written |
|----------|---------|-------------------|
| **Overall Architecture (`architecture/overall-architecture.md`)** | High-level view of the entire system. | Initially, then updated as needed during **ARCHITECTING**. |
| **Feature Architecture (`architecture/features/*.md`)** | Detailed design for a specific feature. | Created or updated during **ARCHITECTING**, triggered by an ADR. |
| **ADR (`architecture/adr/*.md`)** | Records a specific decision impacting feature or overall architecture. Links to relevant Feature Architecture. | During **ARCHITECTING** |
| **Plan (`plans/*.yaml`)** | Step-by-step implementation checklist tied to an ADR. | During **PLANNING** |
| **Code commits** | Actual changes produced by AI agents. | During **EXECUTING** |
| **Checkpoint state** | JSON blobs that let RooCode resume the workflow. | After every state transition |

---

## 3 States & Agents

| State | Responsible Agent | Outputs | Checkpoint Key |
|-------|-------------------|---------|----------------|
| **ARCHITECTING** | *Architect* | new/updated ADR, new/updated Feature Architecture, updated Overall Architecture (if needed), initial plan | `arch_hash` |
| **PLANNING** | *Architect* | refined `plans/*.yaml` | `plan_hash` |
| **EXECUTING** | *Intern → Junior → Mid → Senior* | code changes  | `step_n` |
| **VERIFYING** | *Senior* or test harness | test report; success flag | `verify_ok` |

If a state fails, the Micro-Manager awaits human input.

---

## 4 Architecture Workflow

The typical flow for architectural changes is:

1. **Create/Update ADR:**
   - Copy `architecture/adr/0000-template.md` → `000N-title.md`.
   - Fill in the ADR details (Context, Decision, etc.).
   - Crucially, specify if this ADR `New` or `Modifies` a Feature Architecture and provide the link (e.g., `[./architecture/features/000N-feature-name.md]`).
   - Commit the ADR.
2. **Create/Update Feature Architecture:**
   - Based on the ADR, create a new Feature Architecture document in `architecture/features/` (using `architecture/feature-template.md`) or update the existing one linked in the ADR.
   - Detail the specific components, interactions, data flows, etc., for the feature.
   - Commit the Feature Architecture document.
3. **Update Overall Architecture (If Necessary):**
   - Review `architecture/overall-architecture.md`.
   - If the changes introduced by the ADR and Feature Architecture significantly impact the high-level view (e.g., adding a major new service, changing core patterns), update the diagram and descriptions accordingly.
   - Commit changes to the Overall Architecture.
4. **Proceed to Planning:** Once the architecture artifacts are stable, create or refine the implementation plan (`plans/*.yaml`) based on the ADR and Feature Architecture.
5. **Reference:** Ensure the ADR number is referenced in commit messages and the implementation plan.

---

## 5 Implementation-Plan Workflow

*Plans* are YAML files containing an ordered list of tasks:

```yaml
adr: 0003-switch-to-grpc
steps:
  - id: step_1
    description: "Create proto definitions for User service"
    files: ["src/user/user.proto"]
  - id: step_2
    description: "Generate TypeScript stubs via buf"
    files: ["src/user/generated/*"]
```

Each step becomes a checkpoint (`step_n`) so the loop can resume after interruptions.

---

## 6 Running the Loop

```bash
# Kick off a new feature
roocode run --manager archflow --request "Add MFA login flow"

# Resume after manual fix
roocode resume --manager archflow
```

RooCode handles checkpoint persistence in `runtime_checkpoints/`.

---

## 8 Best Practices

* **One decision → one ADR** – keep records atomic.
* **Keep plans small** – split large features into multiple plans so checkpoints stay meaningful.
* **Reference everything** – ADR number in commit messages, plan in pull-request description.
* **Restart fearlessly** – if an agent stalls, fix the issue and run `roocode resume`.

---

Happy coding — and may your boomerangs always return 🏹