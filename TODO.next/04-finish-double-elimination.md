# 04 - Finish Replacing Double-Based Specs

## Status: LOW PRIORITY — residue only

## Problem

The bulk of the double-elimination work is done (see
`TODO.refactor/11-rewrite-double-based-specs.md` history). What remains:

- `spec/lutaml/uml_repository/presenters/diagram_presenter_spec.rb` lines 7-27:
  top-level repository/diagram doubles shared by many tests. Complex to
  replace without rewriting the SVG-rendering assertions.
- 18 total `double()` calls remain in lutaml-uml specs.

These don't cause failures and aren't blocking.

## Source

Migrated from `TODO.refactor/11-rewrite-double-based-specs.md`.

## Fix

For each remaining double:
1. If the doubled interface is a real UML model — instantiate the real model
   with the needed attributes.
2. If the doubled interface is a struct/DTO — replace with
   `Struct.new(:attr1, :attr2).new(val1, val2)`.
3. Test behavior, not interactions.

## Verification

```bash
grep -rn 'double(' spec/ | wc -l  # target: 0
```
