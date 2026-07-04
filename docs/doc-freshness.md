# Documentation freshness & seamless UX

**Key concern:** documentation and user-facing copy must **always match shipped behavior**. UX must feel **seamless** — no stale landing page, no README lies.

Applies to: README, `docs/`, rules, **GitHub Pages landing**, CHANGELOG, onboarding (`tooling-context`).

---

## Principles

1. **Docs are part of the deliverable** — same PR as code when behavior changes.
2. **Truth over aspiration** — document what **is**; label roadmap items **planned**.
3. **One source of truth** — behavior lives in repo; the landing page **summarizes and links**.
4. **Seamless UX** — install and first success need minimal steps; error paths documented for UI.
5. **Evolve in place** — update existing pages before adding new ones.

---

## What must stay in sync

| Surface | Update when |
| --- | --- |
| README / install docs | Install path, features, examples change |
| `docs/` | Process or onboarding changes |
| Landing (`docs/index.html`) | Product narrative, CTAs, demo links |
| `AGENTS.md`, rules | Contract or rule changes |
| `docs/tooling-context.md` | Tools or org context changes |

**Landing rule:** if the site claims a feature, it must exist in the pack or be labeled **planned** / beta.

---

## PR gate (Level 4+)

Declare **Documentation** in the PR template:

- **Updated** — list paths touched
- **N/A** — explicit reason (internal-only change)

When using `check_pr_body.sh` CI, exactly one box is required.

---

## Seamless UX checklist

- [ ] Happy path ≤ minimal steps (install, first success)
- [ ] Error states have user-readable messages (documented)
- [ ] Links work (no dead demo or transcript URLs)
- [ ] Terminology consistent (README = landing = `AGENTS.md`)
- [ ] `init.sh` / onboarding docs match actual scripts

---

## Agent rule

If you change user-visible behavior and cannot update docs in the same PR, **stop** — do not merge code-only.

See partner principles §5 in `shared/partner-principles.md`.
