# 35 - Cross-repo version pin audit

## Status: ✅ EVALUATED (2026-07-19) — DEFERRED with rationale

## Problem

The LutaML ecosystem has four tightly-coupled gems
(lutaml-uml, ea, xmi, lutaml-model) whose version constraints
drift silently. A bump in one repo can break another without a
clear signal until runtime.

## Evaluation

A cross-repo pin audit script would help, but it requires:
1. A canonical source for "current expected versions" — likely
   a top-level versions file in this repo.
2. CI in each repo that verifies its gemspec constraints match
   the canonical file.
3. A maintainer process for bumping the canonical file and
   propagating.

This is a meaningful project-management lift, not a refactor.

## Decision

Defer. Track manually via the sibling-path Gemfile pattern
already in place; bump pins explicitly per release cycle.

## Files

None — no code change.
