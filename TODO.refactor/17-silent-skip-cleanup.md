# 17 - Silent Skip Patterns in Query Specs

## Status: ✅ DONE (2026-07-14)

## Problem

`spec/lutaml/uml_repository/queries/class_query_spec.rb` had ~9
`next unless qname` / `next unless pkg_path` patterns that silently
passed when fixture preconditions failed. Same pattern in
`inheritance_query_spec.rb` (~4 sites).

These gave false confidence — the test "passed" even when the
fixture was missing the data it claimed to exercise.

## Resolution

Replaced each silent skip with an explicit `expect(fixture_data).not_to be_empty`
precondition. If the fixture lacks the data, the test fails loudly
with a clear message; if the data is present, the assertion runs
normally.

## Files

- `spec/lutaml/uml_repository/queries/class_query_spec.rb`
- `spec/lutaml/uml_repository/queries/inheritance_query_spec.rb`

## Verification

Full lutaml-uml suite green.
