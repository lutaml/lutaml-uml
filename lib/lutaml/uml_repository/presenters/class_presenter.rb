# frozen_string_literal: true

module Lutaml
  module UmlRepository
    module Presenters
      # Presenter for UML Class elements.
      #
      # Formats class information for different output types:
      # text, table rows, and structured data.
      class ClassPresenter < ElementPresenter
        # Generate detailed text view.
        #
        # @return [String] Multi-line formatted text
        def to_text # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
          lines = []
          lines << "Class: #{element.name}"
          lines << ("=" * 50)
          lines << ""
          lines << "Name:        #{element.name}"
          lines << "XMI ID:      #{element.xmi_id}" if
            element.xmi_id
          lines << "Stereotype:  #{stereotype_string}" if
            stereotype_string
          lines << "Abstract:    #{element.is_abstract}"
          lines.join("\n")
        end

        # Generate table row data.
        #
        # @return [Hash] Row data with :type, :name, :details keys
        def to_table_row
          {
            type: "Class",
            name: element.name || "(unnamed)",
            details: stereotype_display,
          }
        end

        # Generate structured hash.
        #
        # @return [Hash] Structured representation
        def to_hash # rubocop:disable Metrics/AbcSize
          data = {
            type: "Class",
            name: element.name,
            is_abstract: !!element.is_abstract,
          }

          data[:xmi_id] = element.xmi_id if element.xmi_id
          data[:stereotype] = stereotype_string if stereotype_string

          data
        end

        private

        # UML stereotype attribute may be a String, Array, or nil.
        # Normalize to a single comma-joined string for display and
        # for hash consumers that expect a scalar.
        def stereotype_string
          raw = element.stereotype
          return nil if raw.nil? || raw.empty?

          case raw
          when Array then raw.join(", ")
          else raw.to_s
          end
        end

        def stereotype_display
          return "" unless stereotype_string

          "<<#{stereotype_string}>>"
        end
      end

      # Register with factory
      PresenterFactory.register(Lutaml::Uml::UmlClass, ClassPresenter)
    end
  end
end
