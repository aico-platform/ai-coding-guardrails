# Contributing

Thanks for helping make AI coding agents more disciplined. Contributions of all sizes are welcome.

## What makes a good contribution

- **Bug reports with transcripts.** If a rule made your agent behave *worse* — over-asking, refusing reasonable work, misclassifying risk — that's a bug. Open an issue and include the agent transcript (redact anything private) and which tool you were using (Claude Code, Cursor, Codex CLI, ...).
- **Rule improvements.** Tighter wording, a missing Never/Always case, a workflow step that agents consistently skip. Keep the change minimal and explain the failure it prevents.
- **New tool support.** If your agent tool loads instructions from a different file or format, a PR adding an adapter (like `AGENTS.md`) is very welcome.
- **Evidence from the field.** Real examples of the guardrails catching (or missing) a bad change are the most valuable feedback there is.

## Ground rules for changes

The pack follows its own standards, so PRs are expected to:

1. **Stay in scope.** One concern per PR. No drive-by rewording of unrelated rules.
2. **Justify every rule change.** Each rule exists to prevent a specific failure mode. A PR that weakens or removes a rule must say which failure mode it re-opens and why that trade-off is right.
3. **Keep instructions literal and testable.** Rules should be enforceable ("run lint, typecheck, and tests") rather than aspirational ("write good code").
4. **Fill in the PR template.** Yes, including the risk level and evidence sections — it's the product.

## Style

- Plain markdown, no HTML except where GitHub requires it.
- Imperative voice for rules ("Never claim completion without evidence").
- Cursor rules (`.mdc`) keep their YAML frontmatter (`description`, `alwaysApply`).

## Questions

Open a [discussion or issue](https://github.com/aico-platform/ai-coding-guardrails/issues) — happy to talk through an idea before you write it up.
