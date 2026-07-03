# AI Coding Guardrails — Free Edition

**Stop AI coding agents from shipping untested changes.**

This is the free, MIT-licensed core of [AI Coding Guardrails](https://github.com/aico-platform/ai-coding-guardrails): the **Agent Operating Contract** and the essential rules that make Claude Code and Cursor behave like disciplined engineers.

Copy it into your repo. Done in 5 minutes. No hosting, no telemetry, no lock-in.

## What's in the free edition

```
CLAUDE.md                        Core Claude Code instruction file
claude/commands/
  plan-change.md                   /plan-change — plan before code
  review-diff.md                   /review-diff — adversarial self-review
cursor/rules/
  00-agent-operating-contract.mdc  The contract (always applies)
  02-scope-guardrails.mdc          ≤10 files, no drive-by refactors
  03-testing-and-validation.mdc    Verification loop + evidence rules
shared/
  agent-operating-contract.md      The full standard
github/
  pull_request_template.md         Risk + evidence + self-review PR template
```

## Install

```bash
cp CLAUDE.md /path/to/your-repo/
mkdir -p /path/to/your-repo/.claude/commands && cp claude/commands/*.md /path/to/your-repo/.claude/commands/
mkdir -p /path/to/your-repo/.cursor/rules && cp cursor/rules/*.mdc /path/to/your-repo/.cursor/rules/
mkdir -p /path/to/your-repo/docs && cp shared/*.md /path/to/your-repo/docs/
mkdir -p /path/to/your-repo/.github && cp github/pull_request_template.md /path/to/your-repo/.github/
```

Then open `.cursor/rules/03-testing-and-validation.mdc` and point the example commands at your repo's lint/typecheck/test commands.

## Verify it works

Ask your agent:

> Fix a typo in the README, then tell me the risk level and show your evidence.

A guarded agent reports **Risk: Low** and uses the Result / Evidence / Risk / Assumptions format. If it just says "done", the rules aren't loading.

## What the paid pack adds

The free edition is the contract. The **Pro pack (€49)** is the full operating system around it:

| | Free | Pro |
|---|---|---|
| Agent Operating Contract + core rules | ✓ | ✓ |
| `/plan-change`, `/review-diff` | ✓ | ✓ |
| `/fix-bug`, `/implement-safely`, `/write-tests-first`, `/refactor-safely`, `/prepare-pr`, `/release-check` | — | ✓ |
| Security, database, refactoring, git/PR rules | — | ✓ |
| Risk classification model (Low→Critical decision tables) | — | ✓ |
| Prompt-injection boundary + tool-use policy standards | — | ✓ |
| Pre-implementation / pre-PR / pre-release / rollback checklists | — | ✓ |
| 5-level compliance & adoption framework | — | ✓ |
| Example compliant agent report | — | ✓ |

**Team (€299)** adds an organization-wide license, adoption guide, and internal AI-coding policy templates.

→ **[Get the full pack](https://github.com/aico-platform/ai-coding-guardrails)** (checkout links at launch)

## License

Free edition: [MIT](LICENSE.md). Use it anywhere, including commercially. If it saves your team from one bad AI-generated deploy, tell a friend — that's the price.
