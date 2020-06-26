# frozen_string_literal: true

require 'lutaml/uml/serializers/base'
require 'lutaml/uml/serializers/class'

module Lutaml
  module Uml
    module Serializers
      class YamlView < Base
        property :name
        property :title
        property :caption
        # TODO: implement support
        # property :groups,
        #          transform_with: (lambda do |names_groups|
        #            names_groups.map do |names|
        #              names.map {|name| { name: name }) }
        #            end
        #          end)
        property :imports
        # TODO: implement view relations
        # property :relations,
        #          transform_with: (lambda do |entry|
        #                             entry
        #                               .keys
        #                               .map {|name| { type: "association", name: name } }
        #                           end)
        property :fidelity
      end
    end
  end
end
