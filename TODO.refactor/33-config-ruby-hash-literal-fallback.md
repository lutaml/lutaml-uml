# 33 - Configuration parse_ruby_hash_literal: legacy migration path

## Status: ✅ EVALUATED (2026-07-19) — DEFERRED with rationale

## Problem

`lib/lutaml/uml_repository/static_site/configuration.rb` still
ships the `parse_ruby_hash_literal` parser that handles legacy
`=>` Ruby hash syntax in YAML config values. This was added
when the prior `eval()` was removed.

## Evaluation

The parser exists for backward compatibility with config files
that used `key => value` syntax. No shipped config in this repo
uses it. Whether any downstream user does is unknown.

Removing the parser would silently break configs that still
use `=>` — the YAML.safe_load path already handles standard
`key: value` syntax, so the fallback only matters for the
legacy `=>` form.

## Decision

Defer until we can confirm no downstream consumer relies on
the `=>` syntax. A 1-release deprecation cycle (warn on use,
remove in next major) is the right path if it ever needs to go.

## Files

None — no code change.
