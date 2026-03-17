# Personal Config Files

This directory contains my personal configuration ("dotfiles") for common tools.

## Files

| File | Description |
|------|-------------|
| [`.bashrc`](./.bashrc) | Bash shell configuration — aliases, prompt, history, functions |
| [`.zshrc`](./.zshrc) | Zsh shell configuration — same as bashrc but with zsh-specific features |
| [`.gitconfig`](./.gitconfig) | Git global configuration — aliases, diff, merge, color settings |
| [`.vimrc`](./.vimrc) | Vim editor configuration — UI, key mappings, indentation |
| [`.gitignore_global`](./.gitignore_global) | Global gitignore — OS, editor, and language artifacts |

## Installation

### Individual files

```bash
# Bash
cp configs/.bashrc ~/.bashrc && source ~/.bashrc

# Zsh
cp configs/.zshrc ~/.zshrc && source ~/.zshrc

# Git
cp configs/.gitconfig ~/.gitconfig
cp configs/.gitignore_global ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global

# Vim
cp configs/.vimrc ~/.vimrc
mkdir -p ~/.vim/undodir
```

### All at once (symlink approach — recommended)

Using symlinks keeps your configs up-to-date with the repository:

```bash
REPO_DIR="$(pwd)"

ln -sf "${REPO_DIR}/configs/.bashrc"            ~/.bashrc
ln -sf "${REPO_DIR}/configs/.zshrc"             ~/.zshrc
ln -sf "${REPO_DIR}/configs/.gitconfig"         ~/.gitconfig
ln -sf "${REPO_DIR}/configs/.gitignore_global"  ~/.gitignore_global
ln -sf "${REPO_DIR}/configs/.vimrc"             ~/.vimrc

git config --global core.excludesfile ~/.gitignore_global
mkdir -p ~/.vim/undodir
```

## Customization

For machine-specific settings that should **not** be tracked in git, create local override files:

- `~/.bashrc.local` — sourced at the end of `.bashrc`
- `~/.zshrc.local` — sourced at the end of `.zshrc`

These files are gitignored and safe to use for local secrets, environment variables, etc.
