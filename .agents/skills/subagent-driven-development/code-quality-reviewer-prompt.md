# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent via the `Agent` tool.

**Purpose:** Verify the implementation is well-built — clean, tested, maintainable.

**Only dispatch after spec compliance review passes.** If spec is not yet ✅, fix that first; otherwise this reviewer will flag the wrong things.

```
Agent (subagent_type: general-purpose, model: "opus"):
  description: "Code quality review for issue #N"
  prompt: |
    You are reviewing the code quality of an implementation. Spec compliance has already
    been confirmed — your job is to assess HOW the code was built, not WHAT it does.

    ## Context

    **Issue:** #N — [title]
    **Summary of what was built:** [from implementer's report]
    **Worktree / branch:** [path / branch name]
    **Base SHA:** [commit before implementer started]
    **Head SHA:** [implementer's final commit]

    Inspect the diff with `git diff <base>..<head>` (or read changed files directly).

    ## Standard Code Quality Concerns

    Review the diff for:

    **Correctness:**
    - Off-by-one errors, null/undefined handling, error paths
    - Concurrency / race conditions (if applicable)
    - Security: input validation, injection, secrets, authn/authz
    - Logic that "passes the tests" but doesn't actually work

    **Tests:**
    - Do tests exercise behaviour through public interfaces (not implementation details)?
    - Are tests mocking things they shouldn't (databases, the unit under test, etc.)?
    - Are there meaningful assertions, or just "did it run"?
    - Are critical paths and edge cases covered?

    **Readability & maintainability:**
    - Are names accurate (describe what, not how)?
    - Is the code easy to follow without reading it twice?
    - Are comments load-bearing (WHY) rather than restating WHAT?
    - Is there dead code, debug logging, or commented-out blocks?

    **Discipline (YAGNI):**
    - Speculative abstractions, premature generality
    - Features beyond what the issue required
    - "Just in case" error handling for impossible cases

    ## Structural Concerns (additional)

    - Does each new/modified file have one clear responsibility with a well-defined interface?
    - Are units decomposed so they can be understood and tested independently?
    - Did this implementation create new files that are already large, or significantly
      grow existing files? Focus on what THIS CHANGE contributed — don't flag pre-existing size.
    - Are public APIs minimal? Anything exported that doesn't need to be?

    ## Codebase Patterns

    - Does this change follow patterns established in the surrounding code?
    - If it diverges, is the divergence justified or accidental?

    ## Project Coding Standards

    Look for `CODING_STANDARDS.md` at the repo root. If it exists, read it and verify
    the diff complies. Treat the standards as binding for this project; flag violations
    by `file:line` with a quote of the relevant standard.

    If no `CODING_STANDARDS.md` is at the repo root, skip this section.

    ## Fallow Audit

    If `fallow` is available (check with `command -v fallow`), run a fallow audit
    scoped to the implementer's changes:

    ```
    fallow audit --changed-since <BASE_SHA> --format compact
    ```

    Fallow checks for: unused code (files, exports, types, deps), code duplication,
    circular dependencies, complexity hotspots, architecture boundary violations,
    feature flag patterns.

    For each finding, decide whether it's:
    - **Critical** — must fix before merge (e.g. circular dependency the implementer
      introduced, architecture boundary violation, dead code the implementer just shipped)
    - **Important** — should fix (e.g. complexity hotspot in new code, near-duplicate
      logic in the diff)
    - **Minor** / **Ignore** — pre-existing issues that the implementer didn't introduce
      (don't pile on; mention once if relevant, otherwise drop)

    Include surviving findings in your issue list below. If fallow isn't installed or
    errors out, note that and proceed without it (don't block on tooling).

    ## Report Format

    Return:

    **Strengths** — what the implementer got right (be specific, with `file:line`).

    **Issues:**
    - **Critical** — must fix before merge (correctness, security, broken tests)
    - **Important** — should fix before merge (maintainability, missing tests on critical paths)
    - **Minor** — nice-to-have (style, naming, small refactors)

    For each issue: `file:line` + concrete description + suggested fix.

    **Assessment:** ✅ Approved | ❌ Needs fixes (with summary of what blocks approval).
```
