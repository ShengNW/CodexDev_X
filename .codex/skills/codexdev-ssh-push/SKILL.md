---
name: codexdev-ssh-push
description: Commit and push local changes for the repository at /root/autodl-tmp/X/CodexDev to git@github.com:ShengNW/CodexDev_X.git over SSH. Use when the user asks to sync, submit, or push updates for this CodexDev repo quickly, and enforce this path-only scope.
---

# CodexDev SSH Push

## Overview

Use this skill to run a repeatable commit-and-push flow for this repository only. Validate path, verify SSH and remote, commit changes, then push `main`.

## Workflow

1. Confirm repository scope.
   - Run `git rev-parse --show-toplevel`.
   - Continue only if output is exactly `/root/autodl-tmp/X/CodexDev`.
   - If the path differs, stop and explain this skill is locked to that repo path.

2. Verify SSH and remote configuration.
   - Run `ssh -T -o StrictHostKeyChecking=accept-new git@github.com` when auth state is unknown.
   - Treat output containing `successfully authenticated` as success even if exit code is `1`.
   - Ensure `origin` is `git@github.com:ShengNW/CodexDev_X.git`; add or reset it if needed.

3. Prepare and commit changes.
   - Run `git status --short --branch`.
   - If working tree has changes: `git add -A` then `git commit -m "<message>"`.
   - Default commit message to `Update files` when user does not provide one.
   - If there is nothing to commit, continue without failing.

4. Push branch.
   - Ensure current branch is `main` (`git branch -M main` if needed).
   - Use `git push`; if upstream is missing, use `git push -u origin main`.
   - Do not use force push unless user explicitly requests it.

5. Return concise result.
   - Report remote branch, latest commit hash, and whether a new commit was created.
   - Mention key changed files when available.

## Script

Use `scripts/sync_and_push.sh` for deterministic execution.

- Default message: `scripts/sync_and_push.sh`
- Custom message: `scripts/sync_and_push.sh "feat: your message"`
- Preflight check: `scripts/sync_and_push.sh --dry-run`
- Script behavior:
  - enforce repo path `/root/autodl-tmp/X/CodexDev`
  - enforce remote `git@github.com:ShengNW/CodexDev_X.git`
  - commit all pending changes and push to `main`
