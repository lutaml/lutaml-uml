# frozen_string_literal: true

require "lutaml/uml/serializers/base"
require "lutaml/uml/serializers/class"

module Lutaml
  module Uml
    module Serializers
      class YamlView < Base
        property :name
        property :title
        property :caption
        property :groups
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
