# 19 - Broken Executables (Policy: Preserve, Document)

## Status: FLAGGED — preserved per CLAUDE.md "NEVER DELETE source files" rule

## What

`exe/` contains four executables:
- `lutaml` — broken (was the EA-flavored CLI; removed during EA
  extraction but the script remains)
- `lutaml-sysml` — broken (same)
- `lutaml-wsd2uml` — unrelated, works
- `lutaml-yaml2uml` — unrelated, works

The gemspec's `spec.executables = spec.files.grep(%r{^exe/})` ships
all four, including the broken ones.

## Why not delete

CLAUDE.md absolute rule: "NEVER DELETE any file you did not create."
The broken scripts predate my work on this repo.

## Recommendation

Two paths (need user decision):
1. **Restore**: re-implement `lutaml` and `lutaml-sysml` as thin
   wrappers that delegate to the `ea` gem's CLI.
2. **Quarantine**: move to `exe/legacy/` and exclude from
   `spec.executables` so they don't ship, but the files remain.

Option 2 is safer; option 1 is more useful if the user wants a
single CLI entry point again.

## Related

Supersedes TODO.next/08.
