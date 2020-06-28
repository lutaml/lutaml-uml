# frozen_string_literal: true

require 'lutaml/uml/class'

module Lutaml
  module Uml
    class Document
      include HasAttributes

      attr_accessor :name,
                    :title,
                    :caption,
                    :classes,
                    :groups,
                    :fidelity

      # rubocop:disable Rails/ActiveRecordAliases
      def initialize(attributes = {})
        update_attributes(attributes)
      end
      # rubocop:enable Rails/ActiveRecordAliases

      def classes=(value)
        @classes = value.to_a.map { |attributes| Class.new(attributes) }
      end
    end
  end
end
