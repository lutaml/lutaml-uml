# 03 - RepositoryValidator Decomposition

## Status: ✅ EVALUATED (2026-07-14) — DEFERRED with rationale

## Problem

`lib/lutaml/uml_repository/validators/repository_validator.rb`
(402 LOC) has 5 distinct validation checks inlined as private
methods plus a small `ValidationResult` value object.

## Evaluation

The 5 checks (`check_type_references`,
`check_generalization_references`, `check_circular_inheritance`,
`check_association_references`, `check_multiplicities`) all
share mutable state: `@errors`, `@warnings`,
`@external_references`, `@validation_details`. They also share
private helpers (`resolve_type_name`, `primitive_type?`,
`extract_min_value`, `find_cycle`, etc.) that the checks call
freely.

Extracting each check to its own class would require either:
1. **Passing shared state through every check call** — adds
   parameter boilerplate, makes checks harder to read.
2. **A shared context object** — adds an indirection layer that
   each check has to learn.
3. **A module mixin** — keeps the methods available, but then
   the "split" is illusory; the file is still 400 LOC.

The deletion test: deleting the validator and scattering its
checks across 5 files would not improve locality — the checks
share so much state that they'd reach back into a common module
anyway. The current monolithic shape IS the locality.

## What changed instead

The validator's specs already cover each check individually
(`spec/lutaml/uml_repository/validators/repository_validator_spec.rb`).
The file is at the edge of the 300-LOC guideline (402) but the
complexity per line is low — it's mostly direct checks, not
nested branches. The cost of decomposing exceeds the benefit.

## Files

None — no code change.

## Verification

Full lutaml-uml suite green (777 examples, 0 failures).
