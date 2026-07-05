---
name: review-diff
description: Adversarial self-review of the current diff
---

# /review-diff — Adversarial self-review

Review the current diff **as if you are blocking a risky PR**. Find reasons to reject; do not rubber-stamp.

## Workflow

### Step 1: Gather the diff
- **Goal:** Complete picture of the change.
- **Action:** Read the full diff (staged + unstaged, or the branch diff against main). List every changed file.
- **Transition:** Proceed with the full diff in view.

### Step 2: Check each dimension
- **Goal:** Systematic findings, not vibes.
- **Action:** Evaluate against each dimension:

| Dimension | Question |
| --- | --- |
| Hidden behavior changes | Any conditional, default, ordering, or error-handling change not stated in the summary? |
| Test coverage | Is every behavior change covered by a new or updated test? |
| Public API | Any export, signature, HTTP contract, or schema change? Intended and documented? |
| Security | Auth/permission logic touched? Input validation weakened? Secrets present? |
| Data | Migration risks? Rollback path? Destructive statements? |
| Performance | New N+1 patterns, unbounded loops, missing indexes, large payloads? |
| Scope | Unrelated files, drive-by refactors, reformatting noise? |
| Quality | Dead code, duplicated helpers, wrong layer, unclear naming, overengineering? |

- **Transition:** Proceed with findings collected.

### Step 3: Verdict
- **Goal:** A clear pass/block decision.
- **Action:** Classify each finding: **Blocking** (must fix before merge) or **Non-blocking** (note for later). Decide: approve / approve-with-notes / block.
- **Transition:** Report.

## Output Contract (Mandatory)

```markdown
## Verdict
[Approve | Approve with notes | Block]

## Blocking findings
- [file:line — issue — required fix]  (or "none")

## Non-blocking findings
- [file:line — issue]  (or "none")

## Coverage check
[Each behavior change → covering test, or "GAP"]
```

Tone: direct. A review with zero findings on a non-trivial diff is suspicious — look harder before writing "none".
