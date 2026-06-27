# 02 - Drop `Fontname` Autoload (Dead Code)

## Status: ✅ DONE (2026-06-27)

## What was done

1. Removed `autoload :Fontname, "lutaml/uml/fontname"` from
   `lib/lutaml/uml.rb`.
2. Added deprecation header to `lib/lutaml/uml/fontname.rb`.
3. **Kept** `autoload :Group` — `Document` uses it
   (`attribute :groups, Group, collection: true`). The original TODO.namespace
   audit was incorrect.

## Source file (kept, not deleted)

- `lib/lutaml/uml/fontname.rb` — deprecated header added; file retained per
  never-delete-source rule.

## Verification

```bash
grep -n 'Fontname' lib/lutaml/uml.rb  # → no autoload
grep -n 'Group' lib/lutaml/uml.rb     # → autoload still present (used by Document)
bundle exec rspec  # → 754 examples, 0 failures, 103 pending
```

## Lesson

The audit "Group is unused" was based on grepping for `:Group,` as a type.
The actual usage is `Group, collection: true` (no leading colon) in
`lib/lutaml/uml/document.rb:11`. Future dead-code audits must check both
`:Symbol` and bare constant forms.
