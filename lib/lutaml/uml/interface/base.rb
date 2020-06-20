# frozen_string_literal: true

require 'optparse'
require 'lutaml/uml/has_attributes'

module Lutaml
  module Uml
    module Interface
      class Base
        def self.run(attributes = {})
          new(attributes).run
        end

        include HasAttributes

        def initialize(attributes = {})
          update(attributes)
        end

        def run
          raise NotImplementedError
        end
      end
    end
  end
end
