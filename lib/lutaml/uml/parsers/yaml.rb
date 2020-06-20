# frozen_string_literal: true

require 'yaml'
require 'lutaml/uml/node/document'

module Lutaml
  module Uml
    module Parsers
      class Yaml
        def self.parse(io, options = {})
          new.parse(io, options)
        end

        def parse(io, _options = {})
          Node::Document.new(yaml_parse(io))
        end

        def yaml_parse(io)
          yaml_content = YAML.safe_load(io)
          import_models = yaml_content['imports'].map do |name|
                            { name: name, members: [] }
                          end
          {
            classes: [
              { name: yaml_content['title'], members: [] }
            ].push(*import_models)
          }
        end
      end
    end
  end
end
