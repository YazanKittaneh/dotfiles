# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository for macOS/Linux shell configurations. It contains personal development environment settings and configurations for both bash and zsh shells.

## Key Configuration Structure

The repository follows a modular approach where main configuration files source other specialized configs:

- `.bash_profile` sources `.profile` and `.bashrc`
- `.bashrc` sources `.bash_aliases`, `.bash_prompt`, and other tool configs
- `.zprofile` sources `.profile` and `.zshrc`
- `.zshrc` contains the same aliases as `.bash_aliases` but adapted for zsh

## Shell Aliases and Environment

Both bash and zsh configurations share common aliases including:
- Directory navigation shortcuts (`c1`-`c5` for going up directories)
- Development tool shortcuts (`c` for VSCodium, `cu` for Cursor, `o` for open current directory)
- API key management aliases for various services
- Kubernetes shortcuts (`ks`, `kc`, `kns`)
- SSH shortcut (`mini` for remote server)

## Development Tools Integration

The configurations include setup for:
- Homebrew (both `/opt/homebrew` and `/home/linuxbrew` paths)
- Google Cloud SDK
- Go development (GOROOT, GOPATH)
- Python (aliased to `/opt/homebrew/bin/python3`)
- Node.js (NVM)
- Java (Jabba)
- Bun runtime
- LM Studio CLI
- Cargo/Rust

## Git and GitHub Workflow

### GitHub CLI (gh) - PRIMARY TOOL

**IMPORTANT**: Always use GitHub CLI (`gh`) for ALL GitHub-related operations. This includes:

- **Pull Requests**: Use `gh pr` commands for creating, listing, viewing, checking out, reviewing, and merging PRs
- **Issues**: Use `gh issue` commands for creating, listing, viewing, and managing issues
- **Repository operations**: Use `gh repo` commands for cloning, forking, viewing repo info
- **Status checks**: Use `gh pr checks`, `gh pr status` for CI/CD and PR status
- **Reviews**: Use `gh pr review` for adding reviews and comments
- **Releases**: Use `gh release` commands for managing releases
- **Workflows**: Use `gh workflow` and `gh run` for GitHub Actions

Example common operations:
- `gh pr create` - Create a new pull request
- `gh pr list` - List pull requests
- `gh pr status` - Show status of relevant PRs
- `gh pr view <number>` - View PR details
- `gh pr checkout <number>` - Check out a PR locally
- `gh pr review <number>` - Review a PR
- `gh issue create` - Create a new issue
- `gh repo view` - View repository details

### Git Configuration

`.gitconfig` includes custom aliases for local git operations:
- `co` - checkout
- `s` - status
- `l` - colored graph log
- `u` - fetch, pull with rebase, and purge merged branches
- `squash` - squash commits
- `purge` - remove merged branches

**Note**: Use these git aliases for local repository operations, but always prefer `gh` CLI for any GitHub-specific operations.

## Scripts Directory

Contains utility scripts:
- `setup-dotfiles.bash` - Installation script
- `git-truncate.bash` - Git history management
- `switch-racket.bash` - Racket version switching
- Chrome and update utilities

## Important Notes

- The repository is set up for macOS (darwin) with Linux compatibility checks
- Environment variables are loaded from `$HOME/.env` if present
- Shell integrations exist for Ghostty terminal and iTerm2
- File paths in configurations assume specific tool installations (check before running commands)