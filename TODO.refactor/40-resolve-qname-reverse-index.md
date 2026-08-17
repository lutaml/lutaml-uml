# 40 - `resolve_qname` ignores reverse index (O(n) scans)

## Status: ✅ DONE (2026-08-17)

## Problem

`InheritanceQuery#resolve_qname` and
`ClassQuery#resolve_qname_for` each did a linear scan over all
`indexes[:qualified_names]` entries to map an object to its
qualified name. IndexBuilder already builds a
`class_to_qname` reverse index for exactly this lookup — the
queries just never used it.

## Resolution

Both lookups now use `indexes[IndexKeys::CLASS_TO_QNAME]` first
(O(1) hash access), falling back to a linear scan only when the
reverse index is absent (defensive for hand-built index hashes
in tests).

## Verification

Full suite green. Plateau-scale models no longer scan per query.
