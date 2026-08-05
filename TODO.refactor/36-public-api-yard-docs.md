# 36 - Public API documentation (YARD)

## Status: ✅ EVALUATED (2026-07-19) — DEFERRED with rationale

## Problem

Many public methods on `Repository` and the model classes have
no YARD documentation. Users discovering the API have to read
source.

## Evaluation

Adding YARD docs to 30+ Repository methods + 60+ model classes
is a substantial documentation effort that doesn't change
behavior. The risk of stale docs is high if the API is still
evolving.

## Decision

Defer until API surface stabilizes (post-1.0). The TODO
captures the gap; future documentation sprint can address it
comprehensively.

## Files

None — no code change.
