# dotfiles (chezmoi)

Single-source dotfiles for macOS + Linux, managed with [chezmoi](https://chezmoi.io).
One branch, OS/host differences handled by templates — no more per-OS branches.

## Bootstrap a new machine

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yazankittaneh/dotfiles
```

This installs chezmoi, clones this repo to `~/.local/share/chezmoi`, renders the
templates for the current OS, and writes real config files into `$HOME`.

## Layout

- `dot_*` → `~/.*` (e.g. `dot_zshrc.tmpl` → `~/.zshrc`). `.tmpl` files are rendered
  per-machine (`{{ .chezmoi.os }}`, `lookPath`, etc.).
- `dot_config/dotfiles/load-secrets.sh` — 1Password-backed secret loader (see below).
- `dot_config/dotfiles/local.sh.example` — copy to `~/.config/dotfiles/local.sh` for
  machine-local / work-identity overrides (never tracked).
- `run_once_before_install-packages.sh.tmpl` — installs base packages via the host's
  package manager (brew / apt / pacman / dnf).
- `.chezmoiignore` — auth/secrets/state that must never be synced.

## Three-tier config model

1. **Shared** — tracked files + templates. Portable, `$HOME`-based, OS-guarded.
2. **Machine-local** — `~/.config/dotfiles/local.sh` (gitignored, per-machine).
3. **Secrets** — pulled from 1Password at runtime via `load_secrets`; nothing secret
   on disk.

## Secrets (1Password)

Keys are **not** stored on disk. Store rotated keys in a 1Password item
(`op://Private/cli-keys/<field>`), then in a shell run `load_secrets` to export them.
See `dot_config/dotfiles/load-secrets.sh` for the required fields and setup.

## Common commands

```sh
chezmoi diff          # preview what apply would change
chezmoi apply         # apply changes to $HOME
chezmoi edit ~/.zshrc # edit the source of a managed file
chezmoi cd            # cd into the source dir
chezmoi update        # git pull + apply
```
