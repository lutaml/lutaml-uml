# 24 - primitive_type? duplicated with divergent lists

## Status: ✅ DONE (2026-07-19)

## Problem

Two validators each defined `primitive_type?` with their own
list:

- `lib/lutaml/uml_repository/validators/repository_validator.rb:314`
  — 14 entries, PascalCase (`String`, `Integer`, `Boolean`, ...)
- `lib/lutaml/uml/validation/document_structure_validator.rb:372`
  — 18 entries, mixed case (`int`, `string`, `Integer`, ...)

Neither references the other. Drift risk; one model could pass
validation while the other rejects it.

## Resolution

Extracted to a shared module `Lutaml::Uml::PrimitiveTypes` with
a single `PRIMITIVE_TYPES` set and `primitive_type?(type)`
helper. Both validators `include` it.

The merged list is the union (preserves backward compatibility
for any consumer of either list).

## Verification

Full suite green.
