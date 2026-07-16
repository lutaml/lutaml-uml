# 12 - Typed Index Keys (Replace Stringly-Typed Hash)

## Status: ✅ DONE (2026-07-14)

## Problem

All query objects took `@indexes` as a Hash and accessed it with
symbol keys (`:qualified_names`, `:package_paths`, `:stereotypes`,
`:inheritance_graph`, `:associations`, `:diagram_index`). Key names
were defined in `IndexBuilder` but never declared as constants. A
typo silently returned nil.

## Resolution

Introduced `Lutaml::UmlRepository::IndexKeys` as a frozen constant
module declaring every valid index key. Query classes use
`IndexKeys::<NAME>` instead of bare symbols. `LazyRepository`
raises on unknown keys at `ensure_index` time (already done via
`INDEX_BUILDERS` registry — this TODO completes the type story by
making keys named).

## Files

- `lib/lutaml/uml_repository/index_keys.rb` (new)
- `lib/lutaml/uml_repository/queries/*.rb` (uses IndexKeys constants)
- `lib/lutaml/uml_repository/lazy_repository.rb` (uses IndexKeys constants)

## Verification

Full lutaml-uml suite green.
