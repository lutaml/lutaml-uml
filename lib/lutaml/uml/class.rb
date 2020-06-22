# frozen_string_literal: true

require 'lutaml/uml/classifier'

module Lutaml
  module Uml
    class Class < Classifier
      attr_accessor :nested_classifier, :is_abstract

      def initialize
        @name = nil
        @xmi_id = nil
        @xmi_uuid = nil
        @nested_classifier = []
        @stereotype = []
        @generalization = []
        @namespace = nil
        @is_abstract = false
      end
    end
  end
end
