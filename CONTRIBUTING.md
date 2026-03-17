# Contributing Guidelines

Thank you for your interest in contributing to this repository! 🎉

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Features](#suggesting-features)
- [Submitting Pull Requests](#submitting-pull-requests)
- [Coding Standards](#coding-standards)
- [Commit Message Convention](#commit-message-convention)

## Code of Conduct

Please read and follow our [Code of Conduct](./CODE_OF_CONDUCT.md) to keep our community welcoming and respectful.

## How to Contribute

1. **Fork** the repository
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/<your-username>/.github.git
   cd .github
   ```
3. **Create a new branch** from `main`:
   ```bash
   git checkout -b feat/your-feature-name
   ```
4. **Make your changes**, following the [Coding Standards](#coding-standards)
5. **Test** your changes thoroughly
6. **Commit** your changes using the [Commit Message Convention](#commit-message-convention)
7. **Push** to your fork and open a **Pull Request**

## Reporting Bugs

Before reporting a bug, please:
- Search [existing issues](../../issues) to avoid duplicates
- Collect relevant information (OS, versions, error messages, steps to reproduce)

Use the [Bug Report template](../../issues/new?template=bug_report.yml) when filing a new bug.

## Suggesting Features

Have an idea? We'd love to hear it!

- Search [existing issues](../../issues) to avoid duplicates
- Use the [Feature Request template](../../issues/new?template=feature_request.yml)
- Explain the problem your feature would solve

## Submitting Pull Requests

- Reference any related issues in your PR description (e.g., `Closes #123`)
- Keep PRs focused — one feature or fix per PR
- Fill out the [Pull Request template](./PULL_REQUEST_TEMPLATE.md) completely
- Ensure all checks pass before requesting review
- Be responsive to feedback

## Coding Standards

### Bash Scripts
- Use `#!/usr/bin/env bash` as the shebang line
- Enable strict mode: `set -euo pipefail`
- Use `shellcheck` to lint scripts
- Add a file header comment with description, usage, and author
- Use `snake_case` for variable and function names

### Python Scripts
- Follow [PEP 8](https://peps.python.org/pep-0008/) style guide
- Use type hints where applicable
- Write docstrings for all public functions and classes
- Use `black` for formatting, `flake8` or `ruff` for linting
- Target Python 3.8+

### Config Files
- Include inline comments explaining non-obvious settings
- Group related settings together
- Prefer portable/cross-platform solutions where possible

## Commit Message Convention

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary>

[optional body]

[optional footer(s)]
```

**Types:**
| Type | Description |
|------|-------------|
| `feat` | A new feature |
| `fix` | A bug fix |
| `docs` | Documentation only changes |
| `style` | Formatting, no logic change |
| `refactor` | Code refactoring |
| `chore` | Build process, dependency updates |
| `test` | Adding or fixing tests |

**Examples:**
```
feat(scripts): add system update bash script
fix(configs): correct zshrc PATH for Homebrew on Apple Silicon
docs(readme): update profile info
chore: add .gitignore for common artifacts
```
