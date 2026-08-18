#!/bin/sh
set -eu

die() { printf 'worktree-include: %s\n' "$*" >&2; exit 0; }

[ -n "${HERDR_PLUGIN_EVENT_JSON:-}" ] || die "no event payload"

# Hooks receive the event wrapped as {"event":..,"data":{..}}; `.data // .` keeps
# this working if a future version passes the bare event instead.
json() { printf '%s' "$HERDR_PLUGIN_EVENT_JSON" | jq -r "(.data // .) | $1 // empty"; }

dest=$(json '.worktree.path // .workspace.worktree.checkout_path')
src=$(json '.workspace.worktree.repo_root')

[ -n "$dest" ] && [ -d "$dest" ] || die "no worktree path in event"

# repo_root can point at the new checkout for linked worktrees; --git-common-dir
# always resolves to the main .git, whose parent is the main working tree.
if [ -z "$src" ] || [ "$src" = "$dest" ] || [ ! -d "$src" ]; then
  src=$(dirname "$(git -C "$dest" rev-parse --path-format=absolute --git-common-dir)")
fi

include="$src/.worktreeinclude"
[ -f "$include" ] || exit 0

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Match Claude Code's rule: copy a path only if .worktreeinclude selects it AND
# git ignores it. ls-files applies the include patterns (--directory collapses a
# wholly-matched dir to one entry); check-ignore then confirms each candidate is
# gitignored, which also holds for paths under an ignored parent.
git -C "$src" ls-files --others --ignored --exclude-from="$include" --directory \
  | sed 's:/$::' > "$tmp/candidates"

[ -s "$tmp/candidates" ] || exit 0

git -C "$src" check-ignore --stdin < "$tmp/candidates" > "$tmp/selected" 2>/dev/null || true

copied=0
skipped=0
while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  from="$src/$rel"
  to="$dest/$rel"
  [ -e "$from" ] || continue
  if [ -e "$to" ]; then
    skipped=$((skipped + 1))
    continue
  fi
  mkdir -p "$(dirname "$to")"
  cp -Rc "$from" "$to" 2>/dev/null || cp -R "$from" "$to"
  copied=$((copied + 1))
  printf 'worktree-include: copied %s\n' "$rel"
done < "$tmp/selected"

printf 'worktree-include: %s copied, %s already present (%s -> %s)\n' \
  "$copied" "$skipped" "$src" "$dest"
