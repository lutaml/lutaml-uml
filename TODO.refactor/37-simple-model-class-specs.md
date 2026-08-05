# 37 - Spec coverage for simple model classes

## Status: ✅ EVALUATED (2026-07-19) — DEFERRED with rationale

## Problem

~65 lib files have no spec at all. Most are simple
lutaml-model Serializable classes (Abstraction, Dependency,
Realization, etc.) auto-generated from the UML metamodel.

## Evaluation

These classes are mostly declarative — attribute declarations
plus YAML mappings. The behavior they expose is provided by
lutaml-model itself, which has its own test coverage.

Adding specs for each would mostly test lutaml-model's
behavior, not this gem's. The state-machine elements
(activity/actor/connector/state/transition) were the
exception — they had non-trivial behavior. TODO.refactor/14
added specs for those.

## Decision

Defer. State-machine elements are now covered (TODO 14).
Simple declarative classes inherit their contract from
lutaml-model; adding 65 thin specs would be ceremony.

## Files

None — no code change.
