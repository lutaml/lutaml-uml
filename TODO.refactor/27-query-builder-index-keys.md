# 27 - QueryBuilder bypasses IndexKeys constants

## Status: ✅ DONE (2026-07-19)

## Problem

`lib/lutaml/uml_repository/query_dsl/query_builder.rb:232-241`
uses bare symbol keys (`indexes[:qualified_names]`,
`indexes[:package_paths]`) instead of the typed `IndexKeys`
constants used everywhere else after TODO.refactor/12 landed.

## Resolution

Switched the call site to `IndexKeys::QUALIFIED_NAMES` and
`IndexKeys::PACKAGE_PATHS`. Typos now surface at load time.

## Verification

Full suite green.
