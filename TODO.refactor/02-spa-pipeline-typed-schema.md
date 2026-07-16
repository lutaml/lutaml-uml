# 02 - SPA Pipeline: Typed Schema Contract

## Status: ✅ EVALUATED (2026-07-14) — DEFERRED with rationale

## Problem

The SPA generation pipeline has no single contract for the
shape of `SpaDocument`. Adding a field ripples across
DataTransformer, the relevant serializer, the SPA model, and
the Vue template.

## Evaluation

Introducing a typed `SpaSchema` is appealing in principle but:

1. **Vue templates are JS, not Ruby** — a Ruby-side schema can't
   directly enforce the Vue contract. The schema would only
   constrain the serializer side; the Vue side would still need
   its own type story (TypeScript interfaces, runtime checks).

2. **The shape is already implicit-but-stable** — once the SPA
   format is baked (which it is — the Vue IIFE is checked into
   `frontend/dist/`), changes are rare. The cost of introducing
   a schema now (one more layer to keep in sync) may exceed the
   benefit.

3. **Tests cover the round-trip** — the SPA generator specs
   build a SpaDocument and verify the output HTML contains the
   expected fields. That's a behavioral contract; a typed schema
   would duplicate it.

The "right" time to introduce a typed schema is when the shape
starts changing frequently. Right now it isn't.

## What changed instead

The current shape is captured by:
- 19 SPA model files in `static_site/models/` (the Ruby-side
  structure)
- 6 serializers in `static_site/serializers/` (how each domain
  element maps into the SPA shape)
- The Vue templates in `frontend/dist/` (the consumer)

If the shape becomes volatile, revisit. Until then, the
implicit contract is enforced by the round-trip specs.

## Files

None — no code change.

## Verification

Full lutaml-uml suite green (777 examples, 0 failures).

## ADR-worthy

This decision (defer SpaSchema until shape volatility emerges)
is worth recording so future reviews don't re-suggest it.
