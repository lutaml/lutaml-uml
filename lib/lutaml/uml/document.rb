# frozen_string_literal: true

require "lutaml/uml/class"

module Lutaml
  module Uml
    class Document
      class UnknownMemberTypeError < StandardError; end
      include HasAttributes

      attr_accessor :name,
                    :title,
                    :caption,
                    :groups,
                    :fidelity
      attr_reader :classes

      # rubocop:disable Rails/ActiveRecordAliases
      def initialize(attributes = {})
        update_attributes(attributes)
      end
      # rubocop:enable Rails/ActiveRecordAliases

      def members=(value)
        value
          .to_a
          .group_by { |attributes| attributes[:type].to_s }
          .map do |(type, group)|
          public_send("#{associtaion_type(type)}=", group)
        end
      end

      def classes=(value)
        @classes = value.to_a.map { |attributes| Class.new(attributes) }
      end

      private

      def associtaion_type(type)
        return "classes" if type == "class"

        raise(UnknownMemberTypeError, "Unknown member type: #{type}")
      end
    end
  end
end
