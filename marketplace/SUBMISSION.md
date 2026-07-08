# Marketplace submission — AI Coding Guardrails (free MIT core)

Distinct plugin distributions for **Cursor** and **Claude Code**. Pro + Team OS stays off public marketplaces (private beta / commercial).

---

## Layout (public repo)

```
ai-coding-guardrails/
├── .cursor-plugin/marketplace.json      # Cursor catalog
├── .claude-plugin/marketplace.json      # Claude catalog
├── marketplace/
│   ├── cursor/ai-coding-guardrails/     # Cursor-native: rules + commands
│   └── claude/ai-coding-guardrails/     # Claude-native: commands + skills
├── install.sh                           # Repo copy install (all tools)
└── … (MIT pack-free files at root)
```

Built from ministry via `scripts/build_marketplace_dists.sh` + `scripts/sync_public_repo.sh`.

---

## Cursor Marketplace

| Item | Value |
| --- | --- |
| **Submit** | https://cursor.com/marketplace/publish |
| **Repo** | https://github.com/aico-platform/ai-coding-guardrails |
| **Plugin path** | `marketplace/cursor/ai-coding-guardrails` |
| **License** | MIT (required — open source for public listing) |
| **Review** | Manual security + quality |

### Pre-submit checklist

- [ ] `bash scripts/build_marketplace_dists.sh` (ministry) or verify `marketplace/cursor/` in public repo
- [ ] Load locally: copy plugin dir to `~/.cursor/plugins/local/ai-coding-guardrails`
- [ ] Rules appear in Customize; verify prompt obeys contract
- [ ] Commands `/plan-change` and `/review-diff` discoverable
- [ ] Logo: `assets/before-after.svg` committed
- [ ] README in plugin dir documents Pro/Team **not** in this listing

---

## Claude Code (community marketplace)

| Item | Value |
| --- | --- |
| **Submit** | https://clau.de/plugin-directory-submission |
| **Repo** | https://github.com/aico-platform/ai-coding-guardrails |
| **Plugin path** | `marketplace/claude/ai-coding-guardrails` |
| **License** | MIT |
| **Review** | Automated scan + Anthropic review → `claude-plugins-community` |

### Pre-submit checklist

- [ ] `/plugin marketplace add aico-platform/ai-coding-guardrails` (after merge)
- [ ] `/plugin install ai-coding-guardrails@…` (slug TBD at approval)
- [ ] Commands and `guardrails-contract` skill load
- [ ] No Cursor `.mdc` files in Claude plugin (intentional split)

### Self-hosted marketplace (Pro preview, optional)

Teams can add a **private** git repo with `.claude-plugin/marketplace.json` without community review — use for paid tier later, not public Pro prompts.

---

## What NOT to publish

| Asset | Channel |
| --- | --- |
| Pro rules (security, database, full commands) | Private beta zip / checkout |
| Team OS agents, TEAM.md | Private beta / Cursor Team marketplace |
| LICENSE-BETA zip | guardrails-beta releases only |

Publishing Pro/Team on public marketplaces would conflict with LICENSE-BETA and commercial tier.

---

## Versioning

Plugin `version` in manifests tracks `pack/VERSION`. Re-run build + sync + request marketplace re-index after each free-edition release.

---

## Ministry commands

```bash
bash scripts/build_pack.sh
bash scripts/build_marketplace_dists.sh
PUBLIC_REPO=/path/to/ai-coding-guardrails bash scripts/sync_public_repo.sh
```

Then PR public repo and submit marketplace forms.
