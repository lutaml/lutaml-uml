# 11 - Shallow Base Classes: Decide Their Fate

## Status: ✅ DONE (2026-07-14) — KEPT with rationale

## Problem

`BaseExporter` (61 LOC) and `Output::Strategy` (36 LOC) looked
shallow — each holds an `@output_path` / `@repository`, declares
`NotImplementedError` on the abstract method, and adds no behaviour.

Deletion test: would deleting them concentrate complexity?

## Resolution

**Kept both.** Reasoning:

- They declare the *contract* — `#export(path, options)` for
  exporters, `#generate` for strategies. Without them, every
  subclass re-rolls the constructor signature and the abstract
  method shape. The contract is the test surface; deleting the
  base classes removes the seam.
- Two adapters each = real seam per the "two adapters means a real
  seam" rule. The base class is where the seam lives.
- The classes are small but they earn their keep: they prevent
  drift in the subclass constructors and abstract-method
  signatures.

Added an explicit docstring to each one explaining the contract and
why the class exists. Future reviewers won't need to re-litigate.

## Files

- `lib/lutaml/uml_repository/exporters/base_exporter.rb` (docstring added)
- `lib/lutaml/uml_repository/static_site/output/strategy.rb` (docstring added)

## Verification

No code change; full suite green.
