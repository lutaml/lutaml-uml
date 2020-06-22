# frozen_string_literal: true

require 'lutaml/uml/serializers/base'
require 'lutaml/uml/serializers/class'
require 'lutaml/uml/serializers/relation'

module Lutaml
  module Uml
    module Serializers
      class YamlView < Base
        property :name
        property :title
        property :caption
        property :groups,
                 transform_with: (lambda do |names_groups|
                   names_groups.map do |names|
                     names.map {|name| Class.new({ name: name }) }
                   end
                 end)
        property :classes,
                 coerce: Array[Class],
                 from: :imports,
                 transform_with: ->(entry) { entry.keys.map {|name| { name: name } } }
        property :relations,
                 coerce: Array[Class]
        property :fidelity
      end
    end
  end
end
