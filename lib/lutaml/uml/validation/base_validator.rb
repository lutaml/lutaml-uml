# frozen_string_literal: true

module Lutaml
  module Uml
    module Validation
      # Base class for UML-level validators.
      #
      # Provides the validation result and context infrastructure that
      # UML validators need. This is intentionally lightweight — it does NOT
      # depend on any EA-specific code (no Qea, no SQLite, no Sparx).
      #
      # EA-specific validators have their own base at
      # Ea::Qea::Validation::BaseValidator.
      class BaseValidator
        attr_reader :result, :context

        # @param result [Object] Validation result accumulator
        # @param context [Hash] Validation context including :document, etc.
        def initialize(result:, context: {})
          @result = result
          @context = context
        end

        # Performs validation — override in subclasses
        def validate
          raise NotImplementedError,
                "#{self.class} must implement #validate"
        end

        # Runs validation. Result is populated in the shared @result object.
        def call
          validate
        end

        protected

        # @return [Lutaml::Uml::Document, nil]
        def document
          @context[:document]
        end

        # @return [Hash]
        def options
          @context[:options] || {}
        end

        # Adds an error to the validation result
        def add_error(**args)
          @result.add_error(**args)
        end

        # Adds a warning to the validation result
        def add_warning(**args)
          @result.add_warning(**args)
        end

        # Checks if a value is present (not nil and not empty)
        def present?(value)
          return false if value.nil?
          return !value.empty? if value.is_a?(String) || value.is_a?(Array)

          true
        end
      end
    end
  end
end
