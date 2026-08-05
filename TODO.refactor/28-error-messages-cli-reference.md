# 28 - Error messages reference CLI commands this gem does not ship

## Status: ✅ DONE (2026-07-19)

## Problem

`lib/lutaml/uml_repository/error_handler.rb` lines 54, 79, and
related messages reference CLI commands like `'search'`,
`'find'`, `'list'`, `'tree'`. The CLI lives in the `lutaml`
meta-bundle, not this gem. Direct users of `lutaml-uml` see
confusing suggestions.

## Resolution

Updated messages to reference the Ruby API:
- "Use the 'search' or 'find' commands" → "Use Repository#search or #find_class"
- "Use the 'list' or 'tree' commands" → "Use PackageQuery#list or #tree"

## Verification

Full suite green; error_handler_spec updated to match new messages.
