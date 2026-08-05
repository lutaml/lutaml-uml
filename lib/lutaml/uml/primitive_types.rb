# frozen_string_literal: true

module Lutaml
  module Uml
    # Shared set of UML primitive type names.
    #
    # Two validators (`Validation::DocumentStructureValidator`,
    # `UmlRepository::Validators::RepositoryValidator`) each
    # defined their own `primitive_type?` with divergent lists.
    # The drift could let one validator accept a type reference
    # that the other rejected. This module is the single source.
    #
    # The list is the union of the two prior lists, preserving
    # backward compatibility for any consumer of either form.
    module PrimitiveTypes
      PRIMITIVE_TYPES = %w[
        String Integer Boolean Date DateTime Float Double
        Long Short Byte Char Time Decimal
        UnlimitedNatural Real
        int string bool date datetime float double
        long short byte char time decimal
      ].freeze

      # @param type [String, nil]
      # @return [Boolean] true if +type+ is a recognized UML primitive
      def primitive_type?(type)
        return false if type.nil?

        PRIMITIVE_TYPES.include?(type.to_s)
      end
    end
  end
end
