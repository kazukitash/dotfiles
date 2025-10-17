# Repository Guidelines

## Project Structure & Module Organization
- Root scripts: `install.sh` (entrypoint), `scripts/deploy.sh`, `scripts/list.sh`, `scripts/update.sh`, `scripts/format.sh`, `scripts/setup.sh`.
- Configs live under XDG-style directories (e.g., `.config/zsh`, `.config/git`, `.config/zed`, `.config/brew`).
- Tooling/agents: `.codex/` (CLI settings, prompts) and `.claude/` (agent presets). Secrets in these folders are ignored by `.gitignore`.
- Homebrew bundle: `.Brewfile` (symlinked to `~/.Brewfile` by deploy scripts).

## Build, Test, and Development Commands
- Install (dotfiles only): `./install.sh`
- Install with extras: `./install.sh --build`, `./install.sh --work`, or combined `./install.sh -bw`
- Deploy symlinks: `./scripts/deploy.sh` (uses `scripts/list.sh` to enumerate files)
- Update repo then redeploy: `./scripts/update.sh && ./scripts/deploy.sh`
- Format shell scripts: `./scripts/format.sh` or check mode `./scripts/format.sh --check`

## Coding Style & Naming Conventions
- Shell: bash or zsh with strict mode shebangs (`#!/bin/bash -eu` or zsh equivalent).
- Indentation: 2 spaces, no tabs. Enforced via `shfmt -i 2 -ci -sr -bn` (see `scripts/format.sh`).
- Filenames: lowercase with words separated (e.g., `deploy.sh`, `list.sh`). Keep scripts idempotent and safe to re-run.

## Testing Guidelines
- Lint/format: run `./scripts/format.sh --check` before commits. Optionally run `shellcheck` locally.
- CI: GitHub Actions run `install.sh` on macOS and Linux for push/PR to ensure clean bootstrap across platforms (`.github/workflows/*`).

## Commit & Pull Request Guidelines
- Use Conventional Commits seen in this repo’s history, e.g. `feat(zsh): add project aliases`, `fix: correct brew entry`, `refactor(zed): simplify format config`, `docs(claude): update comments`, `chore: update settings`.
- PRs should include: goal summary, notable changes, OS tested (macOS/Linux), and any screenshots for editor/UI configs. Ensure formatting passes and that `deploy.sh` completes locally.

## Security & Configuration Tips
- Do not commit secrets or tokens. The repo ignores sensitive files under `.codex/` (except `config.toml` and `prompts`) and `.claude/settings.local.json` by default—verify `.gitignore` before pushing.
- Homebrew uses the global bundle (`brew bundle --global`); customize packages via `.Brewfile` and redeploy.

