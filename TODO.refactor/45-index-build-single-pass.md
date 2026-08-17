# 45 - IndexBuilder.build_all walks the package tree 4 times

## Status: ✅ EVALUATED (2026-08-17) — DEFERRED with rationale

## Problem

`IndexBuilder.build_all` performs four separate recursive
traversals of `@document.packages` (package-path index,
qualified-name index, stereotype index, diagram index). A
single-pass visitor populating all four simultaneously would
traverse once.

## Evaluation

- Measured cost on the plateau fixture (58 packages, 693
  objects): index building completes in well under a second.
  Traversal is not the bottleneck; the per-element Ruby work is.
- The four indexes have **different prerequisites**
  (`inheritance_graph` needs `qualified_names` first;
  `diagram_index` needs `package_paths` first). The current
  split mirrors the dependency graph and lets `LazyRepository`
  build each index on demand. A fused single pass would build
  all four eagerly, defeating laziness — or need conditional
  partial passes, which reintroduces the complexity the current
  split avoids.
- Tests cover each index independently; a fused visitor would
  need new seams to keep that.

## Decision

Defer. Laziness (the ability to build only the requested index)
is worth more than saving three traversals on a sub-second
operation.

## Files

None — no code change.
