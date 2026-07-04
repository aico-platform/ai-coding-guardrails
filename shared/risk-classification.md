# Risk Classification (Free Edition)

Every change gets exactly one risk level before implementation. When in doubt, choose the higher level.

> **Pro pack** adds detailed merge requirements, escalation rules, and worked examples in the full `risk-classification.md`.

## Levels

| Level | When | Agent must |
| --- | --- | --- |
| **Low** | Single file, tests exist, no exported behavior change | State risk and proceed |
| **Medium** | Business logic, user-visible behavior, or multiple modules | Plan first; include rollback recommendation |
| **High** | Auth, billing, DB schema, permissions, infra, external APIs | Plan first; **wait for human approval before editing** |
| **Critical** | Production data, secrets, irreversible changes | Plan first; **explicit approval**; tested rollback required |

## Quick decision rules

| If the change touches… | Risk is at least… |
| --- | --- |
| Secrets, production data deletion, security boundaries | Critical |
| Auth, billing, DB migrations, permissions, infra | High |
| Business logic, public APIs, shared utilities | Medium |
| One isolated file, covered by tests, no behavior change | Low |

## Output

Always report risk in the output contract:

```markdown
## Risk
High — payment retry path; behavior must stay identical; stopping for approval.
```
