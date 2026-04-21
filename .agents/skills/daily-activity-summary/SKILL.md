---
name: daily-activity-summary
description: Use when the user asks for a summary of their recent work, daily activity log, what they did last week, or a standup/status update across repositories
---

# Daily Activity Summary

Generate a day-by-day git activity summary across all working directories, including worktrees and local-only branches.

## Arguments

`/daily-activity-summary [date-range]`

- Date range format: `DD/MM` for single start date (until today), or `DD/MM-DD/MM` for explicit range
- Default: last 7 days

## Process

### 1. Identify repos and worktrees

For each working directory in the session, discover all git trees:

```bash
git -C <repo> worktree list --porcelain
```

Collect all worktree paths. Each is a separate log source.

### 2. Collect commits

For each git tree, run:

```bash
git -C <path> log --all --author="<user>" --since="<start>" --until="<end+1>" --format="%ad|%H|%s" --date=short
```

- `--all` ensures untracked/local branches are included
- Deduplicate commits by hash across worktrees (same repo may share objects)

### 3. Resolve PR/issue numbers

For each unique commit hash, attempt to find an associated PR:

```bash
gh pr list --repo <owner/repo> --search "<hash>" --state all --json number --jq '.[0].number // empty'
```

If no PR is found, record the branch name(s) the commit belongs to:

```bash
git -C <path> branch --all --contains <hash> --format="%(refname:short)"
```

Pick the most meaningful branch name (prefer non-main, non-HEAD, shortest local branch).

### 4. Format output

Group by date, list all days in range (including empty ones):

```
**DD/MM** — #<PR> - <short description>; #<PR> - <short description>
```

For commits without a PR:

```
**DD/MM** — [branch-name] - <short description>
```

For days with no activity:

```
**DD/MM** — (no commits)
```

### Notes

- Repo name: when multiple repos are involved, prefix entries with the repo name if ambiguous
- Short descriptions: use the commit subject line, trimmed if too long
- Dedup: if multiple commits belong to the same PR, list the PR once with a combined description
- Order: days chronologically, entries within a day by commit time
