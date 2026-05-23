# frozen_string_literal: true

module Lutaml
  module Converter
    module DslToUml
      MEMBER_FACTORIES = {
        packages: :create_uml_package,
        classes: :create_uml_class,
        enums: :create_uml_enum,
        data_types: :create_uml_data_type,
        diagrams: :create_uml_diagram,
        attributes: :create_uml_attribute,
        associations: :create_uml_association,
        operations: :create_uml_operation,
        constraints: :create_uml_constraint,
        values: :create_uml_value
      }.freeze

      def create_uml_document(hash)
        ::Lutaml::Uml::Document.new.tap do |model|
          set_uml_model(model, hash)
        end
      end

      def create_uml_package(hash)
        ::Lutaml::Uml::Package.new.tap do |model|
          set_uml_model(model, hash)
        end
      end

      def create_uml_class(hash)
        ::Lutaml::Uml::Class.new.tap do |model|
          set_uml_model(model, hash)
        end
      end

      def create_uml_enum(hash)
        ::Lutaml::Uml::Enum.new.tap do |model|
          set_uml_model(model, hash)
        end
      end

      def create_uml_data_type(hash)
        ::Lutaml::Uml::DataType.new.tap do |model|
          set_uml_model(model, hash)
        end
      end

      def create_uml_diagram(hash)
        ::Lutaml::Uml::Diagram.new.tap do |model|
          set_uml_model(model, hash)
        end
      end

      def create_uml_attribute(hash)
        ::Lutaml::Uml::TopElementAttribute.new.tap do |model|
          set_uml_model(model, hash)
        end
      end

      def create_uml_cardinality(hash)
        ::Lutaml::Uml::Cardinality.new.tap do |cardinality|
          cardinality.min = hash[:min]
          cardinality.max = hash[:max]
        end
      end

      def create_uml_association(hash)
        ::Lutaml::Uml::Association.new.tap do |model|
          member_end_cardinality = hash.delete(:member_end_cardinality)
          if member_end_cardinality
            model.member_end_cardinality = create_uml_cardinality(
              member_end_cardinality
            )
          end
          owner_end_cardinality = hash.delete(:owner_end_cardinality)
          if owner_end_cardinality
            model.owner_end_cardinality = create_uml_cardinality(
              owner_end_cardinality
            )
          end

          set_uml_model(model, hash)
        end
      end

      def create_uml_operation(hash)
        ::Lutaml::Uml::Operation.new.tap do |model|
          set_uml_model(model, hash)
        end
      end

      def create_uml_constraint(hash)
        ::Lutaml::Uml::Constraint.new.tap do |model|
          set_uml_model(model, hash)
        end
      end

      def create_uml_value(hash)
        ::Lutaml::Uml::Value.new.tap do |model|
          set_uml_model(model, hash)
        end
      end

      def set_uml_model(model, hash)
        hash = create_uml_members(model, hash)
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
            values << value
            model.public_send("#{key}=", values)
          else
            model.public_send("#{key}=", value)
          end
        end
      end

      def create_uml_members(model, hash)
        members = hash.delete(:members)
        members.to_a.each do |member_hash|
          member_hash.each do
            build_members(model, member_hash, :uml)
            set_model_attribute(model, member_hash)
          end
        end
        hash
      end

      private

      def build_members(model, hash, prefix)
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
