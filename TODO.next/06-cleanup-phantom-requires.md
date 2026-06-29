# 06 - Clean Up Phantom Requires and Unused gemspec Dependencies

## Status: DONE (2026-06-29)

## Problem
`lib/lutaml/uml_repository.rb` declared two top-level requires for gems
that no code in `lib/` actually uses:

```ruby
require "liquid"       # no Liquid:: namespace reference anywhere in lib/
require "lutaml/path"  # no Lutaml::Path usage anywhere in lib/
```

The gemspec mirrored this with two corresponding runtime dependencies:

```ruby
spec.add_dependency "liquid"
spec.add_dependency "lutaml-path"
```

Both were residue from a Liquid-based rendering pipeline that was
replaced by the Vue IIFE strategy (`Output::VueInlinedStrategy`). The
`templates/static_site/*.liquid` files themselves remain on disk but
nothing loads them at runtime — see [[07-unused-liquid-templates]].

## Fix
- Removed `require "liquid"` and `require "lutaml/path"` from the top
  of `lib/lutaml/uml_repository.rb`.
- Removed `spec.add_dependency "liquid"` and
  `spec.add_dependency "lutaml-path"` from `lutaml-uml.gemspec`.

No behavior change. Both gems were load-time phantom requires with no
runtime callers.

## Verification
- `find lib -name '*.rb' -print0 | xargs -0 grep -l 'Liquid::'` → no results
- `find lib -name '*.rb' -print0 | xargs -0 grep -l 'Lutaml::Path'` → no results
- `bundle exec rspec` in lutaml-uml: 754 examples, 0 failures, 103 pending
  (unchanged from baseline)

## Lesson
A `require` at the top of a file is a load-time dependency commitment.
When the code that used the required library is removed or replaced,
the require statement is often left behind, silently pulling in gems
that no caller actually needs. Audit requires the same way you audit
method calls.
