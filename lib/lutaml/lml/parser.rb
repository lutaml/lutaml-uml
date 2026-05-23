# frozen_string_literal: true

require_relative 'data_processor'
require "lutaml/uml/parsers/dsl"

module Lutaml
  module Lml
    # Class for parsing LutaML lml into Lutaml::Lml::Document
    class Parser < Uml::Parsers::Dsl
      include Lutaml::Lml::DataProcessor

      MEMBER_FACTORIES = {
        packages: :create_lml_package,
        classes: :create_lml_class,
        enums: :create_lml_enum,
        data_types: :create_lml_data_type,
        diagrams: :create_lml_diagram,
        attributes: :create_lml_attribute,
        associations: :create_lml_association,
        operations: :create_lml_operation,
        constraints: :create_lml_constraint,
        values: :create_lml_value
      }.freeze

      def create_document(hash)
        process_data(hash)
        create_lml_document(hash)
      end

      def create_lml_document(hash)
        ::Lutaml::Lml::Document.new.tap do |model|
          set_lml_model(model, hash)
        end
      end

      def create_lml_instances(model, hash)
        ::Lutaml::Lml::InstanceCollection.new.tap do |collection|
          set_lml_model(collection, hash)
        end
      end

      def create_lml_package(hash)
        ::Lutaml::Lml::Package.new.tap do |model|
          set_lml_model(model, hash)
        end
      end

      def create_lml_class(hash)
        ::Lutaml::Lml::Class.new.tap do |model|
          set_lml_model(model, hash)
        end
      end

      def create_lml_enum(hash)
        ::Lutaml::Lml::Enum.new.tap do |model|
          set_lml_model(model, hash)
        end
      end

      def create_lml_data_type(hash)
        ::Lutaml::Lml::DataType.new.tap do |model|
          set_lml_model(model, hash)
        end
      end

      def create_lml_diagram(hash)
        ::Lutaml::Lml::Diagram.new.tap do |model|
          set_lml_model(model, hash)
        end
      end

      def create_lml_attribute(hash)
        ::Lutaml::Lml::TopElementAttribute.new.tap do |model|
          set_lml_model(model, hash)
        end
      end

      def create_lml_cardinality(hash)
        ::Lutaml::Lml::Cardinality.new.tap do |cardinality|
          cardinality.min = hash[:min]
          cardinality.max = hash[:max]
        end
      end

      def create_lml_association(hash)
        ::Lutaml::Lml::Association.new.tap do |model|
          member_end_cardinality = hash.delete(:member_end_cardinality)
          if member_end_cardinality
            model.member_end_cardinality = create_lml_cardinality(
              member_end_cardinality
            )
          end
          owner_end_cardinality = hash.delete(:owner_end_cardinality)
          if owner_end_cardinality
            model.owner_end_cardinality = create_lml_cardinality(
              owner_end_cardinality
            )
          end

          set_lml_model(model, hash)
        end
      end

      def create_lml_operation(hash)
        ::Lutaml::Lml::Operation.new.tap do |model|
          set_lml_model(model, hash)
        end
      end

      def create_lml_constraint(hash)
        ::Lutaml::Lml::Constraint.new.tap do |model|
          set_lml_model(model, hash)
        end
      end

      def create_lml_value(hash)
        ::Lutaml::Lml::Value.new.tap do |model|
          set_lml_model(model, hash)
        end
      end

      def set_lml_model(model, hash)
        hash = create_lml_members(model, hash)
        set_model_attribute(model, hash)
      end

      def set_model_attribute(model, hash)
        hash.each do |key, value|
          if key == :definition
            value = value.to_s.gsub(/\\}/, "}").gsub(/\\{/, "{")
              .split("\n").map(&:strip).join("\n")
          end

          next unless model.class.attributes.key?(key.to_sym)

          if model.class.attributes[key.to_sym].options[:collection]
            values = model.public_send(key).to_a
            value.is_a?(Array) ? values.concat(value) : values << value
            model.public_send("#{key}=", values)
          else
            model.public_send("#{key}=", value)
          end
        end
      end

      def create_lml_members(model, hash)
        members = hash.delete(:members)
        members.to_a.each do |member_hash|
          member_hash.each do
            create_lml_instances(model, member_hash)
            build_members(model, member_hash)
            set_model_attribute(model, member_hash)
          end
        end
        hash
      end

      private

      def build_members(model, hash)
        MEMBER_FACTORIES.each do |key, factory|
          data = hash.delete(key)
          next if data.nil?

          member = public_send(factory, data)
          collection = model.public_send(key)
          if collection.nil?
            model.public_send("#{key}=", [])
            collection = model.public_send(key)
          end
          collection << member
        end
      end
    end
  end
end
