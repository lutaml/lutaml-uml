# frozen_string_literal: true

module Lutaml
  module Uml
    class TopElementAttribute
      include HasAttributes
      include HasMembers

      attr_accessor :name,
                    :visibility,
                    :type,
                    :definition,
                    :contain,
                    :static,
                    :cardinality,
                    :keyword

      # rubocop:disable Rails/ActiveRecordAliases
      def initialize(attributes = {})
        @visibility = "public"
        update_attributes(attributes)
      end
      # rubocop:enable Rails/ActiveRecordAliases
    end
  end
end
