# Nautilus Extensions

Custom context menu extensions for GNOME's Nautilus file manager. Right-click folders to access git operations and open files/folders in external applications.

## Features

### Git Operations

- **Git Pull** - Pull latest changes from remote
  - Pull a single repository
  - Pull all repositories inside a folder (recursive)

- **Git Switch Branch** - Switch branches safely
  - Predefined branches: `main`, `develop`
  - Custom branch via dialog
  - Works on single repo or all repos inside a folder
  - **Safe**: skips repos with uncommitted changes (no data loss)
  - Automatically pulls after switching

### Open With

- **Open in Meld** - Compare 1-2 files/folders using Meld diff tool
- **Open in VS Code** - Open folders in Visual Studio Code
- **Open in Rider** - Open folders in JetBrains Rider

## Installation

### Prerequisites

- GNOME Nautilus file manager
- Python 3 with PyGObject (`python3-nautilus` package)
- `gnome-terminal` (for git operations output)
- `zenity` (for custom branch dialog)

On Fedora/RHEL:
```bash
sudo dnf install nautilus-python gnome-terminal zenity
```

On Ubuntu/Debian:
```bash
sudo apt install python3-nautilus gnome-terminal zenity
```

### Install Extensions

1. Create the extensions directory if it doesn't exist:
```bash
mkdir -p ~/.local/share/nautilus-python/extensions/scripts
```

2. Copy the Python extensions:
```bash
cp open_with_meld.py ~/.local/share/nautilus-python/extensions/
cp open_with_vscode.py ~/.local/share/nautilus-python/extensions/
cp open_with_rider.py ~/.local/share/nautilus-python/extensions/
cp git_pull.py ~/.local/share/nautilus-python/extensions/
cp git_switch_branch.py ~/.local/share/nautilus-python/extensions/
```

3. Copy the bash scripts:
```bash
cp scripts/git-pull.sh ~/.local/share/nautilus-python/extensions/scripts/
cp scripts/git-switch.sh ~/.local/share/nautilus-python/extensions/scripts/
chmod +x ~/.local/share/nautilus-python/extensions/scripts/*.sh
```

4. Restart Nautilus:
```bash
nautilus -q
```

## Usage

### Git Pull

1. Right-click on a folder in Nautilus
2. Select **Git Pull**
3. Choose:
   - **This repo** - Pull only the selected folder (must be a git repo)
   - **All repos inside** - Find and pull all git repositories inside the folder

A terminal window will open showing progress and a summary.

### Git Switch Branch

1. Right-click on a folder in Nautilus
2. Select **Git Switch Branch**
3. Choose:
   - **main (this repo)** / **develop (this repo)** - Switch selected repo
   - **main (all repos inside)** / **develop (all repos inside)** - Switch all repos
   - **Other branch... (this repo)** / **Other branch... (all repos inside)** - Enter custom branch name

**Safety features:**
- Checks for uncommitted changes before switching
- Skips dirty repos and reports them in the summary
- Fetches from remote before switching to ensure branch exists
- Pulls after successful switch

### Open With Extensions

- **Meld**: Select 1 or 2 files/folders, right-click, select "Open in Meld..." or "Compare in Meld"
- **VS Code**: Right-click a folder, select "Open in VS Code..."
- **Rider**: Right-click a folder, select "Open in Rider..."

## Repository Structure

```
nautilus-scripts/
├── git_pull.py              # Git Pull extension
├── git_switch_branch.py     # Git Switch Branch extension
├── open_with_meld.py        # Meld extension
├── open_with_vscode.py      # VS Code extension
├── open_with_rider.py       # Rider extension
├── scripts/
│   ├── git-pull.sh          # Pull script with progress output
│   └── git-switch.sh        # Safe switch + pull script
└── scripts-legacy/
    ├── all-repos-pull.sh    # Legacy pull script
    ├── all-repos-switch-develop.sh
    └── all-repos-switch-main.sh
```

After installation, the extensions directory will look like:
```
~/.local/share/nautilus-python/extensions/
├── git_pull.py
├── git_switch_branch.py
├── open_with_meld.py
├── open_with_vscode.py
├── open_with_rider.py
└── scripts/
    ├── git-pull.sh
    └── git-switch.sh
```

## Bash Scripts (Standalone Usage)

The bash scripts can also be used directly from the command line:

### git-pull.sh

```bash
# Pull a single repo
./scripts/git-pull.sh /path/to/repo

# Pull all repos inside a folder
./scripts/git-pull.sh /path/to/folder --recursive
```

### git-switch.sh

```bash
# Switch a single repo to 'develop'
./scripts/git-switch.sh /path/to/repo develop

# Switch all repos inside a folder to 'main'
./scripts/git-switch.sh /path/to/folder main --recursive
```

## Legacy Scripts

The following scripts in `scripts-legacy/` are kept for reference but are superseded by the new extensions:

- `all-repos-pull.sh` - Original pull script (runs from current directory)
- `all-repos-switch-develop.sh` - Destructive switch to develop
- `all-repos-switch-main.sh` - Destructive switch to main

**Warning**: Legacy switch scripts use `git clean -fd && git reset --hard` which destroys uncommitted changes.

## Troubleshooting

### Extensions not appearing

1. Verify `nautilus-python` is installed
2. Check files are in the correct location: `~/.local/share/nautilus-python/extensions/`
3. Restart Nautilus: `nautilus -q`
4. Check for errors: `nautilus --debug`

### "zenity not installed" error

Install zenity:
```bash
# Fedora/RHEL
sudo dnf install zenity

# Ubuntu/Debian
sudo apt install zenity
```

### Permission denied on scripts

Make scripts executable:
```bash
chmod +x ~/.local/share/nautilus-python/extensions/scripts/*.sh
```
