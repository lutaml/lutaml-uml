# 05 - Remove Dead Autoload Modules in UmlRepository

## Status: DONE (2026-06-27)

## Problem
`lib/lutaml/uml_repository.rb` had two pieces of dead code:

1. `module UmlRepositoryComponents` — autoloaded `IndexBuilder`,
   `StatisticsCalculator`, `PackageExporter`, `PackageLoader` from the
   same paths as the top-level autoloads already declared above it.
   Pure DRY violation: no caller ever referenced
   `Lutaml::UmlRepository::UmlRepositoryComponents::*`. The classes are
   accessed via the top-level `Lutaml::UmlRepository::IndexBuilder` etc.

2. `module WebUi` with `autoload :App,
   "lutaml/uml_repository/web_ui/app"` — the target file does not
   exist. Any attempt to access `Lutaml::UmlRepository::WebUi::App`
   would raise `LoadError` at runtime. No spec or lib code references
   this module.

## Fix
Deleted both module blocks from `lib/lutaml/uml_repository.rb`. No
behavior change (the autoloads were never triggered). The real
IndexBuilder/StatisticsCalculator/PackageExporter/PackageLoader
autoloads at the top of the file are unchanged.

## Verification
- `bundle exec rspec` in lutaml-uml: 754 examples, 0 failures, 103
  pending (unchanged from baseline)
- `grep -rn UmlRepositoryComponents lib/ spec/` → no results
- `grep -rn "WebUi\b" lib/ spec/` → no results
