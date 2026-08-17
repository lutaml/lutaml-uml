# 39 - `resolve_class` duplicated across query services

## Status: ✅ DONE (2026-08-17)

## Problem

`resolve_class` was identically defined in both
`AssociationQuery` (line ~137) and `InheritanceQuery`
(line ~132). Both do a linear scan of
`indexes[:qualified_names]` to find the object behind an
`xmi_id`. Divergence risk as queries evolve; classic DRY gap on
the shared `BaseQuery` seam.

## Resolution

Promoted `resolve_class` to `BaseQuery` (the shared constructor
base both services already extend). Removed both private copies.

## Verification

Full suite green; association/inheritance query specs unchanged.
