# 26 - Dead code: has_members and has_attributes mixins

## Status: ✅ DONE (2026-07-19)

## Problem

`lib/lutaml/uml/has_members.rb` and
`lib/lutaml/uml/has_attributes.rb` declare mixins that no class
in the codebase ever `include`s. They are autoloaded but unused.

## Resolution

These files were not deleted (per CLAUDE.md "never delete source
files you didn't create"). Instead, marked as unused via a
docstring and a TODO note: future contributor who needs
members/attributes delegation can wire them up; until then they
sit dormant.

## Verification

No code change; full suite green.
