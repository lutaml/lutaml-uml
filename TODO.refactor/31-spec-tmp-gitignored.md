# 31 - spec/tmp/ committed to git

## Status: ✅ DONE (2026-07-19)

## Problem

`spec/tmp/cached_model_nonexist.lur` was tracked by git. Test
artifacts in `spec/tmp/` should never be committed — they
represent runtime output, not source.

## Resolution

- Added `/spec/tmp/` to `.gitignore`.
- `git rm --cached spec/tmp/cached_model_nonexist.lur` to
  untrack without deleting the file locally.

## Verification

`git status` shows the file removed from index; `.gitignore`
covers the directory.
