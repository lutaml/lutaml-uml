# 06 - JsonExporter: Replace Hand-Rolled `to_h` with lutaml-model

## Status: ✅ EVALUATED (2026-07-14) — DEFERRED with rationale

## Problem

JsonExporter had multiple `serialize_*` private methods that
hand-built Hashes from UML model instances.

## Evaluation

The exporter builds a wire-format hash with a specific shape
(`metadata`, `packages`, `classes`, `associations`) that does
NOT match the domain model shape 1:1. The hash includes computed
fields (`package_path` derived from qualified name, stereotype
normalization, qualified-name lookups via the index).

Replacing this with `lutaml-model` mappings would require:
1. Declaring a new Serializable for each output section with the
   specific wire shape.
2. Mapping each output field to either a model attribute or a
   computed value.
3. Maintaining the new Serializables separately from the
   existing presenters (which already produce similar hashes via
   `to_hash`).

The presenters already do most of this work — the exporter's
`serialize_*` methods are essentially calling presenter logic
plus a few computed fields. The right long-term shape is for the
exporter to delegate to presenters fully (already partially done
for some classes).

Per the same evaluation as TODO.refactor/13 (presenters are
presentation-layer code, not domain models), the hand-rolled
`to_hash` is appropriate at this layer.

## What changed instead

The TODO.refactor/16 work (replacing doubles in the
`json_exporter_spec`) revealed that the exporter's interface
works correctly when called against real model instances.
No correctness issue; the architectural concern is documented
but not blocking.

## Files

None — no code change.

## Verification

Full lutaml-uml suite green; all 4 json_exporter specs pass
against real model instances.
