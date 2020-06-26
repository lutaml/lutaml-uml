# frozen_string_literal: true

require 'lutaml/uml/serializers/base'
require 'lutaml/uml/serializers/class'

module Lutaml
  module Uml
    module Serializers
      class Association < Base
        property :member_end, from: :target
        property :member_end_attribute_name,
                 from: 'relationship',
                 transform_with: (lambda do |val|
                   val.dig('target', 'attributes')&.keys&.first
                 end)
        property :member_end_cardinality,
                 from: 'relationship',
                 transform_with: (lambda do |val|
                   res = val.dig('source', 'attributes')&.values&.first
                   res['cardinality'] if res
                 end)
        property :member_end_type,
                 from: 'relationship',
                 transform_with: (lambda do |val|
                   val.dig('target', 'type')
                 end)
        property :owned_end_attribute_name,
                 from: 'relationship',
                 transform_with: (lambda do |val|
                   val.dig('source', 'attributes')&.keys&.first
                 end)
        property :owned_end_cardinality,
                 from: 'relationship',
                 transform_with: (lambda do |val|
                   res = val.dig('source', 'attributes')&.values&.first
                   res['cardinality'] if res
                 end)
        property :owned_end_type,
                 from: 'relationship',
                 transform_with: (lambda do |val|
                   val.dig('source', 'type')
                 end)
      end
    end
  end
end
