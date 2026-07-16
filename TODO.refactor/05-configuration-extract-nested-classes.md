# 05 - Configuration: Extract Nested Serializable Classes

## Status: ✅ EVALUATED (2026-07-14) — DEFERRED with rationale

## Problem

`lib/lutaml/uml_repository/static_site/configuration.rb` (405 LOC)
declares 14 nested `Lutaml::Model::Serializable` classes inline
plus the top-level Configuration loader.

## Evaluation

The nested classes are small (most are 5-15 LOC) and only the
top-level Configuration references them. Splitting into 14 files
would multiply the file count without improving locality — the
configuration sections are tightly coupled to the loader's
mapping block, which is right next to them in the current file.

The risk of splitting: the YAML mapping block references each
nested class by name. Splitting them into files requires either:
1. **Requiring each file explicitly** — adds 14 requires, violates
   the autoload rule unless each goes through an autoload entry.
2. **Autoloading each section** — possible but adds 14 autoload
   entries to maintain.

Neither path improves the readability of the configuration
loader itself. The current shape (one file, sections inline)
makes the configuration schema visible at a glance.

## What changed instead

The file is over the 300-LOC guideline but the LOC per concept is
low — it's mostly attribute declarations, not control flow. The
cost of splitting exceeds the benefit.

## Files

None — no code change.

## Verification

Full lutaml-uml suite green; all 23 configuration specs pass.
