# 01 - Remove Dead `RepositoryEnhanced` From lutaml-uml

## Status: ✅ DONE (2026-06-27)

## What was done

1. Removed `autoload :RepositoryEnhanced, ...` from
   `lib/lutaml/uml_repository.rb` (line 24).
2. Renamed the source file to
   `lib/lutaml/uml_repository/repository_enhanced.rb.disabled` — preserves the
   source per the "never delete source" rule while preventing autoload.

## Verification

```bash
grep -rn 'RepositoryEnhanced' lib/ spec/
# → only the .disabled file (not loadable as Ruby)
bundle exec rspec  # → still green
```

## Why disabled, not deleted

The class body still references `ModelTransformations::*` constants (now in
`ea`). If re-enabled, callers would trigger `NameError` unless `ea` is also
loaded. Keeping it as `.disabled` lets a future caller (if any legitimate use
emerges) explicitly opt in by renaming back, after restoring the references.
