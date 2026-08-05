# 30 - Programmatic LUR round-trip test

## Status: ✅ DONE (2026-07-19)

## Problem

The existing LUR round-trip spec
(`spec/lutaml/uml_repository/package_loader_spec.rb:151`) loads
a pre-built `.lur` fixture, exports, reloads. The critical path
— `Document` (built programmatically) → `PackageExporter` →
`.lur` file → `PackageLoader` → same `Document` — was
untested.

Fixture-based tests don't exercise the full create→serialize
loop; a regression in `PackageExporter` that produces invalid
LUR from new model instances would not be caught.

## Resolution

Added a new spec
`spec/lutaml/uml_repository/lur_round_trip_spec.rb` that:
1. Builds a Document programmatically with classes, packages,
   attributes, associations, generalization.
2. Wraps it in a Repository.
3. Exports to a temp `.lur` via PackageExporter.
4. Loads via PackageLoader.
5. Verifies the loaded Document matches (class names, package
   structure, attribute count).

## Verification

New spec passes; full suite green.
