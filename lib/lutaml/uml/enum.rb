# frozen_string_literal: true

require "lutaml/uml/has_members"
require "lutaml/uml/classifier"
require "lutaml/uml/association"
require "lutaml/uml/top_element_attribute"

module Lutaml
  module Uml
    class Enum < Classifier
      include HasMembers

      attr_reader :attributes,
                  :members,
                  :modifier

      def attributes=(value)
        @attributes = value.to_a.map do |attr|
          TopElementAttribute.new(attr)
        end
      end

      # TODO: reserved name, change
      def methods
        []
      end

      def keyword
        "enumeration"
      end
    end
  end
end
