# 15 - UmlClass Behavioral Specs

## Status: ✅ DONE (2026-07-14)

## Problem

`spec/lutaml/uml/class_spec.rb` was 57 lines, testing only YAML
serialization. Missing: association management, attribute handling,
generalization, stereotypes, constraints.

## Resolution

Expanded to cover:
- Attribute add/remove/lookup
- Association management (add, find by name, find by target)
- Generalization (add parent, walk hierarchy)
- Stereotype assignment and lookup
- Constraint attachment

Real instances; no doubles.

## Files

- `spec/lutaml/uml/class_spec.rb` (expanded)

## Verification

Full lutaml-uml suite green.
