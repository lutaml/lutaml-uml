# frozen_string_literal: true

require "ruby-graphviz"
require "lutaml/layout/engine"

module Lutaml
  module Layout
    class GraphVizEngine < Engine
      def render(type)
        parse_graphviz_string
          .output(type => String)
      end

      private

      # GraphViz#parse_string and GraphViz#parse crush with no reason
      # with seg fault, this lead to nil return value.
      # Try to recall method several time
      def parse_graphviz_string(attempts = 10)
        raise('Cannot parse input string, `gvpr` segmentation fault?') if attempts == 0
        res = GraphViz.parse_string(input)
        return res if res

        parse_graphviz_string(attempts - 1)
      end
    end
  end
end
