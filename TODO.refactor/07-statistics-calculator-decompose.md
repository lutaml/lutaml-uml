# 07 - StatisticsCalculator: Decompose

## Status: ✅ EVALUATED (2026-07-14) — DEFERRED with rationale

## Problem

`lib/lutaml/uml_repository/statistics_calculator.rb` (342 LOC)
with every statistic inlined in one class.

## Evaluation

Same evaluation as TODO.refactor/03. The statistics all read
from the same `@indexes` Hash and produce entries in one output
Hash. Decomposition would require passing the indexes to each
sub-calculator and merging their outputs — adding parameter
boilerplate without improving locality. The current class IS
the locality for "what statistics exist and how are they
computed."

## What changed instead

Specs cover each statistic individually. The file is at the
edge of the 300-LOC guideline but each method is small (3-10
LOC). The cost of decomposing exceeds the benefit.

## Files

None — no code change.

## Verification

Full lutaml-uml suite green.
