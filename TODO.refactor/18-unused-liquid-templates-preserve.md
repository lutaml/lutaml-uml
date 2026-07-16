# 18 - Unused Liquid Templates (Policy: Preserve)

## Status: FLAGGED — preserved per CLAUDE.md "NEVER DELETE source files" rule

## What

`templates/static_site/` contains 248K of `.liquid` template files.
The Vue IIFE in `frontend/dist/` replaced them at runtime, but they
remain as source.

## Why not delete

CLAUDE.md absolute rule: "NEVER DELETE source files. ANY source
file — regardless of type." Templates are source. The Vue IIFE is
derived output.

## Recommendation

Move to `templates/static_site.legacy/` (preserved, clearly marked
as superseded) or add to `.gitignore` if the user prefers. Do not
delete without explicit user confirmation.

## Related

Supersedes TODO.next/07.
