# frozen_string_literal: true

module Lutaml
  module UmlRepository
    module Queries
      # Base class for all query services.
      #
      # Provides common functionality for accessing the document and indexes
      # that subclasses can use to implement specific query operations.
      #
      # @example Creating a custom query
      #   class CustomQuery < BaseQuery
      #     def find_something
      #       indexes[:qualified_names]["ModelRoot::MyClass"]
      #     end
      #   end
      #
      #   query = CustomQuery.new(document, indexes)
      #   result = query.find_something
      class BaseQuery
        # Create a new query instance
        #
        # @param document [Lutaml::Uml::Document] The UML document to query
        # @param indexes [Hash] The indexes built by IndexBuilder
        def initialize(document, indexes)
          @document = document
          @indexes = indexes
        end

        protected

        attr_reader :document, :indexes

        # Resolve all associations in the document
        #
        # @return [Array<Lutaml::Uml::Association>] Array of all associations
        def find_class_by_id(class_id)
          indexes[:qualified_names].find do |_qualified_name, entity|
            entity.is_a?(Lutaml::Uml::UmlClass) && entity.xmi_id == class_id
          end
        end

        # Resolve a class object or qualified-name string to the
        # class object. Strings are looked up via the
        # qualified_names index; non-strings pass through.
        #
        # @param class_or_qname [Lutaml::Uml::UmlClass, String]
        # @return [Lutaml::Uml::UmlClass, nil] The class object, or nil
        def resolve_class(class_or_qname)
          if class_or_qname.is_a?(String)
            indexes[Lutaml::UmlRepository::IndexKeys::QUALIFIED_NAMES][class_or_qname]
          else
            class_or_qname
          end
        end
      end
    end
  end
end
