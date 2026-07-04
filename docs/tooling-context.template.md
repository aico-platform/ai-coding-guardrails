# Tooling & organization context for AI agents

Generated and maintained by `scripts/configure_onboarding.sh` (part of `scripts/init.sh`).  
**Edit freely** — agents treat this as the source of truth for company, project, and toolchain. Re-run init on deploy to refresh auto-detected stack/risk sections.

Extends `docs/guardrails-context.md` (stack/risk). Read both before planning or handoff.

---

## Company

# guardrails-company-start
(not configured — run: bash scripts/init.sh)
# guardrails-company-end

## Project

# guardrails-project-start
(not configured)
# guardrails-project-end

## Active tooling

Which systems this repo uses. Agents **only** reference tools marked active.

# guardrails-tooling-start
| Domain | Tool | Active | Reference / id format |
| --- | --- | --- | --- |
| Version control | GitHub | yes | repo: (this repo) |
| Tracking | GitHub Issues | yes | `#123` |
| Tracking | Linear | no | `LIN-123` |
| Docs | README / repo docs | yes | path under `docs/` |
| Design | — | no | |
| Wiki | — | no | |
| Files | — | no | |
# guardrails-tooling-end

## Integration notes (per tool)

Agent conventions when MCP or CLI is available. Baselines from `docs/integrations/baseline/`; override in `docs/integrations/custom.md`.

# guardrails-integrations-start
(no tool profiles merged — select tools in init or edit manually)
# guardrails-integrations-end

## Custom evolution log

Team-specific changes (optional). Append dated entries when process or tools change.

# guardrails-evolution-start
| Date | Change | Author |
| --- | --- | --- |
| | | |
# guardrails-evolution-end

---

## Handoff convention (tracking ids)

When an epic exists, **Context** must include:

```markdown
**Tracking:** #123 (GitHub) / LIN-456 (Linear) / PROJ-789 (Jira)
**Docs:** link or path
**Design:** Miro board URL (if UI work)
```

Use the **active** row from the tooling table only.
