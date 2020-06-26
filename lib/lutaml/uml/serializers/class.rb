# frozen_string_literal: true

require 'lutaml/uml/serializers/base'
require 'lutaml/uml/serializers/top_element_attribute'
require 'lutaml/uml/serializers/relation'

module Lutaml
  module Uml
    module Serializers
      class Class < Base
        property :attributes,
                 transform_with: (lambda do |entry|
                   entry
                    .to_a
                    .map do |(name, attributes)|
                      attributes.merge(name: name)
                    end
                 end)
        property :associations,
                 from: :relations,
                 transform_with: (lambda do |entry|
                   entry
                    .to_a
                    .map do |attributes|
                      # TODO: attribute association
                      next if attributes['source']
                      {
                        member_end: attributes['target'],
                        type: attributes.dig('relationship', 'target', 'type')
                      }
                    end
                    .compact
                 end)
        property :name
        # property :type, from: :modelType
        # property :relations,
        #          coerce: Array[Relation]
      end
    end
  end
end
