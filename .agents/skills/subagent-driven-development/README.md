# Subagent-Driven Development — How to Run It

Human-facing workflow doc. See `SKILL.md` for the full controller spec.

## When to reach for it

You have a batch of independent issues that are AFK-ready: vertical-slice scope, clear acceptance criteria, no open architectural questions. You want to execute the batch without bloating the main session's context.

The natural lead-in is your existing pipeline:

```
grill-with-docs → to-prd → to-issues → (labeled backlog) → SDD
```

## Recipe

### 1. Fresh session

`/clear` (or open a new Claude Code session). SDD only earns its keep when the controller's context is small — don't run it on top of an accumulated conversation.

### 2. Invoke

Just say what you want in plain language; the skill triggers from its description.

```
Use subagent-driven-development on issues #42, #43, #44.
```

```
Run SDD on every `ready-for-agent` issue.
```

```
Execute issue #42 with subagent-driven-development.
```

### 3. What the controller does

1. Confirms scope (which issues, which branch, TDD on/off).
2. `EnterWorktree` → isolated branch.
3. `gh issue view` each target → captures body + acceptance criteria + comments.
4. `TaskCreate` per issue, modeling `Blocked by` relationships.
5. Per issue, in a loop:
   - Dispatches **implementer** subagent (fresh context, full issue text inline).
   - Dispatches **spec compliance reviewer** → ✅ or ❌ (loop until ✅).
   - Dispatches **code quality reviewer**, which self-discovers and applies:
     - `CODING_STANDARDS.md` at the repo root (if present)
     - `fallow audit --changed-since <BASE_SHA>` (if `fallow` is installed)
     - Returns Approved or Issues (loop until approved).
   - `gh issue close`, mark task complete.
6. Hands back to you when the batch is done.

### 4. Your role during the run

Mostly watch. Two things pull you in:

- **Subagent asks a question** — answer clearly. Don't rush.
- **BLOCKED that the controller can't unblock** — bad acceptance criteria, missing decision, scope wrong. You decide: relabel `ready-for-human`, split the issue, or rewrite it.

### 5. After the batch

Optional final pass before opening the PR:

```
/review
gh pr create ...
```

Finishing is intentionally not part of SDD — your call how to integrate.

## First run

Pick **one** simple issue and run SDD on it alone. A single-issue run is the cheapest way to feel the question/answer pattern, review loops, and commit cadence before turning it loose on a whole batch.

```
/clear
Run SDD on issue #N.
```

## Why this preserves context

The controller never reads files for the implementer — it pastes the full issue text into the subagent's prompt. The implementer reads files, writes code, runs tests, and reports back a summary; the noise (file reads, tool output, intermediate reasoning) stays inside its isolated context.

Same for the two reviewers — they read the diff in their own context and return only a verdict + issue list.

Result: the main session stays small, and you can run a long batch without context rot.

## Anti-patterns

- Running SDD on issues that aren't actually AFK-ready (open architectural questions, vague acceptance criteria). Fix the issue with `grill-with-docs` / `to-issues` first.
- Running it on top of a long-lived conversation. `/clear` first.
- Skipping the worktree because the change "feels small." Conflicts with the user's working copy will cost more than the worktree did.
- Approving spec ❌ as "close enough." Loop the implementer until ✅.
- Touching the working copy manually while the controller is running. Let the subagents own the branch.
