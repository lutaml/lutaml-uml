# 14 - State Machine Element Specs

## Status: ✅ DONE (2026-07-14)

## Problem

State machine elements had zero spec coverage:

- `lib/lutaml/uml/activity.rb`
- `lib/lutaml/uml/actor.rb`
- `lib/lutaml/uml/connector.rb`
- `lib/lutaml/uml/state.rb`
- `lib/lutaml/uml/transition.rb`

## Resolution

Added behavioral specs for each — YAML round-trip, attribute access,
and collection management. Uses real model instances, no doubles.

## Files

- `spec/lutaml/uml/activity_spec.rb` (new)
- `spec/lutaml/uml/actor_spec.rb` (new)
- `spec/lutaml/uml/connector_spec.rb` (new)
- `spec/lutaml/uml/state_spec.rb` (new)
- `spec/lutaml/uml/transition_spec.rb` (new)

## Verification

Full lutaml-uml suite green; new specs add ~25 examples.
