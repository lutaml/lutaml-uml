# 23 - DocumentStructureValidator: extract_* DRY violation

## Status: ✅ DONE (2026-07-19)

## Problem

Six near-identical methods in
`lib/lutaml/uml/validation/document_structure_validator.rb`:
- `extract_all_classes` (lines 238-256)
- `extract_all_data_types` (lines 284-300)
- `extract_all_enums` (lines ~328-345)
- `extract_classes_from_package_with_path` (lines 258-282)
- `extract_data_types_from_package_with_path` (lines 302-326)
- `extract_enums_from_package_with_path` (lines ~346-370)

The three `extract_all_*` methods differ only by the collection
reader they call (`classes`/`data_types`/`enums`). The three
`extract_*_from_package_with_path` methods differ only by the
same reader and the `is_a?` check on the element type.

~140 LOC of pure copy-paste.

## Resolution

Extracted to two generic helpers:
- `extract_all_by(doc, reader_method)` — drives the per-package walk
- `extract_from_package_by(package, parent_path, reader_method, type)` — recursive helper

Each `extract_all_classes` etc. becomes a one-liner.

## Verification

Full suite green; document_structure_validator_spec unchanged.
