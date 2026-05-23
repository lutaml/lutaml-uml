# frozen_string_literal: true

require_relative 'instance'
require_relative 'instances_import'
require_relative 'instances_export'
require_relative 'collection'

module Lutaml
  module Lml
    class InstanceCollection < Lutaml::Model::Serializable
      attribute :instances, Instance, collection: true, default: []
      attribute :imports, InstancesImport, collection: true, default: []
      attribute :exports, InstancesExport, collection: true, default: []
      attribute :collections, Collection, default: []
    end
  end
end