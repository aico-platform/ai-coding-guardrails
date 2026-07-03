# /plan-change — Plan before code

Produce a reviewable implementation plan. **Planning only — do not modify any file.**

## Workflow

### Step 1: Understand
- **Goal:** State the requested change in one sentence.
- **Action:** Read the relevant code. Identify every impacted file and its current behavior. Quote the specific functions or sections that would change.
- **Transition:** Proceed when the blast radius is known; if the request is ambiguous, ask **one** focused question and stop.

### Step 2: Classify risk
- **Goal:** Assign Low / Medium / High / Critical per `docs/risk-classification.md`.
- **Action:** Check touched areas against the risk decision table. Apply escalators (no test coverage, >10 files, hard to revert).
- **Transition:** Proceed to Step 3.

### Step 3: Plan
- **Goal:** A plan a reviewer can approve or reject in under two minutes.
- **Action:** Produce the output contract below. Name concrete artifacts: exact file paths, exact test names, exact commands.
- **Transition:** End turn. Implementation happens only after approval (High/Critical) or via `/implement-safely`.

## Output Contract (Mandatory)

```markdown
## Task understanding
[One sentence]

## Risk
[Level] — [one-line justification]

## Impacted files
- path — why

## Behavior change
[Before → after, user/consumer visible effects]

## Tests
- [test file / test name to add or update]

## Compatibility risks
[Or "none identified"]

## Rollback
[How to revert if this ships broken]

## Open questions
[Blocking vs non-blocking; or "none"]
```

Exclude: implementation code, unrequested scope, drive-by improvement suggestions.
