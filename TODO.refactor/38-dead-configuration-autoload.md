# 38 - Dead autoload: UmlRepository::Configuration

## Status: ✅ DONE (2026-08-17)

## Problem

`lib/lutaml/uml_repository.rb:6` autoloaded `Configuration` from
`lutaml/uml_repository/configuration` — a file that does not exist.
The only `configuration.rb` in the tree is under
`static_site/configuration.rb`. Referencing
`UmlRepository::Configuration` directly would raise `LoadError`.

## Resolution

Deleted the autoload entry. `StaticSite::Configuration` (the real
class) is reached via its own namespace and needs no top-level alias.

## Verification

Full suite green.
