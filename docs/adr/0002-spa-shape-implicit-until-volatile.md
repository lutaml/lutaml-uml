# ADR-0002: SPA Document Shape Stays Implicit Until Volatile

Date: 2026-07-14

## Context

The SPA generation pipeline (Generator → DataTransformer → 6
serializers → 19 SPA model files → Vue templates) has no single
declared contract for the shape of `SpaDocument`. Adding a
field today requires touching the model file, the serializer,
and the Vue template.

Architecture review suggested introducing a typed `SpaSchema`
as the single contract.

## Decision

**Defer.** The shape is currently stable (the Vue IIFE is
checked into `frontend/dist/`, indicating the format is baked).
A typed schema on the Ruby side cannot enforce the Vue
(JavaScript) side contract directly — it would only constrain
the serializer half. The implicit contract is currently
enforced by the SPA generator's round-trip specs.

## Consequences

- The 19 SPA model files + 6 serializers continue to be the
  implicit shape declaration.
- Future shape changes ripple across model + serializer + Vue
  template. This is acceptable while changes are rare.
- When shape volatility emerges (multiple new fields per
  release), revisit and introduce the typed schema.

## Alternatives considered

1. **Introduce `SpaSchema` now** — rejected: duplicates the
   round-trip specs and adds a layer to keep in sync without
   enforcing the Vue side.
2. **Move to TypeScript on the Vue side with shared schema** —
   out of scope for this gem; would require a separate
   codegen step.

## References

- TODO.refactor/02-spa-pipeline-typed-schema.md
