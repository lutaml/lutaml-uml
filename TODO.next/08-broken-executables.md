# 08 - Broken / Misplaced Executables (Flag, Don't Delete)

## Status: FLAGGED — gemspec ships broken scripts

## What
The gemspec declares `bindir = "exe"` and
`spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }`,
which picks up all four files in `exe/`. Two are broken; two are
unrelated to lutaml-uml's actual purpose.

| File | Status | Issue |
|---|---|---|
| `exe/lutaml` | BROKEN | `require "lutaml"` — no `lib/lutaml.rb` exists. `require "lutaml/cli"` — `lib/lutaml/cli.rb` was removed in commit `e7b5e68` (the EA-extraction refactor) because it was incorrectly classified as EA-specific. |
| `exe/lutaml-sysml` | BROKEN | `require "reeper"` (long-orphaned gem), plus same `lutaml/cli` issue. |
| `exe/lutaml-wsd2uml` | UNRELATED | Standalone PlantUML→LutaML converter. No `lutaml/uml` or `lutaml/uml_repository` deps. Belongs in a separate `lutaml-wsd2uml` gem or in `lutaml-lml`. |
| `exe/lutaml-yaml2uml` | UNRELATED | Standalone YAML→LutaML converter. Same — no lib deps, wrong gem. |

## Why this matters
`gem install lutaml-uml` currently installs four commands onto the
user's PATH. Two of them crash immediately on invocation. The other
two work but are misleading — they suggest the gem does PlantUML and
YAML conversion, which it does not.

## Root cause
Commit `e7b5e68` (refactor: remove EA-specific code from lutaml-uml)
removed `lib/lutaml/cli.rb` along with `lib/lutaml/cli/` because the
CLI was thought to be EA-flavored. In fact the CLI was a UML/Repository
CLI (`thor`-based, drove `Lutaml::UmlRepository::Repository`). It should
have stayed in `lutaml-uml`, or been moved to `lutaml-lml`. The exes
that called it were left in place, leaving the gem half-gutted.

## Why not delete
- **Never-delete-source rule** — these exes are source files; deleting
  them is destructive and irreversible.
- **Scope uncertainty** — the right fix depends on user intent:
  - Restore the CLI to lutaml-uml (revert part of e7b5e68)?
  - Move the CLI to lutaml-lml?
  - Replace with a new minimal `lutaml-uml` CLI?
  - Just remove the broken exes from the gemspec (keep files in git)?

## Suggested resolution (user decision required)
Minimal safe option until user picks a path:

1. Update gemspec to NOT ship the broken/unrelated executables:
   ```ruby
   spec.executables = []   # none of the existing exes are functional
   ```
   Files stay in git; `gem install` no longer puts broken scripts on PATH.

OR

2. Restore `lib/lutaml/cli.rb` from `git show e7b5e68^:lib/lutaml/cli.rb`
   and re-wire `exe/lutaml` to drive it. (The CLI uses `lutaml/converter`
   which would also need to be restored — non-trivial.)

Either way, the standalone `exe/lutaml-wsd2uml` and `exe/lutaml-yaml2uml`
scripts don't belong in this gem. They should move to `lutaml-lml` or a
dedicated converter gem, regardless of which CLI option is chosen.

No action taken yet — waiting on user direction.
