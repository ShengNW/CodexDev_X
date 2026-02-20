#!/usr/bin/env bash
set -euo pipefail

TARGET_REPO="/root/autodl-tmp/X/CodexDev"
EXPECTED_REMOTE="git@github.com:ShengNW/CodexDev_X.git"
DRY_RUN=0
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=1
  shift
fi
COMMIT_MESSAGE="${1:-Update files}"

if [[ ! -d "$TARGET_REPO/.git" ]]; then
  echo "[ERROR] Repository not found: $TARGET_REPO"
  exit 1
fi

cd "$TARGET_REPO"

top_level="$(git rev-parse --show-toplevel)"
if [[ "$top_level" != "$TARGET_REPO" ]]; then
  echo "[ERROR] Skill scope mismatch. Expected: $TARGET_REPO, got: $top_level"
  exit 1
fi

ssh_output="$(ssh -T -o StrictHostKeyChecking=accept-new git@github.com 2>&1 || true)"
if [[ "$ssh_output" != *"successfully authenticated"* ]]; then
  echo "[ERROR] SSH authentication failed."
  echo "$ssh_output"
  exit 1
fi

current_remote="$(git remote get-url origin 2>/dev/null || true)"
if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "dry_run=1"
  echo "repo=$TARGET_REPO"
  echo "remote_current=${current_remote:-<missing>}"
  echo "remote_expected=$EXPECTED_REMOTE"
  echo "branch_current=$(git rev-parse --abbrev-ref HEAD)"
  echo "status:"
  git status --short --branch
  exit 0
fi

if [[ -z "$current_remote" ]]; then
  git remote add origin "$EXPECTED_REMOTE"
elif [[ "$current_remote" != "$EXPECTED_REMOTE" ]]; then
  git remote set-url origin "$EXPECTED_REMOTE"
fi

created_commit=0
if [[ -n "$(git status --porcelain)" ]]; then
  git add -A
  if ! git diff --cached --quiet; then
    git commit -m "$COMMIT_MESSAGE"
    created_commit=1
  fi
fi

branch_name="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$branch_name" != "main" ]]; then
  git branch -M main
  branch_name="main"
fi

if git rev-parse --abbrev-ref --symbolic-full-name "@{u}" >/dev/null 2>&1; then
  git push
else
  git push -u origin "$branch_name"
fi

echo "branch=$branch_name"
echo "head=$(git rev-parse --short HEAD)"
echo "created_commit=$created_commit"
