# frozen_string_literal: true

module Lutaml
  module UmlRepository
    module StaticSite
      module Output
        # Base class for output strategies (Strategy Pattern).
        #
        # This is the seam at which the output-strategy contract lives:
        # every strategy takes `(output_path, config:)` and exposes
        # `#render(spa_document, search_index)`. Two concrete adapters
        # (VueInlinedStrategy, MultiFileStrategy) satisfy this seam.
        #
        # The class earns its keep by:
        # 1. Declaring the constructor signature subclasses must honour.
        # 2. Declaring the abstract `#render` method shape.
        # 3. Holding the shared `@output_path` / `@config` state every
        #    strategy needs.
        #
        # Without this base, the two strategies would drift on
        # constructor signature and the abstract-method shape; the
        # contract would be implicit and the strategy registry
        # (`OUTPUT_STRATEGIES` in Generator) would have nothing to
        # type-check against.
        #
        # @abstract Subclass and implement {#render}
        class Strategy
          def initialize(output_path, config:)
            @output_path = output_path
            @config = config
          end

          # Render output from the given document and search index.
          #
          # @param spa_document [Models::SpaDocument]
          # @param search_index [Models::SpaSearchIndex]
          # @return [String] Path to generated output
          def render(_spa_document, _search_index)
            raise NotImplementedError,
                  "#{self.class} must implement #render"
          end

          private

          attr_reader :output_path, :config
        end
      end
    end
  end
end
