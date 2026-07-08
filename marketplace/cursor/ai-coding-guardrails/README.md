# AI Coding Guardrails — Cursor plugin

**Distinct distribution for [Cursor Marketplace](https://cursor.com/marketplace).** MIT free core — rules + commands optimized for Cursor IDE.

Pro + Team OS (multi-agent SDLC) is **not** included here; see private beta / future commercial channels.

## Install (marketplace)

After listing: **Cursor → Customize → Marketplace → AI Coding Guardrails**

Or load locally for testing:

```bash
git clone https://github.com/aico-platform/ai-coding-guardrails.git
# Copy the Cursor plugin folder from the repo into ~/.cursor/plugins/local/ai-coding-guardrails
```

## What's included

| Component | Purpose |
| --- | --- |
| **rules/** | Always-on `.mdc` guardrails (contract, scope, testing) |
| **commands/** | `/plan-change`, `/review-diff` style workflows |
| **assets/** | Plugin logo |

## Repo install (alternative)

One-shot copy into a project (all tools):

```bash
curl -fsSL https://raw.githubusercontent.com/aico-platform/ai-coding-guardrails/main/install.sh | bash
```

## Verify

> Fix a typo in the README, then tell me the risk level and show your evidence.

## Links

- [Public repo](https://github.com/aico-platform/ai-coding-guardrails#install-cursor)
- [Demo transcripts](https://github.com/aico-platform/guardrails-demo)
