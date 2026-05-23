# frozen_string_literal: true

require "lutaml/uml/document"
require_relative "instance"
require_relative "instance_collection"

module Lutaml
  module Lml
    class Document < Lutaml::Uml::Document
      attribute :instance, Instance
      attribute :requires, :string, collection: true
      attribute :instances, InstanceCollection
    end
  end
end
