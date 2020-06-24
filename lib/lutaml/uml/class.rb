# frozen_string_literal: true

require 'lutaml/uml/classifier'
require 'lutaml/uml/association'
require 'lutaml/uml/top_element_attribute'

module Lutaml
  module Uml
    class Class < Classifier
      class UknownMemberTypeError < StandardError; end
      attr_accessor :nested_classifier,
                    :is_abstract
      attr_reader :members,
                  :modifier

      def initialize(attributes={})
        @nested_classifier = []
        @stereotype = []
        @generalization = []
        @is_abstract = false
        super
      end

      def modifier=(value)
        @modifier = value.to_s # TODO: Validate?
      end

      def attributes=(value)
        @members ||= []
        res = value.to_a.map do |attr|
          TopElementAttribute.new(attr)
        end
        @members.push(*res)
      end

      def members=(value)
        @members = value.to_a.map do |(type, attributes)|
          attributes[:parent] = self

          case type
          when :field then TopElementAttribute.new(attributes)
          when :method  then Method.new(attributes) # ?
          when :relationship  then Association.new(attributes)
          when :class_relationship then ClassRelationship.new(attributes)
          else
            raise(UknownMemberTypeError, "Unknown type: #{type}")
          end
        end
      end

      def fields
        @members&.select { |member| member.class == TopElementAttribute } || []
      end

      def methods
        # @members&.select { |member| member.class == Method }
        []
      end

      def relationships
        @members&.select { |member| member.class == Association } || []
      end

      def class_relationships
        # @members&.select { |member| member.class == ClassRelationship }
        []
      end
    end
  end
end
