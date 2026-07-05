# AI Coding Guardrails — Claude Code plugin

**Distinct distribution for [Claude Code plugins](https://code.claude.com/docs/en/discover-plugins).** MIT free core — slash commands + contract skill optimized for Claude Code.

Pro + Team OS is **not** included here.

## Install (marketplace)

After community listing:

```text
/plugin marketplace add aico-platform/ai-coding-guardrails
/plugin install ai-coding-guardrails@aico-community
```

(Exact marketplace slug confirmed at submission.)

Local test: clone the public repo and add it as a custom Claude marketplace source.

## What's included

| Component | Purpose |
| --- | --- |
| **commands/** | `/plan-change`, `/review-diff` |
| **skills/guardrails-contract/** | Operating contract (Agent Decides / manual invoke) |

Claude Code does not use Cursor `.mdc` rules — behavior lives in **commands + skills**.

## Repo install (alternative)

```bash
curl -fsSL https://raw.githubusercontent.com/aico-platform/ai-coding-guardrails/main/install.sh | bash
```

Copies `CLAUDE.md`, commands, and shared docs into your project.

## Verify

> /plan-change add input validation to the login form

Then implement only after plan approval for High-risk paths.

## Links

- [Public repo](https://github.com/aico-platform/ai-coding-guardrails#install-claude-code)
- [Demo](https://github.com/aico-platform/guardrails-demo)
