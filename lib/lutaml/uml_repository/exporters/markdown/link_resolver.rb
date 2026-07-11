# frozen_string_literal: true

module Lutaml
  module UmlRepository
    module Exporters
      module Markdown
        class LinkResolver
          include Lutaml::Uml::ModelHelpers

          def initialize(indexes)
            @indexes = indexes
          end

          def package_link(path)
            "../packages/#{sanitize_filename(path)}.md"
          end

          def class_link(qname)
            "../classes/#{sanitize_filename(qname)}.md"
          end

          def package_path(package)
            @indexes&.dig(:package_to_path, package.xmi_id) || package.name
          end

          def qualified_name(klass)
            @indexes&.dig(:class_to_qname, klass.xmi_id) || klass.name
          end

          def sanitize_filename(name)
            name.gsub("::", "_").gsub(/[^a-zA-Z0-9_\-.]/, "_")
          end
        end
      end
    end
  end
end
