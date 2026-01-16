# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains two types of utility scripts:

1. **Nautilus Python Extensions** - Context menu integrations for GNOME's Nautilus file manager
2. **Bash Scripts** - Bulk git operations across multiple repositories

## Nautilus Extensions

Python extensions that use `gi.repository` (PyGObject) to integrate with Nautilus via `Nautilus.MenuProvider`.

### Simple Extensions (in this repo)

- `open_with_meld.py` - Compare 1-2 files/folders in Meld diff tool
- `open_with_rider.py` - Open directories in JetBrains Rider (directories only)
- `open_with_vscode.py` - Open directories in VS Code (directories only)

### Git Extensions (installed at `~/.local/share/nautilus-python/extensions/`)

- `git_pull.py` - Git Pull submenu:
  - "This repo" - Pull the selected repository
  - "All repos inside" - Pull all repositories inside selected folder

- `git_switch_branch.py` - Git Switch Branch submenu:
  - "main/develop (this repo)" - Switch selected repo to branch
  - "main/develop (all repos inside)" - Switch all repos inside to branch
  - "Other branch..." - Zenity dialog to enter custom branch name

### Installation

Copy `.py` files to `~/.local/share/nautilus-python/extensions/` and restart Nautilus (`nautilus -q`).

### Extension Pattern

All extensions follow the same structure:
- Inherit from `GObject.GObject` and `Nautilus.MenuProvider`
- Implement `get_file_items(self, window, files)` to provide menu items
- Use `urllib.parse.unquote(f.get_uri()[7:])` to convert file URIs to paths
- Launch applications via `subprocess.Popen()`
- For submenus: create `Nautilus.Menu()` and attach with `set_submenu()`
- For terminal output: use `gnome-terminal -- bash -c "command"`

## Bash Scripts

### Legacy Scripts (in this repo)

Old scripts that run from current directory (kept for reference):

- `all-repos-pull.sh` - Pull latest changes in all repos
- `all-repos-switch-develop.sh` - Switch all repos to `develop` branch (destructive)
- `all-repos-switch-main.sh` - Switch all repos to `main` branch (destructive)

**Warning**: Legacy switch scripts perform destructive operations (`git clean -fd && git reset --hard`).

### New Scripts (at `~/.local/share/nautilus-python/extensions/scripts/`)

Improved scripts called by Nautilus extensions:

- `git-pull.sh <path> [--recursive]` - Pull with color-coded output and summary
- `git-switch.sh <path> <branch> [--recursive]` - Safe switch + pull:
  - Checks for uncommitted changes before switching
  - Skips dirty repos instead of destroying changes
  - Fetches before switching to ensure branch exists
  - Pulls after successful switch
  - Color-coded summary (green=success, yellow=skipped, red=failed)
