# 41 - Query-service readers are private; ADR-0001 says exposed

## Status: ✅ DONE (2026-08-17)

## Problem

ADR-0001 states: "The query services are already exposed via
reader methods (`repo.class_query`, `repo.inheritance_query`,
etc.) for callers who want composition." In reality the
`attr_reader` declarations sat under `private` in
`repository.rb` — external callers could NOT compose queries.
The documented contract was false.

## Resolution

Made the six query-service readers public (`attr_reader` moved
out of the `private` section). This fulfills the ADR rather than
weakening it — the composability rationale is sound, and public
readers are the smallest change that delivers it.

Callers can now write:

```ruby
repo.inheritance_query.find_ancestors(id)
```

alongside the ergonomic facade (`repo.find_class`).

## Verification

Full suite green; new spec asserts `repo.class_query` is
publicly callable.
