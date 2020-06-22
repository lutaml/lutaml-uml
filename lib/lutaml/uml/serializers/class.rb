# frozen_string_literal: true

require 'lutaml/uml/serializers/base'

module Lutaml
  module Uml
    module Serializers
      class Class < Base
        property :name
      end
    end
  end
end
