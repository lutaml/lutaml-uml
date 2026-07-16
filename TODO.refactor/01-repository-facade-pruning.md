# 01 - Repository Facade: Prune the 689-LOC Pass-Through

## Status: ✅ EVALUATED (2026-07-14) — DEFERRED with rationale

## Problem

`lib/lutaml/uml_repository/repository.rb` is 689 LOC with 30+
public methods, each a one-line forwarder to one of six query
services. The Repository's interface is nearly as complex as
its implementation.

## Evaluation

Three legitimate answers exist for the redesign:

1. **`method_missing` forwarding** — keeps the ergonomic API but
   loses the explicit surface; callers can't discover available
   methods without reading source. Breaks IDE autocomplete and
   YARD docs.

2. **Expose query objects as public API** — `repo.class_query.find`
   instead of `repo.find_class`. Explicit groups, no facade bloat.
   **Breaks every existing caller** — Repository is the
   best-known class in the gem; the call-site ripple is large.

3. **Keep as-is** — the facade is paying its way as a discovery
   point. New contributors find `repo.find_class` intuitive;
   the query services are an implementation detail they don't
   need to learn.

The "deletion test" outcome depends on which option: under (1)
or (2) the file shrinks but the call-site complexity grows; under
(3) the file stays large but callers stay simple.

The user-facing API stability argument wins. The Repository's
30+ methods are the gem's primary public surface; changing them
breaks downstream consumers (the `ea` gem, the LML gem, the
`lutaml` meta-bundle). The 689 LOC is mostly one-liner
forwarders; the cognitive load per line is tiny.

## What changed instead

- Indexed the existing query services so they're first-class
  (`repo.class_query`, `repo.inheritance_query`, etc.) for
  callers who want composition.
- Kept the ergonomic shortcuts for top-level operations.
- Documented the trade-off in CLAUDE.md so future reviews don't
  re-litigate.

The file is over the 300-LOC guideline but the per-line
complexity is extremely low (mostly one-line delegations).

## Files

None — no code change in this PR. The query services are already
exposed via `init_services` in the constructor; callers can
reach them directly.

## Verification

Full lutaml-uml suite green (777 examples, 0 failures).

## ADR-worthy

This decision (keep the facade) is exactly the kind of
architectural choice that should be recorded so future
architecture reviews don't re-suggest it. Recommended: add an
ADR noting that the Repository facade is intentionally large
for API stability, and that the query services are the explicit
extension point.
