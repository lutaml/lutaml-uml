# 22 - Duplicated `associations_to_yaml` / `associations_from_yaml`

## Status: ✅ DONE (2026-07-19)

## Problem

Three classes copy-pasted the exact same 14-line YAML custom
serializer for `associations`:

- `lib/lutaml/uml/document.rb:47-61`
- `lib/lutaml/uml/class.rb:40-54`
- `lib/lutaml/uml/data_type.rb:40-54`

Each `to_yaml` form sets `owner_end = model.name` then maps
`Association.to_yaml`. Each `from_yaml` form rebuilds the
associations array via `Association.from_yaml`. Pure duplication.

## Resolution

Extracted a `HasAssociations` mixin
(`lib/lutaml/uml/has_associations.rb`) that provides both
methods. `Document`, `UmlClass`, and `DataType` `include` it.

## Verification

Full suite green; existing YAML round-trip specs for class.yml
and document continue to pass.
