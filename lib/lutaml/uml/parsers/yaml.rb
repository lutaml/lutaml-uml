# frozen_string_literal: true

require 'yaml'
require 'lutaml/uml/class'
require 'lutaml/uml/node/document'
require 'lutaml/uml/serializers/yaml_view'

module Lutaml
  module Uml
    module Parsers
      class Yaml
        def self.parse(io, options = {})
          new.parse(io, options)
        end

        def parse(io, _options = {})
          yaml_parse(io)
        end

        def yaml_parse(io)
          yaml_content = YAML.safe_load(io)
          serialized_yaml = Lutaml::Uml::Serializers::YamlView
                              .new(yaml_content)
          serialized_yaml.classes.map do |klass|
            instance = Lutaml::Uml::Class.new
            instance.name = klass.name
            instance
          end
        end
      end
    end
  end
end
