# frozen_string_literal: true

module Lutaml
  module Uml
    class Document < Lutaml::Model::Serializable
      include HasAssociations

      skip_reference_registration

      attribute :name, :string
      attribute :title, :string
      attribute :caption, :string
      attribute :groups, Group, collection: true
      attribute :fidelity, Fidelity
      attribute :fontname, :string
      attribute :comments, :string, collection: true

      attribute :classes, UmlClass, collection: true, default: -> { [] }
      attribute :data_types, DataType, collection: true, default: -> { [] }
      attribute :enums, Enum, collection: true, default: -> { [] }
      attribute :packages, Package, collection: true, default: -> { [] }
      attribute :primitives, PrimitiveType, collection: true, default: -> { [] }
      attribute :instances, Instance, collection: true, default: -> { [] }
      attribute :associations, Association, collection: true, default: -> { [] }
      attribute :diagrams, Diagram, collection: true, default: -> { [] }

      yaml do
        map "name", to: :name
        map "title", to: :title
        map "caption", to: :caption
        map "groups", to: :groups
        map "fidelity", to: :fidelity
        map "fontname", to: :fontname
        map "comments", to: :comments

        map "classes", to: :classes
        map "data_types", to: :data_types
        map "enums", to: :enums
        map "packages", to: :packages
        map "primitives", to: :primitives
        map "instances", to: :instances
        map "diagrams", to: :diagrams

        map "associations", to: :associations, with: {
          to: :associations_to_yaml, from: :associations_from_yaml
        }
      end
    end
  end
end
