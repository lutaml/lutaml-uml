# 03 - Add Missing Behavioral Specs

## Status: NOT YET APPLIED

## Problem

Critical behavioral coverage gaps in `lutaml-uml`:

### High-priority gaps
1. `spec/lutaml/uml/uml_class_spec.rb` — only 57 lines, tests YAML
   serialization only. Missing: association management, attribute handling,
   generalization, stereotypes, constraints.
2. `spec/lutaml/uml_repository/static_site/serializers/inheritance_resolver_spec.rb`
   — only tests "returns empty for no generalization." Missing: actual
   multi-level inheritance attribute/association flow.
3. No spec for circular inheritance detection with actual circular graphs.
4. `spec/lutaml/uml_repository/validators/repository_validator_spec.rb` —
   private method tests only assert `result.is_a?(Array)`, never assert
   specific errors found.
5. No spec for `Repository#from_file_cached` cache invalidation behavior.

### Edge cases missing
- Self-referential associations
- Diamond inheritance
- Special regex characters in search

### Silent skip patterns to fix
These patterns silently pass tests when their precondition fails. They should
either use `skip` with a reason, or guarantee the test data:

- `spec/lutaml/uml_repository/queries/class_query_spec.rb` — `next unless`
  silently passes ~9 tests
- `spec/lutaml/uml_repository/queries/inheritance_query_spec.rb` — `next unless`
  silently passes ~4 tests
- `spec/lutaml/uml_repository/parsing/full_parsing_spec.rb` — `next if ...`
  silently passes ~7 tests

## Source

Migrated from `TODO.refactor/12-add-missing-behavioral-specs.md`.

## Fix

1. Expand `uml_class_spec.rb` to cover the metamodel API surface
   (associations, attributes, generalization, stereotypes).
2. Replace `next unless` patterns with either:
   - `skip "reason"` if the data is sometimes unavailable, OR
   - A guaranteed fixture (programmatic document via `create_simple_test_document`)
3. Add circular inheritance fixture (programmatic).
4. Add cache invalidation spec for `from_file_cached` using `sleep` + `touch`
   to control mtimes.
5. Assert specific validator errors, not just result types.

## Out of scope (deferred)

Regenerating `.lur` fixtures via the `ea` gem — those are tracked separately.
