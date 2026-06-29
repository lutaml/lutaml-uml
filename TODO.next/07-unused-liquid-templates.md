# 07 - Unused Liquid Templates (Flag, Don't Delete)

## Status: FLAGGED — preserved per never-delete-source rule

## What
`templates/static_site/` contains 248K of `.liquid` template files:

```
templates/static_site/multi_file.liquid
templates/static_site/single_file.liquid
templates/static_site/components/{tree_node,diagram_viewer,diagram_list,
  content,header,package_details,sidebar,class_details,...}.liquid
```

These were the rendering templates for a Liquid-based static site
generator. That pipeline was replaced by the Vue 3 IIFE strategy
(`lib/lutaml/uml_repository/static_site/output/vue_inlined_strategy.rb`).
The current generator (`static_site/generator.rb`) does not load any
`.liquid` files and does not reference `Liquid::` anywhere.

`grep -rln 'static_site.*liquid\|\.liquid' lib/` → no results.

## Why not delete
Per the global rule "NEVER DELETE source files. ANY source file." The
templates were authored source; their derived output (the Vue strategy)
existing does not make them disposable. They may be repurposed for a
future Liquid-rendered export path, kept as reference for templating
patterns, or moved to a separate gem.

## Suggested resolution (user decision required)
Three options, none taken yet:

1. **Keep in place** — accept that `templates/` ships unused source.
   Zero code change; just document.
2. **Exclude from gem package** — add to gemspec's `spec.files` reject
   list. Source files stay in git but `gem install` no longer ships
   them. Minimal blast radius.
3. **Move to `archive/templates/`** — preserves source on disk, removes
   from primary tree. Requires a small `spec.files` adjustment.

Until the user picks one, leave the files untouched and the gemspec
unchanged.
