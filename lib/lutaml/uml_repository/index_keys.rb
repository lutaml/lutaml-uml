# frozen_string_literal: true

module Lutaml
  module UmlRepository
    # Named constants for every index key the repository exposes.
    #
    # Query classes, LazyRepository, and StatisticsCalculator all
    # access the `@indexes` Hash by symbol key. Without named
    # constants, a typo silently returned nil and propagated as a
    # NoMethodError far from the source. With named constants, a
    # typo is a NameError at load time.
    #
    # The set of valid keys is the same set registered in
    # `LazyRepository::INDEX_BUILDERS`; the two are kept in sync by
    # the test in `spec/lutaml/uml_repository/index_keys_spec.rb`.
    module IndexKeys
      PACKAGE_PATHS     = :package_paths
      QUALIFIED_NAMES   = :qualified_names
      STEREOTYPES       = :stereotypes
      INHERITANCE_GRAPH = :inheritance_graph
      ASSOCIATIONS      = :associations
      DIAGRAM_INDEX     = :diagram_index

      ALL = [
        PACKAGE_PATHS,
        QUALIFIED_NAMES,
        STEREOTYPES,
        INHERITANCE_GRAPH,
        ASSOCIATIONS,
        DIAGRAM_INDEX,
      ].freeze
    end
  end
end
