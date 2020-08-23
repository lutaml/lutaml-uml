# frozen_string_literal: true

require "optparse"
require "lutaml/uml/has_attributes"

module Lutaml
  module Uml
    module Interface
      class Base
        def self.run(attributes = {})
          new(attributes).run
        end

        include HasAttributes

        # rubocop:disable Rails/ActiveRecordAliases
        def initialize(attributes = {})
          update_attributes(attributes)
        end
        # rubocop:enable Rails/ActiveRecordAliases

        def run
          raise NotImplementedError
        end
      end
    end
  end
end
