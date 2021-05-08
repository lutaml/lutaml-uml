# frozen_string_literal: true

module Lutaml
  module Uml
    class DataType < Class
      attr_reader :keyword, :operations

      def initialize(attributes = {})
        super
        @keyword = "dataType"
      end

      def operations=(value)
        @values = value.to_a.map do |attr|
          Operation.new(attr)
        end
      end
    end
  end
end
