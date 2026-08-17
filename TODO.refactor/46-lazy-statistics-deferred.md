# 46 - LazyRepository computes statistics eagerly

## Status: ✅ EVALUATED (2026-08-17) — DEFERRED with rationale

## Problem

`LazyRepository` defers index construction but computes
`StatisticsCalculator.calculate` eagerly in `init_services`,
negating some of the laziness for repositories that never ask
for statistics.

## Evaluation

The calculator reads the `qualified_names` and `package_paths`
indexes — so in the current wiring it forces those indexes to
build anyway. Making statistics lazy requires either:
1. Memoizing on first `#statistics` call (small, but every
   consumer currently reads `repo.statistics` during export —
   so the deferral saves nothing in the known flows), or
2. Computing statistics from the raw document without indexes
   (duplicates counting logic).

No known flow constructs a LazyRepository and never touches
statistics. The eager compute is not a measured cost.

## Decision

Defer until a flow exists that needs lazy statistics.

## Files

None — no code change.
