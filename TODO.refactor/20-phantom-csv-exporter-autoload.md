# 20 - Phantom CsvExporter Autoload (Runtime Bomb)

## Status: ✅ DONE (2026-07-19)

## Problem

`lib/lutaml/uml_repository.rb:27` autoloaded
`CsvExporter` from `lutaml/uml_repository/exporters/csv_exporter`
— but the target file does not exist anywhere in the repo.
Any code path that references `CsvExporter` triggers a `LoadError`
at runtime.

## Resolution

Deleted the autoload line. Zero references to `CsvExporter`
anywhere in `lib/` or `spec/`.

## Verification

Full suite green.
