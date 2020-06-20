# frozen_string_literal: true

module Lutaml
  module Uml
    module Representers
      class Model < Package
        attr_accessor :viewpoint

        def initialize
          @contents = []
        end
      end
    end
  end
end
