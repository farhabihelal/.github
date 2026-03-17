# Scripts

A collection of reusable scripts for automation and development tasks.

## Directory Structure

```
scripts/
├── bash/
│   ├── setup-dev-env.sh     # Bootstrap a dev environment on Ubuntu/Debian
│   └── system-update.sh     # Update & upgrade system packages
└── python/
    ├── file_organizer.py    # Organize files by type into sub-folders
    └── rename_batch.py      # Batch rename files using regex
```

## Bash Scripts

### `setup-dev-env.sh`

Bootstraps a full development environment on a fresh Debian/Ubuntu system.

**Installs:** build tools, Python 3, Node.js, Docker, and configures git defaults.

```bash
# Preview changes first
sudo bash scripts/bash/setup-dev-env.sh --dry-run

# Run for real
sudo bash scripts/bash/setup-dev-env.sh
```

### `system-update.sh`

Updates and upgrades all installed packages.

```bash
# Update only
sudo bash scripts/bash/system-update.sh

# Update, clean orphans, and reboot if kernel updated
sudo bash scripts/bash/system-update.sh --clean --reboot
```

## Python Scripts

### `file_organizer.py`

Organizes files in a directory into categorized sub-folders (Images, Documents, Videos, Code, Archives, Others).

```bash
# Preview
python3 scripts/python/file_organizer.py ~/Downloads --dry-run

# Organize
python3 scripts/python/file_organizer.py ~/Downloads
```

### `rename_batch.py`

Batch renames files using regex pattern matching.

```bash
# Replace spaces with underscores (preview)
python3 scripts/python/rename_batch.py ~/Photos " " "_" --dry-run

# Apply recursively
python3 scripts/python/rename_batch.py ./src " " "_" --recursive
```
