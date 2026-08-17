# 42 - LazyRepository spec entirely skipped

## Status: ✅ DONE (2026-08-17)

## Problem

`spec/lutaml/uml_repository/lazy_repository_spec.rb` was wholly
`:skip`ped ("requires refactoring to use programmatic documents
or .lur fixtures"). The skip predates the programmatic-fixture
helpers added during TODO.refactor/17. Net effect: zero
running CI coverage for lazy index building — the
`INDEX_BUILDERS` registry, the prerequisite graph, and
`ensure_index` were all untested in practice.

## Resolution

Un-skipped the spec by swapping its fixture dependency to the
programmatic `create_inheritance_test_document` helper (and
`create_simple_test_document` where a flat doc suffices). All
examples now run: index materialization, prerequisite ordering
(qualified_names before inheritance_graph; package_paths before
diagram_index), pending-set bookkeeping, and the not-found
error path.

## Verification

All previously-skipped examples now execute and pass.
