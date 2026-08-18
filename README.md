# dotfiles

Personal configuration, symlinked into `$HOME` with [GNU Stow](https://www.gnu.org/software/stow/).

## Install

```sh
./install.sh
```

Idempotent — run it again after pulling, adding a new config, or on a fresh machine.

It does three things:

1. Runs `stow` to symlink everything into `$HOME`.
2. Links the lazygit config by hand, because stow cannot reach it (see below).
3. Creates the Terraform plugin cache directory (see below).

## How stow is used here

Most dotfiles repos keep one directory per package (`nvim/`, `zsh/`, …) and stow them
individually. This repo is **a single package**: the repo contents map directly onto
`$HOME`, so `.zshrc` becomes `~/.zshrc` and `.config/nvim` becomes `~/.config/nvim`.

That means the package name is `.` and the stow directory is the repo itself:

```sh
cd ~/dotfiles
stow --dir=. --target="$HOME" --restow .
```

> **Gotcha:** the intuitive `stow --dir="$HOME" --target="$HOME" dotfiles` silently does
> **nothing** on stow 2.4+. When the stow directory and the target are the same path,
> stow bails out with `WARNING: skipping target which was current stow directory` and
> plans no links at all. Always point `--dir` at the repo, not at `$HOME`.

`stow` must be run from the repo root, because it only reads `.stowrc` from the current
directory. `install.sh` handles that for you.

### Ignored paths

`.stowrc` lists what stow must *not* link into `$HOME`:

| Pattern | Why |
| --- | --- |
| `.stowrc` | stow's own config |
| `\.DS_Store` | macOS noise |
| `.agents` | local scratch, not a real dotfile |
| `README\.md`, `install\.sh` | repo files; they would land in `~` otherwise |
| `lazygit` | linked manually instead — see below |

Patterns are Perl regexes anchored to the **basename**, so `.` must be escaped to match
a literal dot.

## The lazygit exception

lazygit does not use `~/.config` on macOS. With no `XDG_CONFIG_HOME` set, it reads from:

```
~/Library/Application Support/lazygit/config.yml
```

Stow only links into `$HOME` following the repo's directory structure, so it cannot place
a file there. Instead the config lives at `.config/lazygit/config.yml` (kept out of stow's
way via the `lazygit` ignore) and `install.sh` symlinks it into place:

```sh
ln -sfn ~/dotfiles/.config/lazygit/config.yml "$(lazygit -cd)/config.yml"
```

`lazygit -cd` prints the config directory, so this stays correct on Linux too. If a real
config file is already there, `install.sh` moves it to `config.yml.bak` first.

### Sharing config with Neovim

Neovim opens lazygit through `Snacks.lazygit()`. Snacks generates a theme file from the
active colorscheme and sets:

```
LG_CONFIG_FILE="<lazygit -cd>/config.yml,<nvim cache>/lazygit-theme.yml"
```

lazygit merges those left to right, so the config above is the shared base for both the
terminal and the Neovim float. Snacks overrides only two things:

- `gui.theme` — regenerated live from the Neovim colorscheme
- `os.editPreset` — swapped to `nvim-remote` so `e` opens the file in the *running*
  Neovim instead of nesting a new one

Everything else — nerd font icons, keybindings, git settings — is inherited. Change it
once in `.config/lazygit/config.yml` and both pick it up.

Two consequences worth remembering:

- Keep `os.editPreset: nvim` in the base config. `nvim-remote` needs `$NVIM` set and only
  works from inside a Neovim terminal.
- The base theme is hardcoded to Catppuccin Macchiato to match the Neovim colorscheme. If
  you switch colorschemes, the Neovim float follows automatically but the terminal does
  not — update `gui.theme` by hand.

## The Terraform plugin cache

`.terraformrc` points Terraform at a shared provider cache:

```hcl
plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
```

Without it, every `terraform init` downloads its own copy of each provider into that
stack's `.terraform/providers/`. A repo with several stacks ends up storing the same
few-hundred-megabyte AWS provider once per stack. With the cache, providers are
downloaded once per machine and hard-linked (or copied, on filesystems that cannot link)
into each stack, so `init` is near-instant and disk usage stops scaling with stack count.

The cache is per-machine and shared across every project, not just one repo.

> **Gotcha:** Terraform *silently ignores* `plugin_cache_dir` if the directory does not
> exist — it only logs a warning during `init`. That is why `install.sh` runs
> `mkdir -p ~/.terraform.d/plugin-cache`; the config alone does nothing on a fresh
> machine.

To reclaim space already taken by per-stack copies, delete them and re-init. This is
safe: `.terraform/` is disposable local scratch — state lives in the remote backend and
`.terraform.lock.hcl` is committed.

```sh
find . -type d -name .terraform -prune -exec rm -rf {} +
```

Terraform 1.7+ records provider checksums for cached plugins itself, so the cache no
longer risks writing incomplete `.terraform.lock.hcl` entries.

## Adding a new config

Put it at the path it should occupy relative to `$HOME` (e.g. `.config/foo/config.toml`),
then run `./install.sh`. If the tool stores its config somewhere stow cannot reach, add an
ignore to `.stowrc` and a symlink step to `install.sh`, as lazygit does.
