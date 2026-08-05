# 32 - resolve_type_name O(N) per attribute (performance)

## Status: ✅ EVALUATED (2026-07-19) — DEFERRED with rationale

## Problem

`lib/lutaml/uml_repository/validators/repository_validator.rb:294-308`
iterates all `@indexes[:qualified_names]` keys calling
`end_with?` to resolve a type reference. Called once per
attribute. Worst case: O(classes × attributes × qnames).

## Evaluation

Realistic models:
- Plateau fixture: 581 classes, ~3 attributes each on average,
  ~600 qualified names → 581 × 3 × 600 = ~1M comparisons.
- Each comparison is `String#end_with?` (fast C-implemented).

Total wall time for validation on the plateau fixture: under
200ms (measured informally). The O(N²) bound is theoretical —
in practice the indexes are small enough that the constant
factor dominates.

A reverse simple-name index (Map<simple_name, Set<qname>>)
would convert to O(1) per attribute but add complexity to
IndexBuilder and require invalidation when the index changes.

## Decision

Defer until validation becomes a measured bottleneck. Current
behavior is fast enough for the largest realistic fixture.

## Files

None — no code change.

## Verification

Plateau fixture validation: ~200ms. Acceptable.
