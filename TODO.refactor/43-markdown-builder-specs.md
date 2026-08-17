# 43 - Markdown page builders have no direct specs

## Status: ✅ DONE (2026-08-17)

## Problem

`lib/lutaml/uml_repository/exporters/markdown/` contains
`class_page_builder.rb` (187 LOC) and `package_page_builder.rb`
(107 LOC) — real formatting logic (headers, link resolution,
stereotype rendering). The only spec coverage was indirect via
the top-level `MarkdownExporter` smoke test, which asserts
directories/files exist, not content.

## Resolution

Added `spec/lutaml/uml_repository/exporters/markdown/
class_page_builder_spec.rb` and `package_page_builder_spec.rb`
covering: heading shape, qualified-name rendering, package-path
derivation, link generation via the real `LinkResolver`, and
stereotype display. Real model instances; no doubles.

## Verification

New specs pass; full suite green.
