# {NUMBER}. {Short, imperative decision title}

*Status*: {Proposed | Accepted | Superseded by #NNNN | Deprecated}
*Date*: {YYYY-MM-DD}
*Decision Makers*: @{github-handle1}, @{github-handle2}
*Feature Architecture*: {New | Modifies | References} [./architecture/features/NNNN-feature-name.md](Feature Name)

---

## Context
Describe **why** this decision is needed. Summarize the problem, constraints, and any relevant background.

## Decision
State the choice clearly in one short paragraph. *E.g.*
> We will replace our REST-based internal APIs with gRPC to reduce payload size and add bidirectional streaming.

## Consequences
- **Positive**: list immediate benefits (performance, simplicity, etc.).
- **Negative / Trade-offs**: highlight costs (migration effort, new dependencies, lock-in).

## Alternatives Considered
1. **Option A** – brief pros / cons
2. **Option B** – brief pros / cons
*(Remove this section for trivial decisions.)*

## References
- Links to tickets, benchmarks, POCs, diagrams, docs, etc.

---

*Supersedes*: {optional link to an older ADR that this one replaces}