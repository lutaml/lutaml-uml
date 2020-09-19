# frozen_string_literal: true

require "ruby-graphviz"
require "lutaml/layout/engine"

module Lutaml
  module Layout
    class GraphVizEngine < Engine
      def render(type)
        GraphViz
          .parse_string(input)
          .output(type => String)
      end
    end
  end
end
