# frozen_string_literal: true

module Lutaml
  module Uml
    class DataType < UmlClassifier
      include HasAssociations

      skip_reference_registration

      attribute :nested_classifier, :string, collection: true,
                                             default: -> { [] }
      attribute :type, :string
      attribute :attributes, TopElementAttribute, collection: true,
                                                   default: -> { [] }
      attribute :modifier, :string
      attribute :constraints, Constraint, collection: true,
                                          default: -> { [] }
      attribute :data_types, DataType, collection: true,
                                       default: -> { [] }
      attribute :relationships, :string, collection: true, default: -> { [] }
      attribute :keyword, :string, default: "dataType"

      attribute :associations, Association, collection: true,
                                            default: -> { [] }

      yaml do
        map "nested_classifier", to: :nested_classifier
        map "is_abstract", to: :is_abstract
        map "type", to: :type

        map "attributes", to: :attributes
        map "modifier", to: :modifier
        map "constraints", to: :constraints
        map "operations", to: :operations
        map "data_types", to: :data_types

        map "relationships", to: :relationships

        map "associations", to: :associations, with: {
          to: :associations_to_yaml, from: :associations_from_yaml
        }
      end
    end
  end
end
