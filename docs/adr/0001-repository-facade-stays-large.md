# ADR-0001: Repository Facade Stays Large for API Stability

Date: 2026-07-14

## Context

`Lutaml::UmlRepository::Repository` is 689 LOC with 30+ public
methods, each a one-line forwarder to one of six query services
(`ClassQuery`, `InheritanceQuery`, `AssociationQuery`,
`PackageQuery`, `SearchQuery`, `DiagramQuery`).

Architecture review flagged this as a shallow facade — the
deletion test (deleting Repository would not concentrate
complexity, the query services already own it) suggested it's a
pass-through.

## Decision

**Keep the facade as-is.** The Repository's 30+ methods are the
gem's primary public surface. The ergonomics (`repo.find_class`
vs `repo.class_query.find`) win over file-size aesthetics.

## Consequences

- The file stays over the 300-LOC guideline. Per-line complexity
  is extremely low (mostly one-line delegations).
- New query methods still get added to Repository as one-line
  forwarders — the API growth is intentional.
- The query services (`ClassQuery`, `InheritanceQuery`, etc.)
  are also exposed via reader methods (`repo.class_query`,
  `repo.inheritance_query`) for callers who want composition.

## Alternatives considered

1. **`method_missing` forwarding** — rejected: loses explicit
   API surface, breaks IDE autocomplete and YARD docs.
2. **Expose query objects as the public API** — rejected:
   breaks every existing caller across `ea`, `lutaml-lml`, and
   the `lutaml` meta-bundle.

## References

- TODO.refactor/01-repository-facade-pruning.md
