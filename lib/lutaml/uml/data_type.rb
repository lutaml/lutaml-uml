# frozen_string_literal: true

module Lutaml
  module Uml
    class DataType < Class
      attr_reader :keyword

      def initialize(attributes = {})
        super
        @keyword = "dataType"
      end
    end
  end
end
