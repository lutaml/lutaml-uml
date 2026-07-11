# CLAUDE.md — Lutaml::Uml Gem

## Project Overview
`lutaml-uml` provides UML domain models, a repository pattern for querying/presenting UML documents, LUR (`.lur`) package serialization, and a Vue.js SPA static site generator. It is the core UML library used by the `lutaml` meta-bundle.

Sparx EA parsing (QEA, XMI), EA diagram SVG rendering, and the EA → UML bridge live in the companion **`ea`** gem (`https://github.com/lutaml/ea`), which depends on this gem. The XMI schema models live in the **`xmi`** gem (`https://github.com/lutaml/xmi`), used solely by `ea`.

## Testing Constraints

**CRITICAL: Do NOT run the full test suite at once.** It will crash due to memory. Run targeted subsets:
- `bundle exec rspec spec/lutaml/uml/` — UML model specs
- `bundle exec rspec spec/lutaml/uml_repository/` — Repository, presenters, queries, SPA specs
- Combine at most 2-3 suites at a time for targeted verification.

## Code Quality Rules
- Never use `send` (breaks encapsulation). Use `public_send` only when dynamic dispatch is truly necessary.
- Never use `respond_to?` (poor typing). Use `is_a?` for type checks.
- Extract god methods into focused helpers.
- Keep files under ~300 lines. Extract into modules/classes when growing.
- DRY: consolidate duplicated patterns.
- Never commit TODO tracking files to git.

## Spec Require Rules

In this repo, specs should use `require` since the gem's lib is on the load path via bundler:
```ruby
require "spec_helper"
require "lutaml/uml"
require "lutaml/uml_repository"
```

## Architecture
- `lib/lutaml/uml/` — UML domain models (Class, Association, Package, DataType, Enum, etc.)
- `lib/lutaml/uml_repository/` — Repository pattern (queries, presenters, exporters, SPA, web UI)
- `frontend/` — Vue 3 SPA frontend (pre-built dist checked in)
- `templates/` — Liquid templates for web UI
- `config/` — Default SPA configuration

## Sibling gems (separate repos)

| Gem | Direction | Purpose |
|-----|-----------|---------|
| `ea` | depends on us | Sparx EA parsing (QEA, XMI), diagram rendering, EA → UML bridge |
| `xmi` | used only by `ea` | XMI/UML schema models (`Xmi::Sparx::Root`, `Xmi::Uml::*`) |
| `lutaml-model` | we depend on it | Serialization framework |
| `lutaml-lml` | depends on us | LML DSL for authoring UML models |
| `lutaml` | meta-bundle | Bundles `lutaml-uml` + `lutaml-lml` + parsers |

Local development: the `Gemfile` auto-detects `../ea` and uses the local checkout when present (monorepo-style workflow). Set `EA_FORCE_RUBYGEMS=1` to test against the published version.

## SPA Static Site Generator
The SPA generator uses typed models + strategy pattern:
- `DataTransformer` builds a `SpaDocument` from a repository
- `Output::Strategy` subclasses render HTML (single-file or multi-file)
- `Output::VueInlinedStrategy` embeds Vue IIFE + JSON data in single HTML
- Frontend built with Vue 3 + Vite + TypeScript in `frontend/`

## CI Notes
- Ignore Ruby 3.4 ubuntu failures (performance-related, not code issues)
- Ignore macOS job slowness (GitHub Actions is slow for macOS)
