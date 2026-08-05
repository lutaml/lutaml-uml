# frozen_string_literal: true

module Lutaml
  module Uml
    # Shared YAML custom serializer for the +associations+ collection.
    #
    # Three classes (Document, UmlClass, DataType) declared identical
    # +associations_to_yaml+ / +associations_from_yaml+ methods. Each
    # writes the owner's name onto association rows that lack one and
    # delegates to +Association.from_yaml+ for the build.
    #
    # Including this mixin provides both methods. The host class
    # still owns the +associations+ attribute declaration and the
    # +yaml+ mapping block entry that names these methods.
    module HasAssociations
      # Serialize +model.associations+ as an array of hashes,
      # skipping the field entirely when the collection is empty.
      def associations_to_yaml(model, doc)
        return unless model.associations

        associations = model.associations.map(&:to_hash)
        doc["associations"] = associations unless associations.empty?
      end

      # Rebuild +model.associations+ from an array of hashes,
      # filling in +owner_end+ from the host's name when missing.
      def associations_from_yaml(model, values)
        associations = values.map do |value|
          value["owner_end"] = model.name if value["owner_end"].nil?
          Association.from_yaml(value.to_yaml)
        end

        model.associations = associations
      end
    end
  end
end
