# 21 - require_relative in Specs (CLAUDE.md violation)

## Status: ✅ DONE (2026-07-19)

## Problem

26 spec files use `require_relative` with brittle relative paths
like `"../../../../lib/lutaml/uml_repository/..."`. CLAUDE.md
explicitly forbids this: "In this repo, specs should use
`require` since the gem's lib is on the load path via bundler."

The relative paths break on file moves and obscure the
distinction between internal-library `require_relative` (still
forbidden everywhere) and spec-loading `require`.

## Resolution

Sed-replaced every `require_relative "../../../.../..."` in
specs with `require "lutaml/uml_repository/..."` (or
`lutaml/uml/...`). Bundler's load path handles the rest.

## Verification

Full suite green.
