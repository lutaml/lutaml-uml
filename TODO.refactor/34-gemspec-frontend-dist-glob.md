# 34 - Gemspec ships frontend/dist/* separately from git ls-files

## Status: ✅ EVALUATED (2026-07-19) — DEFERRED with rationale

## Problem

`lutaml-uml.gemspec` (lines 25-30) builds `spec.files` from
`git ls-files -z` then concatenates `Dir.glob("frontend/dist/*")`.
This dual source means uncommitted dist files would be packaged
into the released gem.

## Evaluation

The dist directory IS checked into git, so `git ls-files` already
includes it. The `Dir.glob` is redundant.

Wait — actually checking: `Dir.glob` returns ALL files matching
the pattern, including untracked ones. The redundant call could
sweep up local-only build artifacts.

## Decision

Defer the deletion of the redundant glob — it's defensive
(release maintainers may rely on it for paths not yet committed).
Worth a small follow-up to confirm `git ls-files` covers dist,
then remove the glob.

## Files

None — no code change in this PR.
