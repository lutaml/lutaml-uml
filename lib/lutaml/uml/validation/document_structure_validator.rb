# frozen_string_literal: true

module Lutaml
  module Uml
    module Validation
      # Validates UML document tree structure
      # This validator ensures proper nesting, no duplicate names within same
      # parent, and valid type references in the transformed UML tree
      class DocumentStructureValidator < BaseValidator
        include Lutaml::Uml::PrimitiveTypes

        def validate
          return unless document

          validate_package_hierarchy(document.packages || [])
          validate_no_duplicate_names
          validate_type_references
        end

        private

        # Validates package hierarchy recursively
        #
        # @param packages [Array<Lutaml::Uml::Package>] Packages to validate
        # @param parent_path [String] Parent package path for context
        # @return [void]
        def validate_package_hierarchy(packages, parent_path = "") # rubocop:disable Metrics/MethodLength
          packages.each do |package|
            current_path = if parent_path.empty?
                             package.name
                           else
                             "#{parent_path}::#{package.name}"
                           end

            # Validate package structure
            validate_package_structure(package, current_path)

            # Recursively validate child packages
            if package.packages && !package.packages.empty?
              validate_package_hierarchy(package.packages, current_path)
            end
          end
        end

        # Validates individual package structure
        #
        # @param package [Lutaml::Uml::Package] Package to validate
        # @param path [String] Package path for error reporting
        # @return [void]
        def validate_package_structure(package, path) # rubocop:disable Metrics/MethodLength
          # Check for required fields
          unless present?(package.name)
            result.add_error(
              category: :invalid_structure,
              entity_type: :package,
              entity_id: package.xmi_id || "unknown",
              entity_name: "Unnamed",
              field: "name",
              message: "Package at path '#{path}' has no name",
            )
          end

          # Validate children collections are arrays
          validate_collection(package, :classes, path)
          validate_collection(package, :enums, path)
          validate_collection(package, :data_types, path)
          validate_collection(package, :packages, path)
          validate_collection(package, :diagrams, path)
        end

        # Validates that a collection attribute is an array
        #
        # @param package [Lutaml::Uml::Package] Package to check
        # @param attribute [Symbol] Attribute name
        # @param path [String] Package path for error reporting
        # @return [void]
        def validate_collection(package, attribute, path) # rubocop:disable Metrics/MethodLength
          value = package.public_send(attribute)
          unless value.nil? || value.is_a?(Array)
            result.add_error(
              category: :invalid_structure,
              entity_type: :package,
              entity_id: package.xmi_id || "unknown",
              entity_name: package.name,
              field: attribute.to_s,
              message: "Package '#{path}' has invalid #{attribute} " \
                       "(expected Array, got #{value.class})",
            )
          end
        end

        # Validates no duplicate names within same parent
        #
        # @return [void]
        def validate_no_duplicate_names # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
          return unless document

          # Check top-level entities
          check_duplicate_names_in_collection(
            document.classes || [],
            :class,
            "top-level",
          )
          check_duplicate_names_in_collection(
            document.enums || [],
            :enum,
            "top-level",
          )
          check_duplicate_names_in_collection(
            document.data_types || [],
            :data_type,
            "top-level",
          )
          check_duplicate_names_in_collection(
            document.packages || [],
            :package,
            "top-level",
          )

          # Recursively check packages
          (document.packages || []).each do |package|
            validate_package_duplicates(package, "")
          end
        end

        # Validates no duplicate names within a package recursively
        #
        # @param package [Lutaml::Uml::Package] Package to validate
        # @param parent_path [String] Parent path for context
        # @return [void]
        def validate_package_duplicates(package, parent_path) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
          current_path = if parent_path.empty?
                           package.name
                         else
                           "#{parent_path}::#{package.name}"
                         end

          # Check for duplicates within this package
          check_duplicate_names_in_collection(
            package.classes || [],
            :class,
            current_path,
          )
          check_duplicate_names_in_collection(
            package.enums || [],
            :enum,
            current_path,
          )
          check_duplicate_names_in_collection(
            package.data_types || [],
            :data_type,
            current_path,
          )
          check_duplicate_names_in_collection(
            package.packages || [],
            :package,
            current_path,
          )

          # Recursively check child packages
          (package.packages || []).each do |child|
            validate_package_duplicates(child, current_path)
          end
        end

        # Checks for duplicate names in a collection
        #
        # @param collection [Array] Collection to check
        # @param entity_type [Symbol] Type of entities
        # @param context_path [String] Context path for error reporting
        # @return [void]
        def check_duplicate_names_in_collection( # rubocop:disable Metrics/MethodLength
          collection, entity_type, context_path
        )
          name_counts = Hash.new(0)

          collection.each do |entity|
            next unless entity.name

            name_counts[entity.name] += 1
          end

          name_counts.each do |name, count|
            next if count <= 1

            result.add_warning(
              category: :duplicate_name,
              entity_type: entity_type,
              entity_id: "unknown",
              entity_name: name,
              message: "Duplicate #{entity_type} name '#{name}' found " \
                       "#{count} times in #{context_path}",
            )
          end
        end

        # Validates type references in attributes
        #
        # @return [void]
        def validate_type_references # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
          return unless document

          all_classes = extract_all_classes(document)
          all_data_types = extract_all_data_types(document)
          all_enums = extract_all_enums(document)

          # Build a set of all valid type names
          valid_types = Set.new
          all_classes.each { |cls| valid_types << cls.name if cls.name }
          all_data_types.each { |dt| valid_types << dt.name if dt.name }
          all_enums.each { |enum| valid_types << enum.name if enum.name }

          # Check attribute type references
          all_classes.each do |cls, path|
            next unless cls.is_a?(Lutaml::Uml::UmlClass) || cls.is_a?(Lutaml::Uml::DataType)

            (cls.attributes || []).each do |attr|
              next unless attr.type
              next if primitive_type?(attr.type)
              next if valid_types.include?(attr.type)

              result.add_warning(
                category: :invalid_type_reference,
                entity_type: :attribute,
                entity_id: attr.xmi_id || "unknown",
                entity_name: attr.name,
                field: "type",
                reference: attr.type,
                message: "Attribute '#{attr.name}' in class '#{path}' " \
                         "references unknown type '#{attr.type}'",
              )
            end
          end
        end

        # Generic extractor: walks the document tree collecting every
        # entity reachable via +reader_method+ (one of :classes,
        # :data_types, :enums). Used by extract_all_classes /
        # _data_types / _enums below — each is a one-liner that
        # names the reader.
        def extract_all_by(doc, reader_method)
          entities = doc.public_send(reader_method) || []

          (doc.packages || []).each do |pkg|
            extract_from_package_by(pkg, "", reader_method).each do |entity,|
              entities << entity
            end
          end

          entities
        end

        # Recursive helper: yields [entity, full_path] pairs for every
        # entity in +package+ (via +reader_method+) and recurses into
        # sub-packages.
        def extract_from_package_by(package, parent_path, reader_method)
          current_path = parent_path.empty? ? package.name.to_s
                                            : "#{parent_path}::#{package.name}"

          collected = (package.public_send(reader_method) || []).map do |entity|
            [entity, "#{current_path}::#{entity.name || 'Unnamed'}"]
          end

          (package.packages || []).each do |child|
            collected.concat(extract_from_package_by(child, current_path, reader_method))
          end

          collected
        end

        def extract_all_classes(doc)
          extract_all_by(doc, :classes)
        end

        def extract_classes_from_package_with_path(package, parent_path)
          extract_from_package_by(package, parent_path, :classes)
        end

        def extract_all_data_types(doc)
          extract_all_by(doc, :data_types)
        end

        def extract_data_types_from_package_with_path(package, parent_path)
          extract_from_package_by(package, parent_path, :data_types)
        end

        def extract_all_enums(doc)
          extract_all_by(doc, :enums)
        end

        def extract_enums_from_package_with_path(package, parent_path)
          extract_from_package_by(package, parent_path, :enums)
        end
      end
    end
  end
end
