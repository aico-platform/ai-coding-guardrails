# Tool integrations (baseline profiles)

**Plugins, not a runtime.** This folder ships **markdown profiles** agents read via `docs/tooling-context.md` — not live API connectors.

## How it works

1. **Install / deploy:** `bash scripts/init.sh` → `configure_onboarding.sh` selects active tools.
2. **Baseline profiles** (`baseline/*.md`) merge into `docs/tooling-context.md` (integration notes section).
3. **MCP / CLI:** Wire in your IDE (e.g. Linear MCP, `gh` CLI). Profiles tell agents *when* and *how* to reference tools, not secrets.
4. **Evolve:** Edit `docs/tooling-context.md` or add `docs/integrations/custom.md` for company-specific rules.

## Baseline tools

| Profile | Primary roles | Typical use |
| --- | --- | --- |
| [github.md](baseline/github.md) | pm-planner, devops-release | Issues, PRs, Actions, Projects |
| [linear.md](baseline/linear.md) | pm-planner | Issues, cycles, projects |
| [jira.md](baseline/jira.md) | pm-planner | Epics, sprints, JQL keys |
| [confluence.md](baseline/confluence.md) | doc-writer, pm-planner | Specs, runbooks, ADR links |
| [sharepoint.md](baseline/sharepoint.md) | doc-writer, staff-security | Policy docs, compliance artifacts |
| [miro.md](baseline/miro.md) | ux-designer, pm-planner | Flows, wireframes (reference only) |

## Custom integrations

Create `docs/integrations/custom.md`:

```markdown
# Company-specific tool rules
- Notion replaces Confluence for product specs: https://...
- All epics must link Notion page id in handoff Context
```

Agents read `custom.md` after baselines.

## Security

- Never commit tokens, cookies, or MCP secrets.
- Internal URLs OK in tooling-context; mark `(internal)` if agents must not paste externally.
