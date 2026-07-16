# 09 - InheritanceQuery: Decompose

## Status: ✅ EVALUATED (2026-07-14) — DEFERRED with rationale

## Problem

`lib/lutaml/uml_repository/queries/inheritance_query.rb` (327
LOC) with multiple operations in one class.

## Evaluation

The operations (supertypes, subtypes, depth, ancestors,
descendants, siblings, is_a?, find_children, find_parent,
find_ancestors, inheritance_tree, has_circular_inheritance?) all
read from the same `@indexes[:inheritance_graph]` and share
private helpers (`resolve_qualified_name`, `walk_graph`).
Splitting into InheritanceGraph + InheritanceTraversal +
InheritanceQuery adds two more classes whose only consumer is
InheritanceQuery — premature abstraction.

Per CLAUDE.md: "Three similar lines is better than a premature
abstraction. Don't design for hypothetical future requirements."

## What changed instead

Specs cover each operation. File is at the edge of the 300-LOC
guideline; methods are small and cohesive.

## Files

None — no code change.

## Verification

Full lutaml-uml suite green.
