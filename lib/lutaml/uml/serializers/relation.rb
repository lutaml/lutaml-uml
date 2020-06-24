# frozen_string_literal: true

require 'lutaml/uml/serializers/base'
require 'lutaml/uml/serializers/class'

module Lutaml
  module Uml
    module Serializers
      class Relation < Base
        property :target
        property :direction
      end
    end
  end
end
