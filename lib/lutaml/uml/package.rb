# frozen_string_literal: true

module Lutaml
  module Uml
    class Package < TopElement
      include HasAttributes

      attr_accessor :imports, :contents
      attr_reader :classes, :enums

      def initialize(attributes)
        update_attributes(attributes)
      end

      def classes=(value)
        @classes = value.to_a.map { |attributes| Class.new(attributes) }
      end

      def enums=(value)
        @enums = value.to_a.map { |attributes| Enum.new(attributes) }
      end

      def packages=(value)
        @packages = value.to_a.map { |attributes| Package.new(attributes) }
      end

      def classes
        @classes || []
      end

      def enums
        @enums || []
      end

      def packages
        @packages || []
      end
    end
  end
end
