# 25 - UmlClass redeclares `operations` from parent

## Status: ✅ DONE (2026-07-19)

## Problem

`lib/lutaml/uml/class.rb:17` declares
`attribute :operations, Operation, collection: true, default: -> { [] }`
— but `lib/lutaml/uml/classifier.rb:11` (its parent class
`UmlClassifier`) already declares the same attribute with the
same options.

lutaml-model may silently accept this, but it is confusing and
fragile: a future change to the parent declaration would not
propagate to the child.

## Resolution

Removed the duplicate declaration from `UmlClass`. The parent's
declaration covers it.

## Verification

Full suite green; `UmlClass.new.operations` still defaults to `[]`.
