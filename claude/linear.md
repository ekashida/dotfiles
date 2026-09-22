## Linear (Trebellar repos)

Applies in repos whose `origin` is under `github.com/trebellar/`. Goal: anyone at Trebellar, including a PM, can see from Linear what I'm working on, and issues close roughly daily.

**When.** Before implementation that will produce a PR, or before a time-boxed investigation, make sure a Linear issue covers it. Search first (`list_issues` with a `query`, `limit` ~10, only the `fields` you need); if nothing matches, draft one and show it to me. Create nothing in Linear until I approve the draft.

**Granularity.** One issue per PR. Multi-PR work → a project containing standalone issues, never parent/sub-issues. Work too small for its own PR → a checkbox on the related issue.

**Writing.** Title: the outcome, in terms a PM recognizes ("Manually-run scheduled reports keep their schedule settings"), not the mechanism. Description, in order: who's affected and why it matters → scope as checkboxes → a `## Technical notes` section → links. For non-user-facing work (refactors, tooling), frame the why as risk reduced or work unblocked. Reference PRs as `trebellar/frontend PR NNNN` — a bare `#NNNN` auto-links to the wrong repo.

**Properties.** Fill in every property in the draft. Two paths, because the triager owns project, owner, priority and area label:

| Property | Mine (I'm doing the work) | Someone else's (e.g. Backend) |
|---|---|---|
| Team | Product (`PRD-`); Delivery (`GTM-`) only for customer-deliverable work | same |
| Assignee | me | never me; a named owner only if I give one, otherwise unassigned |
| Status | Queued if starting this cycle, Backlog if later | Triage |
| Cycle | current cycle if Queued, none if Backlog | none |
| Priority | always set: Urgent = prod broken / customer blocked; High = customer-visible bug or blocks a current-cycle commitment; Medium = default; Low = polish/cleanup | unset |
| Labels | exactly one Discipline label; at most one area label; `Bug` for defects | Discipline + `Bug` only |
| Project | an active project if the work clearly fits; none for standalone issues; flag multi-PR work that has no project instead of creating one | unset |
| Relations | "blocked by" for real dependencies; "related" for the issue that prompted this one | same |

A Frontend feature needing a new core-service endpoint is two issues: the Frontend one (mine, Queued) blocked by a Backend one (unassigned, Triage).

**Workspace facts** (as of Sept 2026 — if a write is rejected, re-check the workspace rather than retrying):
- Product statuses: Triage → Backlog → Queued → In Progress → In Review → Done → Deployed. Opening and merging the PR move In Review and Done automatically when the branch contains the issue ID.
- Discipline labels (pick one, chosen by the kind of work, not the repo): `Frontend`, `Backend`, `Design`, `ML`.
- Area labels under `Trebellar Suite` (pick at most one, by user-facing surface): `Chats`, `AI Agents`, `Home`, `Planner`, `Dashboards`, `Reports`, `Explorer`, `Lease`, `OpEx`, `Data Provisioning`. `Chats` = chat UX, `AI Agents` = agent internals.
- Situational labels, only when their description clearly applies: `Public`, `Data Quality`, `Needs verification`, `Blocked: Customer Input`. Never apply retired labels (e.g. `Feature`, `Improvement`, the `Tier` group, `Frontened`).
- Cycles are 2 weeks. Look up the current cycle only when creating a Queued issue, and active projects only when one plausibly fits.

Team policy is in the Linear Operating Model doc (Google Drive, id `1wmE3RA5FfpuVoCyXj43tisHxMie62DzaycRYBViCI68`). Its cycle length and team list are outdated. Read it through a cheaper-model subagent, not inline.
