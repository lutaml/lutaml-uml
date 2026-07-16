# 08 - PackageExporter: Slim Down

## Status: ✅ EVALUATED (2026-07-14) — DEFERRED with rationale

## Problem

`lib/lutaml/uml_repository/package_exporter.rb` (334 LOC) with
inline helpers mixing serialization with statistics.

## Evaluation

The exporter composes two passes (manifest write + document
serialize) and includes helper methods that format data for the
manifest. Splitting would require either:
1. Extracting helpers to a separate file — but they're only
   used here, so the locality gain is zero.
2. Delegating to JsonExporter for serialization — already done
   for some pieces; the rest are LUR-package-specific
   (manifest format, metadata file).

The current shape is cohesive: one class owns the LUR package
format end-to-end.

## What changed instead

File is at the edge of the 300-LOC guideline. Per-line
complexity is low. Defer.

## Files

None — no code change.

## Verification

Full lutaml-uml suite green.
