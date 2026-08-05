# 29 - Add PR CI test workflow

## Status: ✅ DONE (2026-07-19)

## Problem

The repo had only `.github/workflows/release.yml` — no test
workflow on PRs. PRs were CI-blind except for CodeQL (which
does not run specs). Regressions slipped to main.

CLAUDE.md notes the suite crashes if run all at once; CI had to
account for that.

## Resolution

Added `.github/workflows/ci.yml` running rspec on every PR and
push, split into two parallel jobs (per CLAUDE.md memory
constraint):
- `spec-uml` — `bundle exec rspec spec/lutaml/uml/`
- `spec-uml-repository` — `bundle exec rspec spec/lutaml/uml_repository/`

Tests on Ruby 3.3, 3.4 on ubuntu-latest. (Windows excluded —
known pre-existing failures per ea gem PR #16 history.)

## Verification

CI workflow syntax validated locally via `actionlint`.
