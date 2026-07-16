# 13 - Presenter `to_hash` Mixin (DRY)

## Status: ✅ DONE (2026-07-14) — NO CHANGE, with rationale

## Problem (initial framing)

Seven presenter classes each defined their own `to_hash` method,
hand-rolling serialization. The initial concern was that this
violates CLAUDE.md's "NEVER write `def to_h` on a model class" rule.

## Resolution

**No change.** Re-evaluation: the CLAUDE.md rule's qualifier is
"on a model class." Presenters are NOT model classes — they don't
extend `Lutaml::Model::Serializable` and they aren't domain models.
They're presentation objects whose explicit job is to translate a
domain model into a wire-format hash. The `to_hash` method IS the
presentation contract.

The rule's intent — prevent hand-rolled serialization from
bypassing the type system on typed models — does not apply here.
Presenters are intentionally untyped presentation layers.

**On the DRY concern:** the 7 presenters share common fields
(`type:`, `name:`, `visibility:`, `stereotype:`) but each also has
presenter-specific keys (`attr_type:`, `class_name:`, `general:`,
etc.). Extracting a `PresenterHash` mixin for the common fields
would be a premature abstraction — three similar lines is better
than a wrong abstraction (per CLAUDE.md). The drift risk is low
because each presenter has its own specs covering its `to_hash`
output.

## Files

None — no code change.

## Verification

Full lutaml-uml suite green (754 examples, 0 failures).
