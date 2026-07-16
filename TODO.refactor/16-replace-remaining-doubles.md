# 16 - Replace Remaining Doubles in Specs

## Status: ✅ DONE (2026-07-14)

## Problem

18 `double()` calls remained in specs, concentrated in:
- `spec/lutaml/uml_repository/search_result_spec.rb`
- `spec/lutaml/uml_repository/exporters/markdown_exporter_spec.rb`
- `spec/lutaml/uml_repository/exporters/json_exporter_spec.rb`
- `spec/lutaml/uml_repository/presenters/class_presenter_spec.rb`
- `spec/lutaml/uml_repository/presenters/element_presenter_spec.rb`
- `spec/lutaml/uml_repository/presenters/presenter_factory_spec.rb`

CLAUDE.md forbids doubles — they couple tests to implementation
details and pass when real usage breaks.

## Resolution

Replaced each `double(...)` with either:
- A real model instance built via test factory, or
- A `Struct.new(...)` for plain data when no real model fits.

Each replaced spec now exercises the real interface.

## Files

The six spec files listed above.

## Verification

Full lutaml-uml suite green; grep `double(` in `spec/` returns 0.
